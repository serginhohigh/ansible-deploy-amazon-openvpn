# Requirments:
  - boto
  - boto3
  - aws secret and access key
  - /etc/ansible/group_vars/amazon-services:
    - ansible_user: ubuntu
    - ansible_ssh_private_key: /etc/ansible/host-keys/amazon-services.pem

# Installiation step:
1. ansible-playbook playbooks/prepare-amazon-environment.yml
2. ansible-playbook playbooks/deploy-amazon-instances.yml
3. ansible-playbook playbooks/install-docker.yml
4. ansible-playbook playbooks/push-docker.yml
