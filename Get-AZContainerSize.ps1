#This PowerShell Script will help to calculate the size the blob container in the Azure Cloud.

<#
To Install Azure PowerShell module run below commands,

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force

Reference URLs : 
              https://learn.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-9.2.0
              https://learn.microsoft.com/en-us/powershell/module/az.storage/get-azstorageaccount?view=azps-9.2.0
              https://learn.microsoft.com/en-us/powershell/module/az.storage/get-azstorageblob?view=azps-9.2.0
              https://learn.microsoft.com/en-us/powershell/module/az.storage/get-azstoragecontainer?view=azps-9.2.0
#>

 
 Function Get-AZContainerSize
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [string]$ResourceGroupName,
        [string]$StorageAccountName,
        [string]$ContainerName
        
         
    )

$StorageAccountData=Get-AzStorageAccount -Name $StorageAccountName -ResourceGroupName $ResourceGroupName

$ContainerData=Get-AzStorageContainer -Name $ContainerName -Context $StorageAccountData.Context

$BlobsData=Get-AzStorageBlob -Name $ContainerName -Context $StorageAccountData.Context

$Init=0

foreach($Blob in $BlobsData)
{
    $Init+=$Blob.Length
}

$Size= ($Init/1024/1024)

"`nTotal Size of files in the Container $ContainerName " + [math]::Round($Size,2) + " MB"
}

 
