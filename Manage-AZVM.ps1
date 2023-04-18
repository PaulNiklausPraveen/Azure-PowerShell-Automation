#This Script will use REST API to manage the VM in azure

#Type SubscriptionID
$Subscription ="abcdef-ghijklm-nopqr-12345"
#Type ResourceGroup
$ResourceGroupName="Scope1" 
#Type VMName
$VMName="scope1vm"
$AZContext = Get-AzContext
$AZProfile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile
$RMProfileClient = New-Object -TypeName Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient -ArgumentList ($AZProfile)
$AZToken = $RMProfileClient.AcquireAccessToken($AZContext.Subscription.TenantId)
$AuthorizationHeader = @{
   'Content-Type'='application/json'
   'Authorization'='Bearer ' + $AZToken.AccessToken
}

#Start VM using REST API
$RestUri_StartVM ="//subscriptions/$Subscription/resourceGroups/$ResourceGroupName/providers/Microsoft.Compute/virtualMachines/$VMName/start?api-version=2022-11-01"
Invoke-AZRestMethod -Path $RestUri_StartVM -Method POST

#Get VM Status
$RestUri_GetVMStatus="https://management.azure.com/subscriptions/$Subscription/resourceGroups/$ResourceGroupName/providers/Microsoft.Compute/virtualMachines/$VMName/InstanceView?api-version=2021-03-01"
$HTTPResponse = Invoke-RestMethod -Uri $RestUri_GetVMStatus -Method Get -Headers $AuthorizationHeader
$HTTPResponse.statuses

#Stop VM using REST API
$RestUri_StartVM ="//subscriptions/$Subscription/resourceGroups/$resourceGroupName/providers/Microsoft.Compute/virtualMachines/$VMName/poweroff?api-version=2022-11-01"
Invoke-AZRestMethod -Path $RestUri_StartVM -Method POST


#Restart VM using REST API
$RestUri_StartVM ="//subscriptions/$Subscription/resourceGroups/$resourceGroupName/providers/Microsoft.Compute/virtualMachines/$VMName/restart?api-version=2022-11-01"
Invoke-AZRestMethod -Path $RestUri_StartVM -Method POST

