//az deployment group create -f main.bicep -g bicep -c
// VM should reside in same Resource Group where the VNET is created

@description('Location for all resources.')
param location string = resourceGroup().location


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


var appName = 'webapp'
param vmCount int = 2

var azVirtualNetwork = 'webapp-vnet'
var azSubnet_web_01 = 'subnet-web-01'


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

resource sshkey 'Microsoft.Compute/sshPublicKeys@2023-03-01' existing = {
  name: 'kp_bicep_network'
}

resource azVirtualMachine 'Microsoft.Compute/virtualMachines@2023-03-01'=[for i in range(0, vmCount):{
  name: toLower('${appName}-vm-${i}-${uniqueString(resourceGroup().id)}')
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B1ls' //'Standard_D2as_v4'
    }
    
    storageProfile: {
      osDisk: {
        name: 'osdisk-${i}'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
        diskSizeGB: 30
      }
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }
    }
    osProfile: {
      computerName: toLower('${appName}-vm-${i}-${uniqueString(resourceGroup().id)}')
      adminUsername: adminUsername
      adminPassword: adminPasswordOrKey
      linuxConfiguration: ((authenticationType == 'password') ? null : linuxConfiguration)
      //customData: base64(concat('#!/bin/bash\n', 'echo "Hello, World!" > index.html\n', 'nohup python -m SimpleHTTPServer 80 &'))
      customData:loadFileAsBase64('userdata.sh')
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



// resource routeTable 'Microsoft.Network/routeTables@2019-11-01' = {
//   name: toLower('${appName}-rt')
//   location: location
//   properties: {
//     routes: [
//       {
//         name: toLower('${appName}-route-01')
//         properties: {
//           addressPrefix: 'destinationCIDR'
//           nextHopType: 'VirtualNetworkGateway'
//           nextHopIpAddress: 'nextHopIp'
//         }
//       }
//     ]
//     disableBgpRoutePropagation: true
//   }
// }


