
// Value will be passed from main bicep file
param location string 
param appServiceAppName string


@allowed([
  'nonprod'
  'prod'
])

param environmentType string

var appServicePlanSkuName = (environmentType =='prod') ? 'P2v3' : 'F1'

var appServicePlanName = toLower('appSrvPlan-${uniqueString(resourceGroup().id)}')

@description('Create App Service Plan')
resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01'={
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSkuName
  }
}

@description('Create App Service App')
resource appServiceApp 'Microsoft.Web/sites@2022-09-01'={
  name: appServiceAppName
  location: location
  properties: {
    serverFarmId:appServicePlan.id
    httpsOnly: true
  }
}


