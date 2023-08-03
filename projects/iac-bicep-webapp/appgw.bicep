// az deployment group create -g rg-dev -f appgw.bicep --parameters ./parameters/appgw.dev.bicepparam -c

@description('Location for all resources.')
param location string

param applicationGateWayName string

param virtualNetworkName string
param appGWSubnet string
param appTargetSubnet string
param appGWNetworkInterfaceName string
param appGWPublicIPAddressName string
param appGWnsgName string
param env string
param appName string

param dateTime string = utcNow('u')

@description('Resource Tags')
var tags = {
  createdBy: 'gk'
  createdOn: dateTime
  environment: env
}

param backendAddresses array 

resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2023-02-01' = [for i in range(0, 2): {
  name: '${appGWPublicIPAddressName}${i}'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
  }
}]

resource applicationGateWay 'Microsoft.Network/applicationGateways@2023-02-01' = {
  name: '${appName}-${applicationGateWayName}-${env}'
  location: location
  properties: {
    sku: {
      name: 'Standard_v2'
      tier: 'Standard_v2'
    }
    gatewayIPConfigurations: [
      {
        name: 'appGatewayIpConfig'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, appGWSubnet)
          }
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: 'appGwPublicFrontendIp'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: resourceId('Microsoft.Network/publicIPAddresses', '${appGWPublicIPAddressName}0')
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'port_80'
        properties: {
          port: 80
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'myBackendPool'
        properties: { 
          backendAddresses: backendAddresses
        }
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 'myHTTPSetting'
        properties: {
          port: 80
          protocol: 'Http'
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: false
          requestTimeout: 20
        }
      }
    ]
    httpListeners: [
      {
        name: 'myListener'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', '${appName}-${applicationGateWayName}-${env}', 'appGwPublicFrontendIp')
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', '${appName}-${applicationGateWayName}-${env}', 'port_80')
          }
          protocol: 'Http'
          requireServerNameIndication: false
        }
      }
    ]
    requestRoutingRules: [
      {
        name: 'myRoutingRule'
        properties: {
          priority: 1
          ruleType: 'Basic'
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', '${appName}-${applicationGateWayName}-${env}', 'myListener')
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', '${appName}-${applicationGateWayName}-${env}', 'myBackendPool')
          }
          backendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', '${appName}-${applicationGateWayName}-${env}', 'myHTTPSetting')
          }
        }
      }
    ]
    enableHttp2: false
    autoscaleConfiguration: {
      minCapacity: 0
      maxCapacity: 10
    }
  }
  dependsOn: [
    publicIPAddress
  ]
  tags: tags
}


resource networkInterface 'Microsoft.Network/networkInterfaces@2023-02-01' = {
  name: appGWNetworkInterfaceName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: '${appGWNetworkInterfaceName}-config'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: resourceId('Microsoft.Network/publicIPAddresses', '${appGWPublicIPAddressName}1')
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, appTargetSubnet)
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
          applicationGatewayBackendAddressPools: [
            {
              id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', '${appName}-${applicationGateWayName}-${env}', 'myBackendPool')
            }
          ]
        }
      }
    ]
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    networkSecurityGroup: {
      id: resourceId('Microsoft.Network/networkSecurityGroups', '${appGWnsgName}')
    }
  }
  dependsOn: [
    publicIPAddress
    applicationGateWay
  ]
}
