
// az deployment group create -g rg-dev -f network.bicep --parameters ./parameters/network.dev.bicepparam -c

@description('Location for all resources.')
param location string

param appName string
param env string

param dateTime string = utcNow('u')

@description('Resource Tags')
var tags = {
  createdBy: 'gk'
  createdOn: dateTime
  environment: env
}

resource azVirtualNetwork  'Microsoft.Network/virtualNetworks@2023-02-01'={
  name: toLower('${appName}-vnet-${env}')
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '192.168.0.0/25'
      ]
    }
  }
  tags: tags
}

resource azSubnet_apgw 'Microsoft.Network/virtualNetworks/subnets@2023-02-01' = {
  name: 'subnet-apgw-${env}'
  parent: azVirtualNetwork
  properties: {
    addressPrefix: '192.168.0.0/27'
  }
}

// attach subnet to network security group
resource azSubnet_web_01 'Microsoft.Network/virtualNetworks/subnets@2023-02-01' = {
  name: 'subnet-web-01-${env}'
  parent: azVirtualNetwork
  properties: {
    addressPrefix: '192.168.0.32/27'
    networkSecurityGroup: {
      id: azSecurityGroup.id
    }
  }
}


resource azSubnet_web_02 'Microsoft.Network/virtualNetworks/subnets@2023-02-01' = {
  name: 'subnet-web-02-${env}'
  parent: azVirtualNetwork
  properties: {
    addressPrefix: '192.168.0.64/27'
  }
}



resource azSecurityGroup 'Microsoft.Network/networkSecurityGroups@2023-02-01' = {
  name: 'nsg-web-${env}'
  location: location
  tags: tags
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
