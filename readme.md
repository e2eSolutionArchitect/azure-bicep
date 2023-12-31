# Azure Bicep

Bicep is a Domain Specific Language (DSL) for deploying Azure resources declaratively.

 "Why not focus your energy on Terraform or other third-party IaC offerings?"
' Using Terraform can be a great choice depending on the requirements of the organization, and if you are happy using Terraform there is no reason to switch. At Microsoft, we are actively investing to make sure the Terraform on Azure experience is the best it can be.' - [Please check the reference here](https://github.com/azure/bicep/#faq)


- Good to read - https://github.com/azure/bicep
- Bicep playground - https://aka.ms/bicepdemo
- ARM to Bicep - select decompile button in bicep playground to change ARM template to Bicep file
  ```
  bicep decompile .\main.json
  ```

[![HELPLINE](https://github.com/e2eSolutionArchitect/academy/assets/8308302/3b85acaf-50f5-4a4f-850d-46216de108af)](Helpline)(https://e2esolutionarchitect.com/helpline/)


## Install Bicep
Assuming Azure CLI is already installed

```
az bicep install
az bicep version
```

Install Bicep extension in VSCode [click here](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#visual-studio-code-and-bicep-extension)


## Build .bicep file
```
# It will generate .json file. Which can be deployed as ARM template. 
az bicep build --file main.bicep

```

## Deploy
```
# Deploy ARM template
az deployment group create -f main.json -g <resource-group-name> -c

# Deploy Bicep
az deployment group create -f main.bicep -g <resource-group-name> -c
# Using parameter file
az deployment group create -g rg-dev -f main.bicep --parameters ./parameters/main.dev.bicepparam -c

# Deploy using subscription
az deployment sub create -l eastus -f main.bicep
# Using parameter file
az deployment sub create -l eastus -f rg.bicep --parameters ./parameters/rg.dev.bicepparam -c
```

# IMPORTANT: Avoid unnecessary cost by terminating the resources after experiment
Run below command to remove the resource group. Deleting the resource group will delete all the resources under the resource group. You do not need to terminate resources individually
```
# Azure CLI
az group delete --name ExampleResourceGroup

# PowerShell
Remove-AzResourceGroup -Name ExampleResourceGroup

```

[![e2esa-bootcamp-posters-01](https://github.com/e2eSolutionArchitect/terraform/assets/62712515/485d9a63-da4b-4308-853d-cca3a5334e89)](https://e2esolutionarchitect.eventbrite.ca)
Please visit https://e2esolutionarchitect.com. Feel free to write us for any queries to som@e2eSolutionArchitect.com
