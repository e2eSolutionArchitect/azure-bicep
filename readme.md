# Azure Bicep

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
az deployment group create -f .\main.json -f <resource-group-name> -c
``
