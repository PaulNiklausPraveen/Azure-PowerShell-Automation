<#
This Script will disables encryption for all volumes
Disable encryption is not currently supported for Linux OS.
If Name parameter is not specified, an extension with the default name "AzureDiskEncryption for Windows VMs" is created.
This Cmdlet will reboot the Windows VM
#>

#Set TLS to 1.2 version
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#Imports Azure Module
Import-Module AZ -Force -Verbose

#Mention the tenant id
$TenantID = "WWWW-XXXX-YYYY-ZZZZ-1234"

#Mention the Resourcegroup
$ResourceGroup = "AzureResourceGroup-01"
$VMName ="Azure_WindowsVM01"

#valid values of Volume Types are: All,OS,Data. If no value for this parameter is specified, the default value is All.
$VolumeType = "ALL"

#Parameter for credentials
$UserName = "username@domain.com"
$Password = "P@55W0rd@23"
  
#Create a Pscredential object
$SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential -argumentlist $UserName, $SecurePassword
   
#Connect to Azure  
Connect-AzAccount –Credential $Credential -Tenant $TenantID


#Disables encryption for volumes
Disable-AzVMDiskEncryption -ResourceGroupName $ResourceGroup -VMName $VMName -VolumeType All -Force -Verbose