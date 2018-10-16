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
> - Create Security group with custom firewall rules (look in variables file - [vars](./roles/prepare-amazon-environment/vars/main.yml))
> - Create Key-pair
> - Save key-pair in local file (look in variables file - [vars](./roles/prepare-amazon-environment/vars/main.yml))
> - Write some variables in 'deploy-amazon-proxy-instances' and 'deploy-amazon-openvpn-instances' roles (look in [handlers](./roles/prepare-amazon-environment/handlers/main.yml))

#### Deploy amazon proxy instances
- [Playbook](./playbooks/deploy-amazon-proxy-instances.yml)
- [Role](./roles/deploy-amazon-proxy-instances/)
> What is doing this role
> - Check available instances
> - Create multiple t2.medium instances (count you set yourself via variable openvpn_proxy in [vars](./roles/deploy-amazon-proxy-instances/vars/main.yml))
>   - Note! If instance tag already exists task will be failed with this message:
     ![](https://i.imgur.com/YBj7yfX.png)
>  - Associate new elastic ip to each create instance

#### Deploy amazon openvpn instances
- [Playbook](./playbooks/deploy-amazon-openvpn-instances.yml)
- [Role](./roles/deploy-amazon-openvpn-instances)
> What is doing this role
> - Check available instances
> - Create multiple t2.micro instances (count you set yourself via variable openvpn_users in [vars](./roles/deploy-amazon-openvpn-instances/vars/main.yml))
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
>  - Copy ca.crt, ta.key and client certificate to ansible host 'client-keys' folder
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
For everything to work out of the box you need:
- Create an account in AWS IAM for ansible and keepalived (assign ip address via ec2 api). After that you should to change my demonstrative aws keys in keepalived configurations files.
- Change remote_target and remote_subnet variable to correctly initialize ipsec tunnel (look in configure-proxy-instances [role](./roles/configure-proxy-instances/).

If you changed vpc cidr, then you should understand that you will have to make many changes to the configuration files (described below). **Be careful with this!**

> VPC, subnet and firewall rules
> - By default cidr of vpc and subnet is 10.50.0.0/23 (if you want change this in [vars](./roles/prepare-amazon-environment/vars/main.yml))
> - If you want add custom firewall rules - append them to [vars](./roles/prepare-amazon-environment/vars/main.yml)

> Proxy instances configuration
> - By default proxy instances type is t2.medium. If you want change this in [vars](./roles/deploy-amazon-proxy-instances/vars/main.yml)
> - By default proxy instances ip addresses is 10.50.0.254 for first and 10.50.1.254 for second instance. If you want change this in [vars](./roles/deploy-amazon-proxy-instances/vars/main.yml)
> - By default proxy instances tags is proxy01 and proxy02. If you want change this in [vars](./roles/deploy-amazon-proxy-instances/vars/main.yml). But remember that if the tag does not contain numbers at the end, then the task may be fail

> Openvpn instances configuration
> - By default proxy instances type is t2.medium. If you want change this in [vars](./roles/deploy-amazon-openvpn-instances/vars/main.yml)
> - By default openvpn instances tags is [vasyan, petyan, nikitos]. Change this in [vars](./roles/deploy-amazon-openvpn-instances/vars/main.yml)

> Strongwan
> - Set your public ip address of remote ipsec host in variable target_ip (there [vars](./roles/configure-proxy-instances/vars/main.yml))
> - By default remote subnet is 172.16.0.0/16 and local is 10.50.0.0/23. Change remote subnet to your local subnet in your network and local subnet if you changed this in '*VPC, subnet and firewall rules*' article
> - After that you should change ipsec PSK and local ip address (if you changed) in the following configuration files
>   - [openvpn-proxy01.ipsec.secrets](./roles/configure-proxy-instances/templates/openvpn-proxy01.ipsec.secrets)
>   - [openvpn-proxy02.ipsec.secrets](./roles/configure-proxy-instances/templates/openvpn-proxy02.ipsec.secrets)

> Keepalived
> - You shoud create IAM keys (permissions to assign private ip to instances) and add generated keys in the following configuration files
>   - [openvpn-proxy01.master.sh](./roles/configure-proxy-instances/templates/openvpn-proxy01.master.sh)
>   - [openvpn-proxy01.backup.sh](./roles/configure-proxy-instances/templates/openvpn-proxy01.backup.sh)
>   - [openvpn-proxy02.master.sh](./roles/configure-proxy-instances/templates/openvpn-proxy02.master.sh)
>   - [openvpn-proxy02.backup.sh](./roles/configure-proxy-instances/templates/openvpn-proxy02.backup.sh)
> - If you change default proxy instances ip address you should  to make a change in the following configuration files
>   - [openvpn-proxy01.master.sh](./roles/configure-proxy-instances/templates/openvpn-proxy01.master.sh)
>   - [openvpn-proxy01.backup.sh](./roles/configure-proxy-instances/templates/openvpn-proxy01.backup.sh)
>   - [openvpn-proxy02.master.sh](./roles/configure-proxy-instances/templates/openvpn-proxy02.master.sh)
>   - [openvpn-proxy02.backup.sh](./roles/configure-proxy-instances/templates/openvpn-proxy02.backup.sh)
>   - [openvpn-proxy01.keepalived.conf](./roles/configure-proxy-instances/templates/openvpn-proxy01.keepalived.conf)
>   - [openvpn-proxy02.keepalived.conf](./roles/configure-proxy-instances/templates/openvpn-proxy02.keepalived.conf)

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
