<#
This PowerShell Script will create 2 Virtual Machines with IIS installed.
It will create and configure Azure Traffic Manager and add those 2 VMs as -EndpointStatus
#>

#Connect-AZAccount
$SubscriptionID="90d89134-bb66-4a56-b22d-dd169846d147"
$ResourceGroupName ="TrafficManager-PS-RG"
$Locations="North Europe","West Europe"
$VirtualNetworkName="TF-Network1","TF-Network2"
$VirtualNetworkAddressSpace="10.0.0.0/16","10.1.0.0/16"
$SubnetName="SubnetTF"
$SubnetAddressSpace="10.0.0.0/24","10.1.0.0/24"
$NetworkSecurityGroupName="TF-NSG-1","TF-NSG-2"
$NetworkInterfaceName="TFInterface"
$VmName="AZTFVM"
$VMSize = "Standard_DS2_v2"
$Location ="North Europe"
$UserName="serveradmin"
$Password="MicrosoftAzure@2023"
$PublicIPAddressName="TF-PublicIP"
$TrafficManagerProfileName="Azure-TrafficeManager"
$DNSName="AzureTrafficeManagerservice"
$PasswordSecure=ConvertTo-SecureString -String $Password -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $UserName,$PasswordSecure
$FileUris = @("https://raw.githubusercontent.com/PaulNiklausPraveen/Powershell-Scripts/master/IIS-Install.ps1")
$ProtectedSettings = @{
    "FileUris" = $FileUris
    "commandToExecute" = "powershell -ExecutionPolicy Unrestricted -File IIS-Install.ps1"    
}

$I=1
$VmConfig=@()
$VMs=@()
$PublicIPAddresses=@()
$VirtualNetworks=@()
$NetworkInterfaces=@()
$PublicIPAddresses=@()
$IpConfig=@()

Select-AzSubscription -SubscriptionId $SubscriptionID

Write-Output "Creating Azure ResourceGroup"
New-AzResourceGroup -Name $ResourceGroupName -Location $Location -Force -Verbose

Foreach($Location in $Locations)
{
$Subnet=New-AzVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix $SubnetAddressSpace[$i-1] -WarningAction silentlyContinue

Write-Output "Creating the virtual network : $VirtualNetworkName[$i-1]"
$VirtualNetworks+=New-AzVirtualNetwork -Name $VirtualNetworkName[$i-1] -ResourceGroupName $ResourceGroupName `
-Location $Location -AddressPrefix $VirtualNetworkAddressSpace[$i-1] -Subnet $Subnet

Get-AzVirtualNetwork -ResourceGroupName $ResourceGroupName -Name $VirtualNetworkName[$i-1]

$Subnet = Get-AzVirtualNetworkSubnetConfig -Name $SubnetName -VirtualNetwork $VirtualNetworks[$i-1]

Write-Output "Creating the network interface: $NetworkInterfaceName$i "

$NetworkInterfaces+=New-AzNetworkInterface -Name "$NetworkInterfaceName$i" -ResourceGroupName $ResourceGroupName -Location $Location -Subnet $Subnet    

Write-Output "Creating the public IP Address:  $PublicIPAddressName$i"

$PublicIPAddresses+=New-AzPublicIpAddress -Name "$PublicIPAddressName$i" -ResourceGroupName $ResourceGroupName -Location $Location -Sku "Standard"  -AllocationMethod "Static" -WarningAction silentlyContinue

$IpConfig+=Get-AzNetworkInterfaceIpConfig -NetworkInterface $NetworkInterfaces[$i-1]

$NetworkInterfaces[$i-1] | Set-AzNetworkInterfaceIpConfig -PublicIpAddress $PublicIPAddresses[$i-1] -Name $IpConfig[$i-1].Name

$NetworkInterfaces[$i-1] | Set-AzNetworkInterface

$SecurityRule1=New-AzNetworkSecurityRuleConfig -Name "Allow-RDP" -Description "Allow-RDP" -Access Allow -Protocol Tcp -Direction Inbound -Priority 100 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 3389

$SecurityRule2=New-AzNetworkSecurityRuleConfig -Name "Allow-HTTP" -Description "Allow-HTTP" -Access Allow -Protocol Tcp -Direction Inbound -Priority 200 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 80

Write-Output "Creating the Network Security Group: $NetworkSecurityGroupName[$i-1]"

$NetworkSecurityGroup=New-AzNetworkSecurityGroup -Name $NetworkSecurityGroupName[$i-1]  -ResourceGroupName $ResourceGroupName -Location $Location `
-SecurityRules $SecurityRule1,$SecurityRule2

Set-AzVirtualNetworkSubnetConfig -Name $SubnetName -VirtualNetwork $VirtualNetworks[$i-1] -NetworkSecurityGroup $NetworkSecurityGroup -AddressPrefix $SubnetAddressSpace[$i-1] -WarningAction SilentlyContinue

$VirtualNetworks[$i-1] | Set-AzVirtualNetwork

$NetworkInterfaces[$i-1]= Get-AzNetworkInterface -Name "$NetworkInterfaceName$i" -ResourceGroupName $ResourceGroupName

$VmConfig+=New-AzVMConfig -Name "$VmName$i" -VMSize $VMSize

Set-AzVMOperatingSystem -VM $VmConfig[$i-1] -ComputerName "$VmName$i" -Credential $Credential -Windows

Set-AzVMSourceImage -VM $VmConfig[$i-1] -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2016-Datacenter" -Version "Latest"

$VMs+=Add-AzVMNetworkInterface -VM $VmConfig[$i-1] -Id $NetworkInterfaces[$i-1].Id

Set-AzVMBootDiagnostic -Disable -VM $VMs[$i-1]

Write-Output "Creating the Virtual Machine $VmName$i"
New-AzVM -ResourceGroupName $ResourceGroupName -Location $Location -VM $VMs[$i-1] -WarningAction SilentlyContinue

Set-AzVMExtension -ResourceGroupName $ResourceGroupName -Location $Location -VMName "$VMName$I" -Name "InstallIIS" `
-Publisher "Microsoft.Compute" -ExtensionType "CustomScriptExtension" -TypeHandlerVersion "1.10" -ProtectedSettings $protectedSettings

$i++

}
Write-Output "Script halts for 5 Minutes to complete VM creation"
Start-Sleep 300
Write-Output "Script resumes and now Creating the Azure Traffic Manager"

#Create a Azure Traffic Manager 

$TrafficManagerProfile = New-AzTrafficManagerProfile -Name $TrafficManagerProfileName -ResourceGroupName $ResourceGroupName -TrafficRoutingMethod Priority -Ttl 45 -MonitorProtocol HTTP -MonitorPort 80 -MonitorPath "/" -RelativeDnsName $DNSName 
$PublicIPAddresses=Get-AzPublicIpAddress -ResourceGroupName $ResourceGroupName | Where-Object {$_.Name -Like "TF-PublicIP*"}
$I=1
Foreach($PublicIP in $PublicIPAddresses)
{
Add-AzTrafficManagerEndpointConfig -EndpointName "AzureVMEndpoint$i" -TrafficManagerProfile $TrafficManagerProfile -Type ExternalEndpoints -Target $PublicIP.IpAddress -EndpointStatus Enabled -Priority $i
Set-AzTrafficManagerProfile -TrafficManagerProfile $TrafficManagerProfile
$i++
}

