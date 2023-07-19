# Azure Bicep

Bicep is a Domain Specific Language (DSL) for deploying Azure resources declaratively.

 "Why not focus your energy on Terraform or other third-party IaC offerings?"
' Using Terraform can be a great choice depending on the requirements of the organization, and if you are happy using Terraform there is no reason to switch. At Microsoft, we are actively investing to make sure the Terraform on Azure experience is the best it can be.' - [Please check the referance here](https://github.com/azure/bicep/#faq)


- Good to read - https://github.com/azure/bicep
- Bicep playground - https://aka.ms/bicepdemo
- ARM to Bicep - select decompile button in bicep playground to change ARM template to Bicep file
  ```
  bicep decompile .\main.json
  ```

[![HELPLINE](https://github.com/e2eSolutionArchitect/academy/assets/8308302/3b85acaf-50f5-4a4f-850d-46216de108af)](Helpline)(https://e2esolutionarchitect.com/helpline/)

## Build
```
bicep build .\main.bicep
```

``
# deploy ARM template
az deployment group create -f ./main.json -g <resource-group-name> -c

# deploy Bicep
az deployment group create -f ./main.bicep -g <resource-group-name> -c
``
