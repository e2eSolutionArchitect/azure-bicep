// Run below command to create the deployment
// az deployment sub create -l canadacentral -f rg.bicep --parameters location=canadacentral resourceGroups="['rg-networking','rg-app']" env=dev -c

targetScope ='subscription'

param dateTime string = utcNow('u')

@description('Specifies the location for resources.')
param location string

@description('Environment')
param env string

@description('Resource Tags')
var tags = {
  createdBy: 'gk'
  createdOn: dateTime
  environment: env
}

@description('Resource Group name')
param resourceGroups array
//param resourceGroups array = ['rg-networking','rg-app']

resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01'=[for rg in resourceGroups:{
  name: '${rg}-${env}'
  location: location
  tags: tags
}]
