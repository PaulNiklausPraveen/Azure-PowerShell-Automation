<#
Enable system-assigned identity for App Services.
Note: Currently Microsoft does not support User-assigned identity for App Services

#>


Function Enable-AZWebAppIdentity {
[cmdletbinding()]
param(
[Parameter(Mandatory)]
[String]$AZWebappFilePath
)

$AzureWebAppsList=Import-CSV $AZWebappFilePath

Write-Host "Creating a system-assigned identity for App Services" -ForegroundColor Yellow

ForEach($AzureWebApp in $AzureWebAppsList)
{
Set-AzWebApp -AssignIdentity $true -Name $AzureWebApp.ResourceName -ResourceGroupName $AzureWebApp.ResourceGroup
}

}

Enable-AZWebAppIdentity -AZWebappFilePath C:\Temp\EnableIdentity-Webapplist.csv
