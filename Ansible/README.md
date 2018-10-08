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
- [Playbook](https://github.com/SERIY1337/ansible-deploy-amazon-openvpn/blob/staging/playbooks/prepare-amazon-environment.yml)
- [Role](https://github.com/SERIY1337/ansible-deploy-amazon-openvpn/tree/staging/roles/prepare-amazon-environment)
> What is doing this role
> - Create VPC
> - Create IGW
> - Create Subnet
> - Create Route table
> - Create Security group
> - Create Key-pair
> - Save key-pair in local file (destination see in variables file - [vars](https://github.com/SERIY1337/ansible-deploy-amazon-openvpn/blob/staging/roles/prepare-amazon-environment/vars/main.yml))
> - Write some variable in 'deploy amazon instances' role (see [handlers](https://github.com/SERIY1337/ansible-deploy-amazon-openvpn/blob/staging/roles/prepare-amazon-environment/handlers/main.yml))

#### Deploy amazon instances
- [Playbook](https://github.com/SERIY1337/ansible-deploy-amazon-openvpn/blob/staging/playbooks/deploy-amazon-instances.yml)
- [Role](https://github.com/SERIY1337/ansible-deploy-amazon-openvpn/tree/staging/roles/deploy-amazon-instances)
> What is doing this role
> - Check available instances
> - Create multiple instances (count you set yourself via variable openvpn_users in [vars](https://github.com/SERIY1337/ansible-deploy-amazon-openvpn/blob/staging/roles/deploy-amazon-instances/vars/main.yml))
>   - Note! If instance tag already exists task will be failed with this message:
     ![](https://i.imgur.com/YBj7yfX.png)
>  - Associate new elastic ip to each create instance
>  - Create local file structure
>    - Add instances alias name to hosts file
>    - Create group variables file in dir 'group_vars'
>    - Create hosts variables file in dir 'host_vars'
>    - Write public dns name and tags.Name[0], example 'seriy', in each host alias
>    - Save instances information in csv file eg instance_id, public and privat ip etc

#### Install docker
- [Playbook](https://github.com/SERIY1337/ansible-deploy-amazon-openvpn/blob/staging/playbooks/install-docker.yml)
- [Role](https://github.com/SERIY1337/ansible-deploy-amazon-openvpn/tree/staging/roles/install-docker)

> What is doing this role
> - Install docker and docker-compose on each host in '[amazon-services]' group

#### Push docker
- [Playbook](https://github.com/SERIY1337/ansible-deploy-amazon-openvpn/blob/staging/playbooks/push-docker.yml)
- [Role](https://github.com/SERIY1337/ansible-deploy-amazon-openvpn/tree/staging/roles/push-docker)
> What is doing this role
>  - Create dir tree for openvpn service
>  - Copy docker templates and files to created dir tree
>  - Build docker image
>  - Create local docker network
>  - Configuration easy-rsa (see in [openvpn_deploy](https://github.com/SERIY1337/ansible-deploy-amazon-openvpn/blob/staging/roles/push-docker/templates/openvpn_deploy.j2))
>  - Up container on port 443
- Files for docker environment
  - [docker-compose.yml](https://github.com/SERIY1337/ansible-deploy-amazon-openvpn/blob/staging/roles/push-docker/templates/docker-compose.j2)
  - [Dockerfile](https://github.com/SERIY1337/ansible-deploy-amazon-openvpn/blob/staging/roles/push-docker/files/Dockerfile)
- Files for openvpn environment 
  - [openvpn_deploy](https://github.com/SERIY1337/ansible-deploy-amazon-openvpn/blob/staging/roles/push-docker/templates/openvpn_deploy.j2)
  - [openvpn_up](https://github.com/SERIY1337/ansible-deploy-amazon-openvpn/blob/staging/roles/push-docker/files/openvpn_up)
  - [server.conf](https://github.com/SERIY1337/ansible-deploy-amazon-openvpn/blob/staging/roles/push-docker/files/server.conf)
  - [vars](https://github.com/SERIY1337/ansible-deploy-amazon-openvpn/blob/staging/roles/push-docker/files/vars)
### Installations steps
---
```sh
cd /etc/ansible
ansible-playbook playbooks/prepare-amazon-environment.yml
ansible-playbook playbooks/deploy-amazon-instances.yml
ssh-agent bash
ssh-add host-keys/amazon-services.pem
ansible-playbook playbooks/install-docker.yml
ansible-playbook playbooks/push-docker.yml
```
#### After successful deploying, you will get the following tree
![](https://i.imgur.com/dmx76k2.png)
