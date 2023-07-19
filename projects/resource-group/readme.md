
[![HELPLINE](https://github.com/e2eSolutionArchitect/academy/assets/8308302/3b85acaf-50f5-4a4f-850d-46216de108af)](Helpline)(https://e2esolutionarchitect.com/helpline/)


## Build .bicep file
```
az bicep build --file main.bicep
```

``
# deploy Bicep by resource group
az deployment group create -f main.bicep -g <resource-group-name> -c

# deploy by subscription
az deployment sub create -l <location> -f main.bicep

``
