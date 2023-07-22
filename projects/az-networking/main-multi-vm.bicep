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

var azVirtualNetwork = 'webapp-vnet-5fm4fawuzqb6w'
var azSubnet_web_01 = 'subnet-web-02'

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
