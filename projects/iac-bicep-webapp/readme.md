

### Create two resource groups 1. rg-networking 2. rg-app in Location Canada Central
```
az deployment sub create -l canadacentral -f rg.bicep --parameters location=canadacentral resourceGroups="['rg-networking','rg-app']" env=dev -c
```

```
param resourceTag string = '${resourceGroup().name}-${resourceGroup().location}-resource'
```
