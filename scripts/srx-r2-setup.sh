configure
set routing-options autonomous-system 65412
set system login user netconf class super-user
set system login user netconf authentication encrypted-password "$1$Mlbglu9w$868an8LZvZ/tIN3MB.tGX/"
set interfaces lo0.0 family inet address 10.11.12.2/32
set protocols ospf area 0.0.0.0 interface ge-0/0/1.0
set protocols ospf area 0.0.0.0 interface lo0.0 passive
set protocols ldp interface ge-0/0/1.0
set protocols mpls interface ge-0/0/1.0
set protocols bgp group IBGP-MESH type internal
set protocols bgp group IBGP-MESH local-address 10.11.12.2
set protocols bgp group IBGP-MESH log-updown
set protocols bgp group IBGP-MESH family inet-vpn unicast
set protocols bgp group IBGP-MESH family inet unicast
set protocols bgp group IBGP-MESH neighbor 10.11.12.1
set protocols bgp group IBGP-MESH export EXPORT-DIRECT
set policy-options prefix-list R2-DIRECT 192.168.10.0/24
set policy-options policy-statement EXPORT-DIRECT term R2-DIRECT from protocol direct
set policy-options policy-statement EXPORT-DIRECT term R2-DIRECT from prefix-list R2-DIRECT
set policy-options policy-statement EXPORT-DIRECT term R2-DIRECT then accept
commit and-quit
