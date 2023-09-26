#!/bin/bash

python3 ./USPolis-Admin-Backend/wsgi.py &
rm backend-pid
echo "$!" >> backend-pid

npm -C ./USPolis-Admin-Frontend/ run start &
rm frontend-pid
echo "$!" >> frontend-pid

tail -f /dev/null
