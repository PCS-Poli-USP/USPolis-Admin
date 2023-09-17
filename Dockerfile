FROM nikolaik/python-nodejs

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install sudo -y

RUN useradd -m -s /bin/bash uspolis \
    && echo 'uspolis ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && usermod -aG sudo uspolis

WORKDIR /home/uspolis

COPY . /home/uspolis/

RUN chown -R uspolis:uspolis /home/uspolis

# install frontend dependencies
RUN npm -C USPolis-Admin-Frontend install
RUN mkdir -p ./USPolis-Admin-Frontend/node_modules/.cache \
    && chmod -R 777 ./USPolis-Admin-Frontend/node_modules/.cache

# install backend dependencies
RUN pip install --no-cache-dir -r USPolis-Admin-Backend/requirements.txt

USER uspolis

EXPOSE 3000 5000

RUN chmod +x ./stop-script.sh ./start-script.sh

CMD ./start-script.sh
