
[![HELPLINE](https://github.com/e2eSolutionArchitect/academy/assets/8308302/3b85acaf-50f5-4a4f-850d-46216de108af)](Helpline)(https://e2esolutionarchitect.com/helpline/)

# Deploy your custom website in Azure using httpd container, Loadbalancer, Highly Available and Secure way.
## Use Azure BICEP as Infrastructure-as-Code to create end to end infrastructure and networking

## Build .bicep file
```
az bicep build --file main.bicep
```

## Create Rource Group
``
az group create --name bicep --location eastus

# To list the resource groups in your subscription, 
az group list

# To get one resource group
az group show --name exampleGroup
``

## Deploy Bicep by resource group

``
az deployment group create -f main.bicep -g <resource-group-name> -c

``


# About this Bicep project
- Create vnet
- Create 3 subnets
- Create a NSG which allows SSH, HTTP, HTTPS
- Assign the NSG with a web subnet
- Provision 2 VMs using for loop
- Install docker in VMs during initialization
- Create Application Gateway [MS referance](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/applicationgateways?pivots=deployment-language-bicep)
- Associate 2 target VMs to the 'web' pool of Application Gateway
- Create AppGW listeners for HTTP and HTTPS

## Delete the resource stack to avoid any cost
Delete the resource-group to delete the resource stack created by the bicep template
```
# Azure CLI
az group delete --name exampleGroup

# PowerShell
Remove-AzResourceGroup -Name exampleGroup

```
