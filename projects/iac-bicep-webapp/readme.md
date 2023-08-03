

# Step 1:  Create two resource groups 1. rg-networking 2. rg-app in Location Canada Central
```
az deployment sub create -l canadacentral -f rg.bicep --parameters ./parameters/rg.dev.bicepparam -c
```

# Step 2: Provision Network

```
az deployment group create -g rg-networking-dev -f network.bicep --parameters ./parameters/network.dev.bicepparam -c
```

# Step 3: Create a SSH key

manually create a ssh key


# Step 4: Provision VM and Setup website

```
az deployment group create -g rg-networking-dev -f vm.bicep --parameters ./parameters/vm.dev.bicepparam -c
```

# Step 5: Create Application Gateway and link to backend VMs
update the VM public IPs in parameter file appgw.dev.bicepparam
```
az deployment group create -g rg-networking-dev -f appgw.bicep --parameters ./parameters/appgw.dev.bicepparam -c
```

# IMPORTANT: Avoid unnecessary cost by terminating the resources after experiment
Run below command to remove the resource group. Deleting the resource group will delete all the resources under the resource group. You do not need to terminate resources individually

```
az group delete --name rg-networking-dev
```