//az deployment group create -f main.bicep -g bicep -c

@description('Location for all resources.')
param location string = resourceGroup().location

param adminUsername string

@secure()
param adminPassword string 

var vnet_name = 'vnet-01'
var vmName = 'vm-01'


resource azVirtualNetwork  'Microsoft.Network/virtualNetworks@2023-02-01'={
  name: vnet_name
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
resource azVirtualMachine 'Microsoft.Compute/virtualMachines@2023-03-01'={
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS1_v2'
    }
    storageProfile: {
      osDisk: {
        name: 'osdisk-01'
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
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
      linuxConfiguration: {
        disablePasswordAuthentication: false
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: azNetworkInterface.id
        }
      ]
    }
  }
}

resource azNetworkInterface 'Microsoft.Network/networkInterfaces@2023-02-01'={
  name: 'nic-01'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig-01'
        properties: {
          subnet: {
            id: azSubnet_web_01.id
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: azPublicIPAddress.id
          }
        }
      }
    ]
  }
}

resource azPublicIPAddress 'Microsoft.Network/publicIPAddresses@2023-02-01'={
  name: 'pip-01'
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}



