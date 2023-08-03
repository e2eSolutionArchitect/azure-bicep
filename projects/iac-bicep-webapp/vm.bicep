// az deployment group create -g rg-dev -f vm.bicep --parameters ./parameters/vm.dev.bicepparam -c


@description('Location for all resources.')
param location string


@description('Type of authentication to use on the Virtual Machine. SSH key is recommended.')
@allowed([
  'sshPublicKey'
  'password'
])
param authenticationType string = 'sshPublicKey'

var securityProfileJson = {
  uefiSettings: {
    secureBootEnabled: true
    vTpmEnabled: true
  }
  securityType: securityType
}


@description('Username for the Virtual Machine.')
param adminUsername string

@description('SSH Key or password for the Virtual Machine. SSH key is recommended.')
@secure()
param adminPasswordOrKey string


@description('Security Type of the Virtual Machine.')
@allowed([
  'Standard'
  'TrustedLaunch'
])
param securityType string = 'TrustedLaunch'

var azVirtualNetwork = toLower('${appName}-vnet-${env}')
var azSubnet_web_01 = toLower('subnet-web-01-${env}')
param vmCount int = 1
param vmSize array 
param vmImagePublisher string
param vmImageOffer string
param vmImageSku string
param vmImageVersion string
param vmDiskType string
param kp_sshkey string

var linuxConfiguration = {
  disablePasswordAuthentication: true
  ssh: {
    publicKeys: [
      {
        path: '/home/${adminUsername}/.ssh/authorized_keys'
        keyData: sshkey.properties.publicKey
      }
    ]
  }
}

param appName string
param env string

resource sshkey 'Microsoft.Compute/sshPublicKeys@2023-03-01' existing = {
  name: kp_sshkey
}

resource azVirtualMachine 'Microsoft.Compute/virtualMachines@2023-03-01'=[for i in range(0, vmCount):{
  name: toLower('${appName}-vm-${i}-${uniqueString(resourceGroup().id)}-${env}')
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize[0]
    }
    
    storageProfile: {
      osDisk: {
        name: 'osdisk-${i}'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: vmDiskType
        }
        diskSizeGB: 30
      }
      imageReference: {
        publisher: vmImagePublisher
        offer: vmImageOffer
        sku: vmImageSku
        version: vmImageVersion
      }
    }
    osProfile: {
      computerName: toLower('${appName}-vm-${i}-${uniqueString(resourceGroup().id)}')
      adminUsername: adminUsername
      adminPassword: adminPasswordOrKey
      linuxConfiguration: ((authenticationType == 'password') ? null : linuxConfiguration)
      customData:loadFileAsBase64('./userdata-docker.sh')
    }
    securityProfile: ((securityType == 'TrustedLaunch') ? securityProfileJson : null)
    networkProfile: {
      networkInterfaces: [
        {
          id: azNetworkInterface[i].id
        }
      ]
    }
  }
  dependsOn: [
    azNetworkInterface
  ]
}]

resource azNetworkInterface 'Microsoft.Network/networkInterfaces@2023-02-01'=[for i in range(0, vmCount):{
  name: toLower('${appName}-nic-${i}-${uniqueString(resourceGroup().id)}')
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig-${i}'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', azVirtualNetwork, azSubnet_web_01)
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: azPublicIPAddress[i].id
          }
        }
      }
    ]
  }
  dependsOn: [
    azPublicIPAddress
  ]
}]

resource azPublicIPAddress 'Microsoft.Network/publicIPAddresses@2023-02-01'=[for i in range(0, vmCount):{
  name: toLower('${appName}-pip-${i}-${uniqueString(resourceGroup().id)}')
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}]

