# Deploy multiple openvpn instances via ansible


### Requirments:
  - boto
  - boto3
  - aws secret and access key
  - /etc/ansible/group_vars/amazon-services:
    - ansible_user: ubuntu
    - ansible_ssh_private_key: /etc/ansible/host-keys/amazon-services.pem

### Installiation step:
`ansible-playbook playbooks/prepare-amazon-environment.yml
ansible-playbook playbooks/deploy-amazon-instances.yml
ansible-playbook playbooks/install-docker.yml
ansible-playbook playbooks/push-docker.yml`
