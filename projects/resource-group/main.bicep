# Run using
# az deployment sub create -l eastus -f main.bicep

targetScope ='subscription'

@description('Specifies the location for resources.')
param location string = 'eastus' 

var rg_name ='rg01'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01'={
  name: rg_name
  location: location 
}
