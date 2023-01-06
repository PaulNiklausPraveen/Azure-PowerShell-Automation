<#
This script will create a SAS ACCESS URL for a disk to export.
In this state, a disk cannot be attached/edited to a running VM
#>

#Set TLS to 1.2 version
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#Imports Azure Module
Import-Module AZ -Force -Verbose

#Mention the tenant id
$TenantID = "WWWW-XXXX-YYYY-ZZZZ-1234"

#Mention the Resourcegroup and diskname
$ResourceGroup = "AzureResourceGroup-01"
$DiskName="Azure_WindowsVM01_OsDisk_1_a863d1511134bfo99c3z5vfa75ae12e"

#Parameter for credentials
$UserName = "username@domain.com"
$Password = "P@55W0rd@23"
  
#Create a Pscredential object
$SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential -argumentlist $UserName, $SecurePassword
   
#Connect to Azure  
Connect-AzAccount –Credential $Credential -Tenant $TenantID

#Grant 'Read' access to the disk, will get SAS Access URL as output to export the disk.
Grant-AzDiskAccess -ResourceGroupName $ResourceGroup -DiskName $DiskName  -Access 'Read' -DurationInSecond 3600 -Verbose
 