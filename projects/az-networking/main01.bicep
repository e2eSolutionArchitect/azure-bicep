//az deployment group create -f main.bicep -g bicep -c

@description('Location for all resources.')
param location string = resourceGroup().location


var vnet_name = 'vnet-01'
var subnet_apgw = 'subnet-apgw-name-01'
var subnet_name_01 = 'subnet-web-01'
var subnet_name_02 = 'subnet-web-02'

var nsg_web = 'nsg-web'


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
          networkSecurityGroup: {
            id:azSecurityGroup.id
          }
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

resource azSecurityGroup 'Microsoft.Network/networkSecurityGroups@2023-02-01' = {
  name: nsg_web
  location: location
  tags: {
    project: 'demo'
  }
  properties: {
    flushConnection: false
    securityRules: [
      {
        id: 'ssh'
        name: 'allow-ssh'
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
        type: 'NSG'
      }
      {
        id: 'http'
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
        type: 'NSG'
      }
      {
        id: 'https'
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
        type: 'NSG'
      }
    ]
  }
}
