<#
This PowerShell script will create a new network security group, with 2 security rules to allow HTTPS and RDP.
Then Associate the NSG with existing Subnet
#>


$NetworkSecurityGroupName="AZ-SecurityGroup1"
$ResourceGroupName ="ResourceGroup1"
$Location="North Europe"


$SecurityRule1=New-AzNetworkSecurityRuleConfig -Name "Allow-RDP" -Description "Allow RDP Traffice Flow" `
-Access Allow -Protocol Tcp -Direction Inbound -Priority 100 -SourceAddressPrefix * -SourcePortRange * `
-DestinationAddressPrefix * -DestinationPortRange 3389

$SecurityRule2=New-AzNetworkSecurityRuleConfig -Name "Allow-HTTPS" -Description "Allow HTTPS Traffic Flow" `
-Access Allow -Protocol Tcp -Direction Inbound -Priority 101 -SourceAddressPrefix * -SourcePortRange * `
-DestinationAddressPrefix * -DestinationPortRange 443

$NetworkSecurityGroup=New-AzNetworkSecurityGroup -Name $NetworkSecurityGroupName `
-ResourceGroupName $ResourceGroupName -Location $Location `
-SecurityRules $SecurityRule1,$SecurityRule2

 
$VirtualNetworkName="lb1-vnet"
$SubnetName="subnet1"
$SubnetAddressSpace="10.0.0.0/24"

$VirtualNetwork=Get-AzVirtualNetwork -Name $VirtualNetworkName -ResourceGroupName $ResourceGroupName

Set-AzVirtualNetworkSubnetConfig -Name $SubnetName -VirtualNetwork $VirtualNetwork -NetworkSecurityGroup $NetworkSecurityGroup `
-AddressPrefix $SubnetAddressSpace

$VirtualNetwork | Set-AzVirtualNetwork
