
@allowed([
  'nonprod'
  'prod'
])

param environmentType string

var storageAccountSkuName = (environmentType =='prod') ? 'Standard_GRS' : 'Standard_LRS'
var appServicePlanName = toLower('appSrvPlan-${uniqueString(resourceGroup().id)}')

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


module app '../../modules/app-service.bicep' ={
  name: 'app'
  params: {
    appServiceAppName: appServicePlanName
    environmentType: environmentType
    location: location
  }
}


//---------- Output ------------

//output appServicePlan_id string =appServicePlan.id
//output appServiceApp_id string =appServiceApp.id
//output appServiceAppHostName string =appServiceApp.properties.defaultHostName
