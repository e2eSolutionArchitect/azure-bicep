# Azure Bicep

- Good to read - https://github.com/azure/bicep
- Bicep playground - https://aka.ms/bicepdemo
- ARM to Bicep - select decompile button in biceps playground to change ARM template to Bicep file

## Build
```
bicep build .\main.bicep
```

``
az deployment group create -f .\main.json -f <resource-group-name> -c
``
