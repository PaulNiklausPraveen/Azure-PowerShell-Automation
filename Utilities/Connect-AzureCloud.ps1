<#
.SYNOPSIS
    Connects to an Azure account using the current logged-in user or prompts for login if no session exists.
.DESCRIPTION
    This script checks if an existing Azure session is active. If no active session is found, it prompts the user to log in.
    The script can be included in other PowerShell scripts to ensure the user is connected to Azure.
.NOTES
    - You must have the Azure PowerShell module installed.
    - This script will check if a user is already connected before prompting for login.
.EXAMPLE
    .\Connect-AzureCloud.ps1
    # This will either connect to Azure or prompt for login if not already connected.
#>

# Function to check if the user is already connected to Azure
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
