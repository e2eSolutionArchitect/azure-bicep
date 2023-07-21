//az deployment group create -f main.bicep -g bicep -c

@description('Location for all resources.')
param location string = resourceGroup().location


var vnet_name = 'vnet-01'
var subnet_apgw = 'subnet-apgw-name-01'
var subnet_name_01 = 'subnet-web-01'
var subnet_name_02 = 'subnet-web-02'

resource virtualNetwork  'Microsoft.Network/virtualNetworks@2023-02-01'={
  name: vnet_name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '192.168.0.0/25'
      ]
    }
    subnets: [
      {
        name: subnet_apgw
        properties: {
          addressPrefix: '192.168.0.0/27'
        }
      }
      {
        name: subnet_name_01
        properties: {
          addressPrefix: '192.168.0.32/27'
        }
      }  
      {
        name: subnet_name_02
        properties: {
          addressPrefix: '192.168.0.64/27'
        }
      }     
    ]
  }
}

