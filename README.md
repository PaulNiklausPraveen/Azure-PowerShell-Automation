

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


Here's a template for the `README.md` that introduces your plan to write PowerShell scripts for each Azure service:

---

# Azure PowerShell Scripts Repository

## Overview
This repository contains a collection of PowerShell scripts designed to manage various Azure services. Each script is dedicated to automating common tasks and operations for a specific Azure service, such as Virtual Machines, Storage, Networking, and more.

The goal of this repository is to provide users with ready-to-use scripts to simplify Azure management and increase efficiency in day-to-day cloud operations.

## Structure
The repository is organized by Azure services. Each folder corresponds to a specific Azure service and contains scripts that perform key operations related to that service. For example:
- **Virtual Machines**: Scripts for creating, starting, stopping, resizing, and deleting virtual machines.
- **Storage**: Scripts for creating, managing, and deleting storage accounts and containers.
- **Networking**: Scripts for managing virtual networks, network security groups, and related resources.

## Available Services
- **Virtual Machine**: Scripts to automate VM creation, scaling, and management.
- **Storage**: Manage Azure Storage Accounts, Blobs, and other related tasks.
- **Networking**: Create and configure Virtual Networks (VNets), Network Security Groups (NSGs), and more.
- **More Services Coming Soon**: Additional Azure services will be added, including databases, monitoring, and automation.

## How to Use the Scripts
1. **Clone the Repository**: Clone this repository to your local environment to start using the scripts.
   ```bash
   git clone https://github.com/PaulNiklausPraveen/AzurePowerShell.git
   ```
2. **Navigate to a Service Folder**: Each folder contains scripts related to a particular service.
   ```bash
   cd AzurePowerShell/VirtualMachine
   ```

3. **Run a Script**: Execute the PowerShell script to manage the Azure service.
   ```powershell
   .\Create-AzureVM.ps1
   ```

4. **Connect to Azure**: Before running any service-related script, ensure you're connected to your Azure account. Use the included `Connect-AzAccount.ps1` script to handle authentication:
   ```powershell
   .\Utilities\Connect-AzAccount.ps1
   ```

## Prerequisites
- **Azure PowerShell Module**: Install the Azure PowerShell module to run the scripts.
   ```powershell
   Install-Module -Name Az -AllowClobber -Force
   ```
- **Azure Account**: Ensure you have an active Azure subscription and sufficient permissions to execute the scripts.

## Contributing
Contributions are welcome! Feel free to submit pull requests to add new features, improve existing scripts, or fix any issues. If you'd like to request a new service or feature, open an issue to discuss it.

## License
This repository is licensed under the MIT License. You are free to use, modify, and distribute the scripts as needed.

---
 
