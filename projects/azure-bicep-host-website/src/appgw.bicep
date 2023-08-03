
// run this command to deploy the app gateway
// az deployment group create -g rg-dev -f appgw.bicep --parameters ../parameters/appgw.dev.bicepparam -c
param appName string
param env string
param location string
param virtualNetworkName string
param appGWNetworkInterfaceName string
param appGWnsgName string
param appGWPublicIPAddressName string
param appGWSubnet string 
param applicationGateWayName string 
param appTargetSubnet string
param backendAddresses array 

module ApplicationGateway '../modules/appgwModule.bicep' = {
  name: 'ApplicationGateWayModule'
  params: {
    appGWNetworkInterfaceName: appGWNetworkInterfaceName
    appGWnsgName: appGWnsgName
    appGWPublicIPAddressName: appGWPublicIPAddressName
    appGWSubnet: appGWSubnet
    applicationGateWayName: applicationGateWayName
    appName: appName
    appTargetSubnet: appTargetSubnet
    backendAddresses: backendAddresses
    env: env
    location: location
    virtualNetworkName: virtualNetworkName
  }
}
