using '../src/network.bicep'
param location = 'canadacentral'
param appName = 'myapp'
param env = 'dev'
param vnet_cidr = [
  '192.168.0.0/25'
]
param azSubnet_apgw_ip_cidr ='192.168.0.0/27'
param azSubnet_web_01_ip_cidr ='192.168.0.32/27'
param azSubnet_web_02_ip_cidr='192.168.0.64/27'
