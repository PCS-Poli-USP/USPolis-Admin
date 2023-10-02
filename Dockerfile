FROM nikolaik/python-nodejs

ENV DEBIAN_FRONTEND=noninteractive

ARG BACKEND_REPO=https://github.com/PCS-Poli-USP/USPolis-Admin-Backend.git
ARG FRONTEND_REPO=https://github.com/PCS-Poli-USP/USPolis-Admin-Frontend.git
ARG BACKEND_DIR=USPolis-Admin-Backend
ARG FRONTEND_DIR=USPolis-Admin-Frontend
ARG USER=uspolis

RUN apt-get update \
    && apt-get install sudo git curl wget -y

RUN useradd -m -s /bin/bash ${USER}\
    && echo '${USER} ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && echo "$USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER

WORKDIR /home/${USER}/applications

COPY . /home/${USER}/applications

RUN chown -R ${USER}:${USER} /home/${USER}

RUN echo "fs.inotify.max_user_watches=524288" >> /etc/sysctl.conf

USER ${USER}

# clone repos
RUN git clone ${BACKEND_REPO} && git clone ${FRONTEND_REPO}

# install frontend dependencies
RUN npm -C ${FRONTEND_DIR} install
RUN mkdir -p ./${FRONTEND_DIR}/node_modules/.cache \
    && chmod -R 777 ./${FRONTEND_DIR}/node_modules/.cache

# install backend dependencies
RUN pip install --no-cache-dir -r $BACKEND_DIR/requirements.txt

EXPOSE 3000 5000

RUN chmod +x ./stop-script.sh ./start-script.sh

CMD ./start-script.sh
