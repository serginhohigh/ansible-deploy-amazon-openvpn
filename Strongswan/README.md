# Strongswan configuration for two proxy instances

In this case, these are just templates that will not work without a strongswan configuration on the other side. Example I'll throw a little later:pensive:  
But if you understand strgonswan ipsec, it’s easy for you to use these templates and configure at least AWS ec2 side. All you need is to change the following lines in [openvpn-proxy01.ipsec.conf](openvpn-proxy01.ipsec.conf),[openvpn-proxy02.ipsec.conf](openvpn-proxy02.ipsec.conf), [openvpn-proxy01.ipsec.secrets](openvpn-proxy01.ipsec.secrets) and [openvpn-proxy02.ipsec.secrets](openvpn-proxy02.ipsec.secrets) configuration files:
- 'YOUR LOCAL PRIVATE IP'
- 'YOUR LOCAL SUBNET'
- 'YOUR REMOTE TARGET PUBLIC IP'
- 'YOUR REMOTE SUBNET'
- 'YOUR PSK KEY'
