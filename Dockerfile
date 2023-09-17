FROM ubuntu:20.04

RUN apt update \
&& apt install sudo -y

RUN useradd -m -s /bin/bash uspolis \
&& echo 'uspolis ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
&& usermod -aG sudo uspolis

WORKDIR /home/uspolis

# installing packages
RUN apt install python3 python3-pip node npm -y

COPY . /home/uspolis/

RUN chown -R uspolis:uspolis /home/uspolis

USER uspolis

# install backend dependencies
RUN pip install --no-cache-dir -r USPolis-Admin-Backend/requirements.txt

# install frontend dependencies
RUN npm -C USPolis-Admin-Frontend install

EXPOSE 5000 8080

CMD chmod +x ./stop-script.sh ./start-script.sh && ./start-script.sh
