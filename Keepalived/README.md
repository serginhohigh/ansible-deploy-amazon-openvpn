# Keepalived configuration for two proxy instances

This is a simple keepalived configuration beetween 2 proxy instances. To do this on AWS ec2 was enough problematically, but i done it:blush:   
The essence of the problem is that ip broadcast and multicast does not work on AWS ec2 and the crutch hint which I found somewhere on the Internet is to use ec2-api-tools. I took the example of a stranger and used it as a lever for reassign virtual ip-address when one of my proxy is down. And its working. Thanks, stranger:thumbsup:

How use it on your system? It's easy
- create your IAM account in AWS with persmission for assign private ip addresses  
- replace next strings in [openvpn-proxy01.keepalived.conf](openvpn-proxy01.keepalived.conf) and [openvpn-proxy02.keepalived.conf](openvpn-proxy02.keepalived.conf) configuration files
  - 'YOUR EMAIL RECEIVER'
  - 'YOUR EMAIL SENDER'
  - 'YOUR SMTP SERVER'
  - 'YOUR MASTER VIP'
  - 'YOUR SECOND PROXY PRIVATE IP'
  - 'YOUR FIRST PROXY PRIVATE IP'
  - 'YOUR BACKUP VIP'
  - 'YOUR PASSWORD vri 40'
  - 'YOUR PASSWORD vri 41'
- replace next strings in [openvpn-proxy01.master.sh](openvpn-proxy01.master.sh), [openvpn-proxy01.backup.sh](openvpn-proxy01.backup.sh), [openvpn-proxy02.master.sh](openvpn-proxy02.master.sh), [openvpn-proxy02.backup.sh](openvpn-proxy02.backup.sh) configuration files
  - 'YOUR MASTER VIP'
  - 'YOUR BACKUP VIP'
  - 'YOUR ACCESS KEY'
  - 'YOUR SECRET KEY'

Ready example you can get in ansible role 'configure proxy instances' in [templates folder](../Ansible/roles/configure-proxy-instances/templates/)
