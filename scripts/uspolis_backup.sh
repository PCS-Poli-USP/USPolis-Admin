#!/usr/bin/env bash
#-------------------------------------------------------------
# Script   :
# Descrição:
# Versâo   : 0.1.0
# Autor    : Gabriel Di Vanna Camargo <gabriel_camargo@usp.br>
# Data     : 19/08/2025
# Licença  :
#-------------------------------------------------------------
# Uso: sudo -u postgres ./uspolis_backup.sh --type=incr|full
#-------------------------------------------------------------

LOGDIR="/var/lib/pgbackrest/logs"
LOGFILE="script-backup.log"
BACKUPDIR="/var/lib/pgbackrest/"
REMOTE="uspolis-gdrive"
REMOTEDIR="Database"
RCLONECONFIG="/var/lib/rclone/rclone.conf"

TYPE=""

#------------ Checagem de usuário e args corretos ----------- #

if [ "$(whoami)" != "postgres" ]; then
    echo "Execute usando usuário postgres!"
    exit 1
fi

for ARG in "$@"; do
    case $ARG in
        --type=*)
        TYPE="${ARG#*=}"
        shift
        ;;
        *)
        echo "Argumento desconhecido: $ARG"
        shift
        ;;
    esac
done

if [[ -z "$TYPE" ]]; then
    echo "Erro: você deve informar --type=full ou --type=incr"
    exit 1
fi

#------------ Realização do Backup ----------- #

NOW=$(date +"%Y-%m-%d %H:%M:%S")

mkdir -p "$LOGDIR"  # garante que o diretório existe
echo -e "[$NOW] Rodando backup do tipo ${TYPE}..." >> "$LOGDIR/$LOGFILE"

UPLOAD=0

if [[ "$TYPE" == "full" ]]; then
    UPLOAD=1
    pgbackrest --stanza=main --type=full backup >> "$LOGDIR/$LOGFILE" 2>&1
elif [[ "$TYPE" == "incr" ]]; then
    UPLOAD=1
    pgbackrest --stanza=main --type=incr backup >> "$LOGDIR/$LOGFILE" 2>&1
else
    echo "Tipo de backup desconhecido: $TYPE" >> "$LOGDIR/$LOGFILE"
    exit 1
fi


STATUS=$?
if [[ $STATUS -ne 0 ]]; then
    NOW=$(date +"%Y-%m-%d %H:%M:%S")
    echo -e "[$NOW] ERRO: backup do tipo ${TYPE} falhou (status=$STATUS). Upload não será realizado.\n" >> "$LOGDIR/$LOGFILE"
    echo -e "Subject: ERRO NO BACKUP\n\n[$NOW] ERRO: backup do tipo ${TYPE} falhou (status=$STATUS). Upload não será realizado.\n" | msmtp -a gmail uspolis@usp.br
    exit 1
fi

#------------ Upload para o GoogleDrive ----------- #

NOW=$(date +"%Y-%m-%d %H:%M:%S")
echo -e "[$NOW] Carregando backup para o GoogleDrive..." >> "$LOGDIR/$LOGFILE"

if [[ "$UPLOAD" -eq 1 ]]; then
    rclone --config="$RCLONECONFIG" copy "$BACKUPDIR" "$REMOTE:$REMOTEDIR" --transfers=16 \
  	--checkers=16 \
  	--drive-chunk-size=32M \
  	--fast-list \
  	--copy-links \
  	--checksum \
  	--log-file="$LOGDIR/$LOGFILE"
fi

STATUS=$?
if [[ $STATUS -ne 0 ]]; then
    NOW=$(date +"%Y-%m-%d %H:%M:%S")
    echo -e "[$NOW] ERRO: Upload para o GoogleDrive falhou (status=$STATUS).\n" >> "$LOGDIR/$LOGFILE"
    echo -e "Subject: ERRO NO BACKUP\n\n[$NOW] ERRO: Upload para o GoogleDrive falhou (status=$STATUS).\n" | msmtp -a gmail uspolis@usp.br
    exit 1
fi

#------------ Log final ----------- #

NOW=$(date +"%Y-%m-%d %H:%M:%S")
echo -e "[$NOW] Finalizando backup do tipo ${TYPE}...\n" >> "$LOGDIR/$LOGFILE"

exit 0
