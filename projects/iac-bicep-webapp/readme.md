

### Create two resource groups 1. rg-networking 2. rg-app in Location Canada Central
```
// Run below command to create the deployment
az deployment sub create -l canadacentral -f rg.bicep --parameters location=canadacentral resourceGroups="['rg-networking','rg-app']" env=dev -c

//If using parameter file rg.dev.bicepparam, then run below command
az deployment sub create -l canadacentral -f rg.bicep --parameters ./parameters/rg.dev.bicepparam -c
```

```
param resourceTag string = '${resourceGroup().name}-${resourceGroup().location}-resource'
```
