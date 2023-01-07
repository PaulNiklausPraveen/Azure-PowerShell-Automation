
<#This Script hot remove the data disk attached to a running/stopped vm
Make sure no process is utilizing the disk before running this script.
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

#Parameter for credentials
$UserName = "username@domain.com"
$Password = "P@55W0rd@23"
  
#Create a Pscredential object
$SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential -argumentlist $UserName, $SecurePassword
   
#Connect to Azure  
Connect-AzAccount –Credential $Credential -Tenant $TenantID

#Get the VM data and remove the disk
$VirtualMachineProfile = Get-AzVM -ResourceGroupName $resourceGroup -Name $VMName
Remove-AzVMDataDisk -VM $VirtualMachine -DataDiskNames $DiskName 
Update-AzVM -ResourceGroupName $resourceGroup   -VM $VirtualMachineProfile