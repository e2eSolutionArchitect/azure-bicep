
@allowed([
  'nonprod'
  'prod'
])

param environmentType string

var storageAccountSkuName = (environmentType =='prod') ? 'Standard_GRS' : 'Standard_LRS'
var appServicePlanSkuName = (environmentType =='prod') ? 'P2v3' : 'F1'

var appServicePlanName = toLower('appSrvPlan-${uniqueString(resourceGroup().id)}')
var appServiceAppName = toLower('appSrvApp-${uniqueString(resourceGroup().id)}')

@description('Generate unique String for web app name')
param appName string = toLower('app-${uniqueString(resourceGroup().id)}')

@description('Specifies the location for resources.')
param location string = resourceGroup().location

var storageName = toLower('storage-${appName}')

@description('Create a storage account')
resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' ={
  name: storageName
  location: location
  sku: {
    name: storageAccountSkuName
  }
  kind:'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}


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


//---------- Output ------------

output appServicePlan_id string =appServicePlan.id
output appServiceApp_id string =appServiceApp.id
output appServiceAppHostName string =appServiceApp.properties.defaultHostName
