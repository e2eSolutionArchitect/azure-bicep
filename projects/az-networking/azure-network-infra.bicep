//az deployment group create -f main.bicep -g bicep -c

@description('Location for all resources.')
param location string = resourceGroup().location
var appName = 'webapp'


resource azVirtualNetwork  'Microsoft.Network/virtualNetworks@2023-02-01'={
  name: toLower('${appName}-vnet')
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
  name: 'subnet-apgw'
  parent: azVirtualNetwork
  properties: {
    addressPrefix: '192.168.0.0/27'
  }
}

// attach subnet to network security group
resource azSubnet_web_01 'Microsoft.Network/virtualNetworks/subnets@2023-02-01' = {
  name: 'subnet-web-01'
  parent: azVirtualNetwork
  properties: {
    addressPrefix: '192.168.0.32/27'
    networkSecurityGroup: {
      id: azSecurityGroup.id
    }
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
