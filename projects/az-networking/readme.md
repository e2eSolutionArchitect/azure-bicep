
[![HELPLINE](https://github.com/e2eSolutionArchitect/academy/assets/8308302/3b85acaf-50f5-4a4f-850d-46216de108af)](Helpline)(https://e2esolutionarchitect.com/helpline/)


## Build .bicep file
```
az bicep build --file main.bicep
```

``
# deploy Bicep by resource group
az deployment group create -f main.bicep -g <resource-group-name> -c

``

# About this Bicep project
- Create vnet
- Create 3 subnets
- Create a NSG which allows SSH, HTTP, HTTPS
- Assign the NSG with a web subnet

## Todo 
- Provision 2 VMs using for loop
- Install docker in VMs during initialization
- Create Application Gateway
- Associate 2 target VMs to the 'web' pool of Application Gateway
- Create AppGW listeners for HTTP and HTTPS