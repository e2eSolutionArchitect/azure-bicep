// Run the module using below command
//az deployment group create -g rg-dev -f network.bicep --parameters ../parameters/network.dev.bicepparam -c

param location string
param appName string
param env string
param vnet_cidr array
param azSubnet_apgw_ip_cidr string
param azSubnet_web_01_ip_cidr string
param azSubnet_web_02_ip_cidr string

module network '../modules/networkModule.bicep' = {
  name: 'networkmodule'
  params: {
    location: location
    appName: appName
    vnet_cidr:vnet_cidr
    azSubnet_apgw_ip_cidr:azSubnet_apgw_ip_cidr
    azSubnet_web_01_ip_cidr:azSubnet_web_01_ip_cidr
    azSubnet_web_02_ip_cidr:azSubnet_web_02_ip_cidr
    env: env
  }
}

output network array = [
  network.outputs
]
