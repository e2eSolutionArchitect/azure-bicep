@description('Location for all resources.')
param location string = resourceGroup().location


var vnet_name = 'demo01'
var subnet_agw = 'subnet-apgw_name-01'
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
        name: subnet_agw
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

