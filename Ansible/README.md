:shipit:
# Deploy multiple openvpn instances via ansible

### Requirments
 - boto
 - boto3
 - ansible version => 2.5
 - aws access and secret key

### Roles
---
#### Prepare amazone environment for deploy instances
- [Playbook](./playbooks/prepare-amazon-environment.yml)
- [Role](./roles/prepare-amazon-environment)
> What is doing this role
> - Create VPC
> - Create IGW
> - Create Subnet (same as vpc cidr)
> - Create Route table
> - Create Security group with curstom rules (look in variables file - [vars](./roles/prepare-amazon-environment/vars/main.yml))
> - Create Key-pair
> - Save key-pair in local file (look in variables file - [vars](./roles/prepare-amazon-environment/vars/main.yml))
> - Write some variables in 'deploy-amazon-proxy-instances' and 'deploy-amazon-openvpn-instances' roles (look in [handlers](./roles/prepare-amazon-environment/handlers/main.yml))

#### Deploy amazon proxy instances
- [Playbook](./playbooks/deploy-amazon-proxy-instances.yml)
- [Role](./roles/deploy-amazon-proxy-instances/)
> What is doing this role
> - Check available instances
> - Create multiple t2.medium instances (count you set yourself via variable openvpn_users in [vars](./roles/deploy-amazon-proxy-instances/vars/main.yml))
>   - Note! If instance tag already exists task will be failed with this message:
     ![](https://i.imgur.com/YBj7yfX.png)
>  - Associate new elastic ip to each create instance

#### Deploy amazon openvpn instances
- [Playbook](./playbooks/deploy-amazon-openvpn-instances.yml)
- [Role](./roles/deploy-amazon-openvpn-instances)
> What is doing this role
> - Check available instances
> - Create multiple instances (count you set yourself via variable openvpn_users in [vars](./roles/deploy-amazon-openvpn-instances/vars/main.yml))
>   - Note! If instance tag already exists task will be failed with this message:
     ![](https://i.imgur.com/YBj7yfX.png)
>  - Associate new elastic ip to each create instance
>  - Create local file structure
>    - Add instances alias name to hosts file
>    - Create group variables file in dir 'group_vars'
>    - Create hosts variables file in dir 'host_vars'
>    - Write some variables in each host file (look in [handlers](./roles/deploy-amazon-openvpn-instances/handlers/main.yml))
>    - Save instances information in csv file eg instance_id, public and privat ip etc

#### Configure proxy instances
- [Playbook](./playbooks/configure-proxy-instances.yml)
- [Role](./roles/configure-proxy-instances)
> What is doing this role
> - Install strongswan, keepalived and copy their configuration files to target instance
> - Install and configure unattended-upgares for automatiс security updates on each instance
> - Enable listed above services
- Files for strongswan
  - [openvpn-proxy01.ipsec.conf](./roles/configure-proxy-instances/templates/openvpn-proxy01.ipsec.conf)
  - [openvpn-proxy01.ipsec.secrets](./roles/configure-proxy-instances/templates/openvpn-proxy01.ipsec.secrets)
  - [openvpn-proxy02.ipsec.conf](./roles/configure-proxy-instances/templates/openvpn-proxy02.ipsec.conf)
  - [openvpn-proxy02.ipsec.secrets](./roles/configure-proxy-instances/templates/openvpn-proxy02.ipsec.secrets)
- Files for keepalived
  - [openvpn-proxy01.keepalived.conf](./roles/configure-proxy-instances/templates/openvpn-proxy01.keepalived.conf)
  - [openvpn-proxy01.master.sh](./roles/configure-proxy-instances/templates/openvpn-proxy01.master.sh)
  - [openvpn-proxy01.backup.sh](./roles/configure-proxy-instances/templates/openvpn-proxy01.backup.sh)
  - [openvpn-proxy02.keepalived.conf](./roles/configure-proxy-instances/templates/openvpn-proxy02.keepalived.conf)
  - [openvpn-proxy02.master.sh](./roles/configure-proxy-instances/templates/openvpn-proxy02.master.sh)
  - [openvpn-proxy02.backup.sh](./roles/configure-proxy-instances/templates/openvpn-proxy02.backup.sh)

#### Configure openvpn instances
- [Playbook](./playbooks/configure-openvpn-instances.yml)
- [Role](./roles/configure-openvpn-instances/)
> What is doing this role
> - Install docker and docker-compose on each host in '[amazon-openvpn-instances]' group
> - Install and configure unattended-upgares for automatiс security updates on each instance

#### Push docker
- [Playbook](./playbooks/push-docker.yml)
- [Role](./roles/push-docker/)
> What is doing this role
>  - Create dir tree for openvpn service
>  - Copy docker templates and files to created dir tree
>  - Build docker image
>  - Create local docker network
>  - Configuration easy-rsa (see in [openvpn_deploy](./roles/push-docker/templates/openvpn_deploy.j2))
>  - Up container on port 443
>  - Copy ca.crt, ta.key and client certificate to ansible host folder
- Files for docker environment
  - [docker-compose.yml](./roles/push-docker/templates/docker-compose.j2)
  - [Dockerfile](./roles/push-docker/files/Dockerfile)
- Files for openvpn environment 
  - [openvpn_deploy](./roles/push-docker/templates/openvpn_deploy.j2)
  - [openvpn_up](./roles/push-docker/files/openvpn_up)
  - [server.conf](./roles/push-docker/files/server.conf)
  - [vars](./roles/push-docker/vars/main.yml)
### Installations steps
---
```sh
cd /etc/ansible
ansible-playbook playbooks/prepare-amazon-environment.yml
ansible-playbook playbooks/deploy-amazon-proxy-instances.yml
ansible-playbook playbooks/deploy-amazon-openvpn-instances.yml
ssh-agent bash
ssh-add host-keys/amazon-services.pem
ansible-playbook playbooks/configure-proxy-instances.yml
ansible-playbook playbooks/configure-openvpn-instances.yml
ansible-playbook playbooks/push-docker.yml
```
#### After successful deploying, you will get the following tree
![](https://i.imgur.com/dmx76k2.png)
