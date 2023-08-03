using '../src/appgw.bicep'
param location = 'canadacentral'
param appName = 'myapp'
param env = 'dev'

param applicationGateWayName = 'appgw01'
param virtualNetworkName = 'myapp-vnet-dev'
param appGWSubnet = 'subnet-apgw-dev'
param appTargetSubnet = 'subnet-web-01-dev'
param appGWNetworkInterfaceName = 'apgw-nic'
param appGWPublicIPAddressName = 'apgw-pub-ip'
param appGWnsgName = 'nsg-web-dev'
param backendAddresses = [ { ipAddress: '40.85.228.213' }
                           { ipAddress: '40.85.228.196' } ]
