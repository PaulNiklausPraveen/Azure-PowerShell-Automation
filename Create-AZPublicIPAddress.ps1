<#
This PowerShell Script will create a Public IP Address and Associate with existing Network Interface 
To Create a new Network Interface please review - https://github.com/PaulNiklausPraveen/AzurePowerShell/blob/main/Create-NetWorkInterface.ps1
#> 

$PublicIPAddressName="Azure-PublicIPAddress"
$ResourceGroupName ="ResourceGroup1"
$Location="North Europe"
$NetworkInterfaceName="Applicationservernic2"
 

$PublicIPAddress = New-AzPublicIpAddress -Name $PublicIPAddressName -ResourceGroupName $ResourceGroupName `
-Location $Location -Sku "Standard" -AllocationMethod "Static"

$NetworkInterface= Get-AzNetworkInterface -Name $NetworkInterfaceName -ResourceGroupName $ResourceGroupName

$IpConfig=Get-AzNetworkInterfaceIpConfig -NetworkInterface $NetworkInterface

$NetworkInterface | Set-AzNetworkInterfaceIpConfig -PublicIpAddress $PublicIPAddress `
-Name $IpConfig.Name
 
$NetworkInterface | Set-AzNetworkInterface







