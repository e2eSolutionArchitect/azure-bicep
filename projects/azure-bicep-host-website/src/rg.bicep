// Run below command to create the deployment
// az deployment sub create -l canadacentral -f rg.bicep --parameters location=canadacentral rg_name=rg env=dev -c

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
param rg_name string

resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01'={
  name: '${rg_name}-${env}'
  location: location
  tags: tags
}
