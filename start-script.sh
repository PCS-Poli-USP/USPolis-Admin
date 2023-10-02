#!/bin/bash

python3 ./USPolis-Admin-Backend/wsgi.py &
echo "$!" > backend-pid

npm -C ./USPolis-Admin-Frontend/ run start &
echo "$!" > frontend-pid

tail -f /dev/null
