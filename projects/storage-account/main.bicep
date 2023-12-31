
@allowed([
  'nonprod'
  'prod'
])

param environmentType string

var storageAccountSkuName = (environmentType =='prod') ? 'Standard_GRS' : 'Standard_LRS'

@description('Generate unique String for web app name')
param appName string = toLower('app-${uniqueString(resourceGroup().id)}')

@description('Specifies the location for resources.')
param location string = resourceGroup().location

var storageName = toLower('storage-${appName}')

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

