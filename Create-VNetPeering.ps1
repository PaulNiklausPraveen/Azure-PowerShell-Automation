$AZNetworkNames ="azvirtualnetwork1","azvirtualnetwork2"

$VirtualNetworks=@{}

foreach($AZNetworkName in $AZNetworkNames)
{
    $VirtualNetworks.Add($AZNetworkName,(Get-AzVirtualNetwork -Name $AZNetworkName))
}

# Add virtual network peering connections both sides

    Add-AzVirtualNetworkPeering -Name "Staging-Test" -VirtualNetwork $VirtualNetworks["azvirtualnetwork1"] ` 
    -RemoteVirtualNetworkId $VirtualNetworks["azvirtualnetwork2"].Id


    Add-AzVirtualNetworkPeering -Name "Test-Staging" -VirtualNetwork $VirtualNetworks["azvirtualnetwork2"] `
    -RemoteVirtualNetworkId $VirtualNetworks["azvirtualnetwork1"].Id
