// Run below command to deploy
// az deployment group create -g rg-dev -f vm.bicep --parameters ../parameters/vm.dev.bicepparam -c

param location string
param appName string
param env string
param authenticationType string
param securityType string

param adminUsername string
param azVirtualNetwork string
param azSubnet_web_01 string

@secure()
param adminPasswordOrKey string

param vmSize array
param vmCount int 
param vmImagePublisher string
param vmImageOffer string
param vmImageSku string
param vmImageVersion string
param vmDiskType string
param kp_sshkey string



module vm '../modules/vmModule.bicep' = {
  name: 'virtualMachineModule'
  params: {
    location: location
    appName: appName
    env: env
    authenticationType: authenticationType
    securityType: securityType
    adminUsername: adminUsername
    adminPasswordOrKey: adminPasswordOrKey
    azVirtualNetwork: azVirtualNetwork
    azSubnet_web_01: azSubnet_web_01
    vmSize: vmSize
    vmCount: vmCount
    vmImagePublisher: vmImagePublisher
    vmImageOffer: vmImageOffer
    vmImageSku: vmImageSku
    vmImageVersion: vmImageVersion
    vmDiskType: vmDiskType
    kp_sshkey: kp_sshkey
  }
}

