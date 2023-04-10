<#
Provision a Azure Virtual Machine Scale Set behind the Load Balancer by Powershell

1. Create ResourceGroup
2. Create Virtual Network
3. Create Subnet
4. Create Public IP Adress
4. Create and Configure LoadBalancer
6. Create and Configure VMSS
7. Create Health Probe and update LB
8. Install IIS to VMSS through Custom Script Extention
9. Create Network Security Group and associate to Subnet.
10.Finally test the VMSS Connection

#> 
 
 
$ResourceGroupName ="AZ-VMSS-PowerShell-RG"
$Location="North Europe"
$VirtualNetworkName="VMSS-Network"
$VirtualNetworkAddressSpace="10.0.0.0/16"
$SubnetName="VMSS-Network-SubnetA"
$SubnetAddressSpace="10.0.0.0/24"
$FrontEndIPName="AZ-LBFrontEndIP"
$LBBackendPoolName="AZ-LBBackendPools"
$LoadBalancerName="AZVMSSLB"
$ScaleSetName="AZLB-VMSS"
$VMSize = "Standard_DS2_v2"
$UserName="serveradmin"
$Password="MicrosoftAzure@2023"
$BackEndPoolName="AZ-LBBackendPools"
$VMSSIPConfigurationName="AZVMSSIPConfiguration"
$VMSSComputerName="AZVMSSLB"
$VMSSNetworkConfiguration="NetworkConfig"
$ExtensionName="IISInstallandConfiguration"
$NetworkSecurityGroupName="VMSS-NSG"


New-AzResourceGroup -Name $ResourceGroupName -Location $Location -Force

$Subnet=New-AzVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix $SubnetAddressSpace

$VirtualNetwork = New-AzVirtualNetwork -Name $VirtualNetworkName -ResourceGroupName $ResourceGroupName -Location $Location -AddressPrefix $VirtualNetworkAddressSpace -Subnet $Subnet

# Provision Azure Load Balancer by splat

$PublicIPObject=@{
    Name='AZLB-PublicIP'
    Location=$Location
    Sku='Standard'
    AllocationMethod='Static'
    ResourceGroupName=$ResourceGroupName
}

$PublicIP=New-AzPublicIpAddress @PublicIPObject

$FrontEndIP=New-AzLoadBalancerFrontendIpConfig -Name $FrontEndIPName  -PublicIpAddress $PublicIP

New-AzLoadBalancer -ResourceGroupName $ResourceGroupName -Name $LoadBalancerName -Location $Location -Sku "Standard" -FrontendIpConfiguration $FrontEndIP

$LoadBalancer=Get-AzLoadBalancer -ResourceGroupName $ResourceGroupName -Name $LoadBalancerName

$LoadBalancer | Add-AzLoadBalancerBackendAddressPoolConfig -Name  $LBBackendPoolName

$LoadBalancer | Set-AzLoadBalancer

#Deploy Azure Virtual Machine Scale set

$LoadBalancer=Get-AzLoadBalancer -ResourceGroupName $ResourceGroupName -Name $LoadBalancerName

$BackendAddressPool=Get-AzLoadBalancerBackendAddressPoolConfig  -LoadBalancer $LoadBalancer -Name $BackEndPoolName

$VirtualNetwork=Get-AzVirtualNetwork -Name $VirtualNetworkName -ResourceGroupName $ResourceGroupName

$VMSSIPConfiguration=New-AzVmssIpConfig -Name $VMSSIPConfigurationName -SubnetId $VirtualNetwork.Subnets[0].Id -Primary -LoadBalancerBackendAddressPoolsId $BackendAddressPool.Id

$VMSSConfiguration=New-AzVmssConfig -SkuName $VMSize -Location $Location -UpgradePolicyMode "Automatic" -SkuCapacity 2

Set-AzVmssStorageProfile $VMSSConfiguration -ImageReferenceOffer "WindowsServer" -ImageReferenceSku "2019-Datacenter" -ImageReferencePublisher "MicrosoftWindowsServer" -ImageReferenceVersion "latest" -OsDiskCreateOption "FromImage"

Set-AzVmssOsProfile $VMSSConfiguration -ComputerNamePrefix  $VMSSComputerName -AdminUsername $UserName -AdminPassword $Password

Add-AzVmssNetworkInterfaceConfiguration -Name $VMSSNetworkConfiguration -IpConfiguration $VMSSIPConfiguration -VirtualMachineScaleSet $VMSSConfiguration -Primary $true

New-AzVmss -ResourceGroupName $ResourceGroupName -VirtualMachineScaleSet $VMSSConfiguration -Name $ScaleSetName

$HealthProbe="CheckPort80"

#Configuring Health Probe
$LoadBalancer | Add-AzLoadBalancerProbeConfig -Name $HealthProbe -Protocol "tcp" -Port "80" -IntervalInSeconds "10" -ProbeCount "2"

$LoadBalancer | Set-AzLoadBalancer

#Configure Load Balancer Rule
$LoadBalancer=Get-AzLoadBalancer -ResourceGroupName $ResourceGroupName -Name $LoadBalancerName

$LBProbe=Get-AzLoadBalancerProbeConfig  -LoadBalancer $LoadBalancer  -Name  $HealthProbe

$LoadBalancer | Add-AzLoadBalancerRuleConfig -Name "AllowHTTP" -FrontendIpConfiguration $LoadBalancer.FrontendIpConfigurations[0] `
-Protocol "Tcp" -FrontendPort 80 -BackendPort 80 -BackendAddressPool $BackendAddressPool -Probe $LBProbe

$LoadBalancer | Set-AzLoadBalancer

$ScriptConfiguration = @{
    "fileUris" = (,"https://raw.githubusercontent.com/PaulNiklausPraveen/Files/main/IISInstallandConfig.ps1");
    "commandToExecute" = "powershell -ExecutionPolicy Unrestricted -File IISInstallandConfig.ps1"
}
$VMSSObject=Get-AzVmss -ResourceGroupName $ResourceGroupName  -VMScaleSetName $ScaleSetName

$VMSSObject=Add-AzVmssExtension -VirtualMachineScaleSet $VMSSObject -Name $ExtensionName -Publisher "Microsoft.Compute" -Type "CustomScriptExtension" -TypeHandlerVersion 1.10 -Setting $ScriptConfiguration

Update-AzVmss -ResourceGroupName $ResourceGroupName -Name $ScaleSetName -VirtualMachineScaleSet $VMSSObject  

# Configure Network Security Group
$SecurityRule1=New-AzNetworkSecurityRuleConfig -Name "Allow-HTTP" -Description "Allow-HTTP-Protocol" -Access Allow -Protocol Tcp -Direction Inbound -Priority 200 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 80

$NetworkSecurityGroup=New-AzNetworkSecurityGroup -Name $NetworkSecurityGroupName -ResourceGroupName $ResourceGroupName -Location $Location -SecurityRules $SecurityRule1

$VirtualNetwork=Get-AzVirtualNetwork -Name $VirtualNetworkName -ResourceGroupName $ResourceGroupName

Set-AzVirtualNetworkSubnetConfig -Name $SubnetName -VirtualNetwork $VirtualNetwork -NetworkSecurityGroup $NetworkSecurityGroup `
-AddressPrefix $SubnetAddressSpace

$VirtualNetwork | Set-AzVirtualNetwork


#Test the VMSS 
Invoke-WebRequest -Uri $((Get-AzPublicIpAddress -Name AZLB-PublicIP).IPAddress) | Select-Object -ExpandProperty Content
