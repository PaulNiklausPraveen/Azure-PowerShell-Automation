<#
This will revoke the SAS URL and may cancel any in-progress transfers if the disk is currently being downloaded to another location.
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

#Revoke access to the disk
Revoke-AzDiskAccess -ResourceGroupName $ResourceGroup -DiskName $DiskName -Verbose
 