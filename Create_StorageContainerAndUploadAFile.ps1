<#
This PowerShell script will create a container in the storage account and upload the file.
prerequisites :
1.Azure Subscription
2.Storage Account

If Azure PowerShell module is not installed,run below command
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force

Azure PowerShell cmdlets Reference

1. Get-AzStorageAccount
https://learn.microsoft.com/en-us/powershell/module/az.storage/get-azstorageaccount?view=azps-9.0.1

2. New-AzStorageContainer
https://learn.microsoft.com/en-us/powershell/module/az.storage/new-azstoragecontainer?view=azps-9.0.1

3. Set-AzStorageBlobContent
https://learn.microsoft.com/en-us/powershell/module/az.storage/set-azstorageblobcontent?view=azps-9.0.1

#>

#Import the module
Import-Module AZ -Force -Verbose

#Credential Parameters
$AdminUserName = "username@domain.com"
$AdminPassword = "TypeThePasswordHere"
  
#Create Variable for PSCredential object
$SecurePassword = ConvertTo-SecureString $AdminPassword -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential -argumentlist $AdminUserName, $SecurePassword
$Tenantid="TypeTenantid"

#Connect to Azure    
$AzureConnect=Connect-AzAccount –Credential $Credential -tenant " -Verbose
 
If($AzureConnect)
{
Write-Host "Connected to Azure Cloud"
}
Else
{
  Write-Error 'Not connected to azure' -ErrorAction Stop
}


#Create the storage container and Permission of the container can be set as Blob/Container/Off.Read Microsoft docs for more details

$StorageAccount=Get-AzStorageAccount -Name $AccountName -ResourceGroupName $ResourceGroupName
New-AzStorageContainer -Name $ContainerName -Context $StorageAccount.Context -Permission Blob

#Mention the file path and containername(objectname)

$BlobObject=@{
    FileLocation="Demofile.txt"
    ObjectName ="FolderName"
}

#Upload the file to Azure storage container
Set-AzStorageBlobContent -Context $StorageAccount.Context -Container `
$ContainerName -File $BlobObject.FileLocation -Blob $BlobObject.ObjectName

 
