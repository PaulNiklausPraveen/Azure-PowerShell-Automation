<#
This PS script will create a new network interface

#>

$Location="North Europe"
$ResourceGroupName ="ResourceGroup1"
$VirtualNetworkName="LB-vnet"
$SubnetName="lbvnetsubnet1"
$NetworkInterfaceName="ApplicationServernic2"

# Fetch the details of  virtual network
$VirtualNetwork=Get-AzVirtualNetwork -Name $VirtualNetworkName -ResourceGroupName $ResourceGroupName

#Fetch the details of Subnet
$Subnet = Get-AzVirtualNetworkSubnetConfig -Name $SubnetName -VirtualNetwork $VirtualNetwork

 


$NetworkInterface = New-AzNetworkInterface -Name $NetworkInterfaceName `
-ResourceGroupName $ResourceGroupName -Location $Location `
-Subnet $Subnet

# If you want to display the details of the network interface

$NetworkInterface