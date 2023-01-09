#This PowerShell Script will fetch all resources in the Azure Tenant.

<#

To Install Azure PowerShell module run below commands,

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force

Reference URL : https://learn.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-9.2.0

#>


#Set TLS to 1.2 version
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#Imports Azure Module
Import-Module AZ -Force -Verbose

#Mention the tenant id
$TenantID = "WWWW-XXXX-YYYY-ZZZZ-1234"

#Parameter for credentials
$UserName = "username@domain.com"
$Password = "P@55W0rd@23"
  
#Create a Pscredential object
$SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential -argumentlist $UserName, $SecurePassword
   
#Connect to Azure  
Connect-AzAccount –Credential $Credential -Tenant $TenantID

#update the subscription id
$SubscriptioID="aaaaaa-bbbbbb-cccccc-dddddd-eeeeeee-ffffff"

Get-AzSubscription -SubscriptionId $SubscriptioID | Select-AzSubscription -Force | Select-object Name,Account,Subscription,Environment,Tenant  

 
$ResourceGroups=Get-AzResourceGroup
 
Foreach($ResourceGroup in $ResourceGroups)
{
    $Resources+=Get-AzResource -ResourceGroupName $ResourceGroup.ResourceGroupName
}

 
$AzureResources=@()

foreach($Resource in $Resources)
{
    $ResourceInfo=[PSCustomObject]@{
    Name=$Resource.Name
    ResourceGroupName=$Resource.ResourceGroupName
    Location=$Resource.Location}
    $AzureResources+=$ResourceInfo
}

$AzureResources
