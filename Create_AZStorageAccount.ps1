#This script will create a storage account in Azure Cloud using PowerShell AZ module

Import-Module AZ -Force -Verbose

#Credential Parameters
$AdminUserName = "username@domain.com"
$AdminPassword = "TypeThePasswordHere"
  
#Create Variable for Pscredential object
$SecurePassword = ConvertTo-SecureString $AdminPassword -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential -argumentlist $AdminUserName, $SecurePassword
$Tenantid="TypeTenantid"
   
$AzureConnect=Connect-AzAccount –Credential $Credential -tenant " -Verbose
 
If($AzureConnect)
{
Write-Host "Connected to Azure Cloud"
}
Else
{
  Write-Error 'Not connected to azure' -ErrorAction Stop
}


#Details required for Storage Account
$AccountName = "psstaccount2022"
$AccountKind="StorageV2"
$AccountSKU="Standard_LRS"
$ResourceGroupName="PowerShell-ResourceGroup"
$Location = "eastus"

$StorageAccount = New-AzStorageAccount -ResourceGroupName $ResourceGroupName -Name $AccountName `
-Location $Location -Kind $AccountKind -SkuName $AccountSKU

$StorageAccount
