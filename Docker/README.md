# Openvpn service inside docker container

This is a simple openvpn service running in docker container.
To use this you must complete the following steps:
 - clone this repo to your local storage, example '/tmp'
   ```sh
   cd /tmp
   git clone https://github.com/skarachevtsev/ansible-deploy-amazon-openvpn.git
   ```
 - create folder for your docker service, example in '/opt' folder
   ```
   mkdir /opt/openvpn
   ```
 - copy all docker files to your '/opt/openvpn' folder
   ```
   cp -r ansible-deploy-amazon-openvpn/Docker/* /opt/openvpn
   ```
 - build local docker image
   ```sh
   cd /opt/openvpn
   docker build . -t custom/openvpn
   ```
 - replace variables 'YOUR FQDN' and 'YOUR OPENVPN USER' in 'bin/openvpn_deploy'
 - configure easy-rsa for your openvpn serivice
   ```sh
   docker-compose run --rm openvpn openvpn_deploy
   ```
 - start your service
   ```sh
   docker-compose up -d
   ```
