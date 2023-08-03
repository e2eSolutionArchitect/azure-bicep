using '../src/vm.bicep'
param location = 'canadacentral'
param appName = 'myapp'
param env = 'dev'

param authenticationType = 'sshPublicKey'
param securityType = 'TrustedLaunch'
param adminUsername = 'azureuser'
param adminPasswordOrKey = 'myadminpassword'
param vmSize = ['Standard_D2as_v4','Standard_B1ls']
param vmCount = 2
param vmImagePublisher = 'Canonical'
param vmImageOffer = '0001-com-ubuntu-server-jammy'
param vmImageSku = '22_04-lts-gen2'
param vmImageVersion = 'latest'
param vmDiskType = 'Standard_LRS'
param kp_sshkey ='kp-myapp-iac'

param azVirtualNetwork = 'myapp-vnet-dev'
param azSubnet_web_01 = 'subnet-web-01-dev'
