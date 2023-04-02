

![image](https://user-images.githubusercontent.com/62203157/226994135-c1516734-c2d9-4b76-9803-e857d174a662.png)


<meta name="google-site-verification" content="scrH_1E6obaqsqXQzq8eI4hdvCGOfuOefV9WA3y37Mg" />


Azure PowerShell is a module for Microsoft PowerShell that enables management of Microsoft Azure cloud resources through PowerShell. It allows administrators and developers to automate the deployment, management, and monitoring of Azure resources using PowerShell scripts.

Azure PowerShell cmdlets provide a consistent and predictable way to manage Azure resources, such as virtual machines, storage accounts, and Azure services, using PowerShell. With Azure PowerShell, users can deploy new resources, manage existing resources, and automate common management tasks.

Some of the key features of Azure PowerShell include:

Consistent interface: Azure PowerShell provides a consistent interface for managing Azure resources, which makes it easier to automate and manage cloud resources.

Automate deployment: With Azure PowerShell, users can automate the deployment of Azure resources, reducing the time and effort required to deploy new resources.

Integration with PowerShell: Azure PowerShell is built on top of PowerShell, providing full access to PowerShell scripting capabilities and the ability to integrate with other PowerShell modules and scripts.

Support for Azure services: Azure PowerShell supports a wide range of Azure services, including Azure Virtual Machines, Azure Storage, Azure App Service, Azure SQL Database, and many others.

Cross-platform support: Azure PowerShell supports Windows, Linux, and macOS, making it easy to manage Azure resources from any platform.

Overall, Azure PowerShell provides a powerful toolset for managing Azure resources through PowerShell, allowing for easy automation and scripting of Azure resource management tasks.



This Repository contains PowerShell scripts related to Azure Cloud.

Reference Links :

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
