<#
.SYNOPSIS
    Creates a new container in an Azure Storage Account.
.DESCRIPTION
    This script creates a new container in a specified Azure Storage Account. It allows you to define the access level (Private, Blob, or Container).
.NOTES
    - Requires the Azure PowerShell module to be installed.
    - Ensure you are logged in to Azure before running this script.
.EXAMPLE
    .\Create-AzureStorageContainer.ps1
    # This will prompt for the required parameters and create the storage container.
#>

# Function to ensure user is connected to Azure
Function Connect-AzureCloud {
  try {
      # Check if there's already an existing Azure session
      $context = Get-AzContext
      
      if ($context -eq $null -or $context.Account -eq $null) {
          Write-Host "No active Azure session found. Initiating login..." -ForegroundColor Yellow
          
          # If no session is found, prompt for login
          Connect-AzAccount
          Write-Host "Successfully logged in to Azure." -ForegroundColor Green
      }
      else {
          Write-Host "Already logged in to Azure as $($context.Account.Id)" -ForegroundColor Green
      }
  }
  catch {
      # If there's an error during login or connection, catch the error and display a message
      Write-Host "Error connecting to Azure: $($_.Exception.Message)" -ForegroundColor Red
      throw $_
  }
}

# Call the function to connect
Connect-AzureCloud

# Prompt for input parameters
$resourceGroupName = Read-Host "Enter the Resource Group name"
$storageAccountName = Read-Host "Enter the Storage Account name"
$containerName = Read-Host "Enter the Storage Container name"
 
If(($permission = Read-Host "Enter the access level Blob/Container/Off or Press enter to accept default value Blob ") -eq '')
{$permission='Blob'}
else{
  $permission | out-null
}

# Get the storage account key to authenticate
try {
  $storageAccount = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName
  $storageAccountKey = (Get-AzStorageAccountKey -ResourceGroupName $resourceGroupName -Name $storageAccountName)[0].Value
  $context = New-AzStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey
}
catch {
  Write-Host "Error: Failed to retrieve storage account keys. $($_.Exception.Message)" -ForegroundColor Red
  throw $_
}

 

# Create the storage container
try {
  Write-Host "Creating Storage Container: $containerName in Storage Account: $storageAccountName..." -ForegroundColor Yellow
  New-AzStorageContainer -Name $containerName -Context $context -Permission $permission
  Write-Host "Storage Container $containerName created successfully." -ForegroundColor Green
}

 
catch {
  Write-Host "Error: Failed to create the Storage Container. $($_.Exception.Message) "  -ForegroundColor Red
  Throw $_
}
