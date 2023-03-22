# AzurePowerShell
This Repository contains PowerShell scripts related to Azure Cloud.


Azure PowerShell Getting Started - https://learn.microsoft.com/en-us/powershell/azure/what-is-azure-powershell?view=azps-9.5.0

Install Azure PowerShell - https://learn.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-9.5.0

Install Azure PowerShell on Windows using an MSI- https://learn.microsoft.com/en-us/powershell/azure/install-az-ps-msi?view=azps-9.5.0

Release notes - https://learn.microsoft.com/en-us/powershell/azure/release-notes-azureps?view=azps-9.5.0


To Sign into Azure, run the following command

> Connect-AZAccount

For accounts in a regional cloud, use the Environment parameter to sign in,

> Connect-AzAccount -Environment AzureChinaCloud

Find commands, Azure PowerShell cmdlets follow a standard naming convention for PowerShell, Verb-Noun. To Find all cmds in AZ.Compute,

> Get-Command -Verb Get -Noun AzVM* -Module Az.Compute
