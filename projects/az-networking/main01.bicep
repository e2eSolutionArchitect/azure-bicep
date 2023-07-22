//az deployment group create -f main.bicep -g bicep -c

@description('Location for all resources.')
param location string = resourceGroup().location

param adminUsername string

@description('Password for the Virtual Machine.')
@minLength(4)
@secure()
param adminPassword string 

var appName = 'webapp'
param vmCount int = 2


resource azVirtualNetwork  'Microsoft.Network/virtualNetworks@2023-02-01'={
  name: toLower('${appName}-vnet-${uniqueString(resourceGroup().id)}')
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '192.168.0.0/25'
      ]
    }
  }

}

resource azSubnet_apgw 'Microsoft.Network/virtualNetworks/subnets@2023-02-01' = {
  name: 'subnet-apgw-name-01'
  parent: azVirtualNetwork
  properties: {
    addressPrefix: '192.168.0.0/27'
  }
}

resource azSubnet_web_01 'Microsoft.Network/virtualNetworks/subnets@2023-02-01' = {
  name: 'subnet-web-01'
  parent: azVirtualNetwork
  properties: {
    addressPrefix: '192.168.0.32/27'
  }
}


resource azSubnet_web_02 'Microsoft.Network/virtualNetworks/subnets@2023-02-01' = {
  name: 'subnet-web-02'
  parent: azVirtualNetwork
  properties: {
    addressPrefix: '192.168.0.64/27'
  }
}

resource azSecurityGroup 'Microsoft.Network/networkSecurityGroups@2023-02-01' = {
  name: 'nsg-web'
  location: location
  tags: {
    project: 'webapp'
  }
  properties: {
    flushConnection: false
  }
}


resource azNsgRule_ssh 'Microsoft.Network/networkSecurityGroups/securityRules@2023-02-01'={
  parent: azSecurityGroup
  name: 'ssh'
  properties: {
    access: 'Allow'
    description: 'allow ssh'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    sourcePortRange: '*'
    destinationPortRange: '22'
    direction: 'Inbound'
    priority: 101
    protocol: 'TCP'
  }
}

resource azNsgRule_http 'Microsoft.Network/networkSecurityGroups/securityRules@2023-02-01'={
  parent: azSecurityGroup
  name: 'allow-http'
  properties: {
    access: 'Allow'
    description: 'allow http'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    sourcePortRange: '*'
    destinationPortRange: '80'
    direction: 'Inbound'
    priority: 102
    protocol: 'TCP'
  }
}
resource azNsgrule_https 'Microsoft.Network/networkSecurityGroups/securityRules@2023-02-01'={
  parent: azSecurityGroup
  name: 'allow-https'
  properties: {
    access: 'Allow'
    description: 'allow https'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    sourcePortRange: '*'
    destinationPortRange: '443'
    direction: 'Inbound'
    priority: 103
    protocol: 'TCP'
  }
}
resource azVirtualMachine 'Microsoft.Compute/virtualMachines@2023-03-01'=[for i in range(0, vmCount):{
  name: toLower('${appName}-vm-${i}-${uniqueString(resourceGroup().id)}')
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS1_v2'
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
        offer: 'UbuntuServer'
        sku: '18.04-LTS'
        version: 'latest'
      }
    }
    osProfile: {
      computerName: toLower('${appName}-vm-${i}-${uniqueString(resourceGroup().id)}')
      adminUsername: adminUsername
      adminPassword: adminPassword
      linuxConfiguration: {
        disablePasswordAuthentication: false
      }
    }
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
            id: azSubnet_web_01.id
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
    azVirtualNetwork
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


output hostname0 string = azPublicIPAddress[0].properties.dnsSettings.fqdn
output hostname1 string = azPublicIPAddress[1].properties.dnsSettings.fqdn
