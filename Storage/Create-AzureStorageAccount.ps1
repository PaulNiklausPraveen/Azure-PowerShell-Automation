<#
.SYNOPSIS
    Creates a new Azure Storage Account.
.DESCRIPTION
    This script creates an Azure Storage Account within a specified resource group and location.
    It supports various configuration options such as the account type (Standard or Premium).
.NOTES
    - Requires the Azure PowerShell module to be installed.
    - Ensure you are logged in to Azure before running this script.
.EXAMPLE
    .\Create-StorageAccount.ps1
    # This will prompt for the required parameters and create the storage account.
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
$location = Read-Host "Enter the Location (e.g., eastus, westus)"
$storageAccountName = Read-Host "Enter a unique Storage Account name"
 #= Read-Host "" -DefaultValue "Standard_LRS"

if(($sku = Read-Host "Enter the SKU type (Standard_LRS, Standard_GRS, Premium_LRS, etc.) or Press enter to accept default value [Standard_LRS]") -eq '')
{$sku='Standard_LRS'}
else{
  $sku
}


# Check if the Resource Group exists
$ResourceGroup = Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
If (-not $resourceGroup) {
  Write-Host "Resource group $resourceGroupName does not exist. Creating it..." -ForegroundColor Yellow
  New-AzResourceGroup -Name $resourceGroupName -Location $location
  Write-Host "Resource group $resourceGroupName created." -ForegroundColor Green
}

# Create the storage account
Try {
  Write-Host "Creating Storage Account: $storageAccountName in $resourceGroupName..." -ForegroundColor Yellow
  
  $storageAccount = New-AzStorageAccount `
      -ResourceGroupName $resourceGroupName `
      -Name $storageAccountName `
      -Location $location `
      -SkuName $SKU `
      -Kind StorageV2 `
      -AccessTier Hot `
      -PublicNetworkAccess Enabled
  
  Write-Host "Storage Account $storageAccountName created successfully." -ForegroundColor Green
}
catch {
  Write-Host "Error: Failed to create the Storage Account. $($_.Exception.Message)" -ForegroundColor Red
  Throw $_
}

# Output the storage account information
$storageAccount


