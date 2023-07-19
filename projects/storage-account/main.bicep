
@description('Generate unique String for web app name')
param appName string = uniqueString(resourceGroup().id)

@description('Specifies the location for resources.')
param location string = resourceGroup().location

var storageName = toLower('storage-${appName}')

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' ={
  name: storageName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind:'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

