
#Use "Connect-AZAccount" Cmdlet to login to Azure

#Imports Azure Module
Import-Module AZ -Force -Verbose
#Removes autosave Feature
Disable-AzContextAutosave

#Replace the data with your custom names.
#Use "Get-AZLocation | FT " to get location name if required

$RGName="AZ-RG-PS"
$LocationName= "North Europe"
$Tags= @{ENV="Stage"}

#Create a new resource group in azure with above mentioned details.
New-AzResourceGroup -Name $RGName -Location $LocationName -Tag $Tags -Verbose

