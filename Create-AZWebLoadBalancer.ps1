#Imports Azure Module
Import-Module AZ -Force -Verbose

Connect-AZAccount

#Replace the SubscriptionID and TenantID as per the environment
$SubscriptionID = "WWWW-XXXX-YYYY-ZZZZ-1234"
$TenantID="WWWW-XXXX-YYYY-ZZZZ-1234"

Get-AzSubscription -SubscriptionId $SubscriptionID -TenantId $TenantID | Select-AzSubscription -Force

#Set variables
$WarningPreference='SilentlyContinue'
$ResourceGroupName = "LoadBalancer-RG"
$Location = "eastus"
$PublicIPName="LoadBalancerPublicIP"
$FrontEndIPName ="LB_FrontEndIP"
$BackEndPoolName="LB_BackEndPool"
$HealthProbe="LBHealthProbe"
$LoadbalancerName="WebLoadBalancer"
$LBRuleName="LBHTTPRule"
$NATGatewayName ="LBNATGateway"
$BackEndSubnetName="LBBackEndSubnet"
$BastionName="AzureBastionSubnet"
$BastionIPName="LBBastionIP"
$NSGNAME="LBNSG"
$Username = "serveradmin"
$PlainPassword = "P@55w0rd@1357"

#Create resource group
New-AzResourceGroup -Name $resourceGroupName -Location $location -Verbose

#Create a New PublicIP
New-AzPublicIpAddress -Name $PublicIPName -ResourceGroupName $ResourceGroupName -Location $Location -Sku Standard -AllocationMethod Static -Zone 1,2,3  

#Place public IP created in previous steps into variable.
$publicIp = Get-AzPublicIpAddress -ResourceGroupName $ResourceGroupName -Name $PublicIPName

#Create load balancer frontend configuration and place in variable.
$FrontEndIP_Configuration = New-AzLoadBalancerFrontendIpConfig -Name $FrontEndIPName -PublicIpAddress $PublicIp

#Create backend address pool configuration and place in variable. ##
$BackEndPool = New-AzLoadBalancerBackendAddressPoolConfig -Name $BackEndPoolName

#Create the health probe and place in variable.
$Healthprobe = New-AzLoadBalancerProbeConfig -Name $HealthProbe -Protocol Tcp -Port 80 -IntervalInSeconds 360 -ProbeCount 5
 
#Create the load balancer rule and place in variable. 
$LBRule = New-AzLoadBalancerRuleConfig -Name $LBRuleName -Protocol Tcp -FrontendPort 80 -BackendPort 80 -IdleTimeoutInMinutes 15 -FrontendIpConfiguration  $FrontEndIP_Configuration `
 -BackendAddressPool $BackEndPool -EnableTcpReset -DisableOutboundSNAT 

#Create the load balancer resource.
New-AzLoadBalancer -Name $loadbalancerName -ResourceGroupName $ResourceGroupName -Location $Location -Sku Standard -FrontendIpConfiguration $FrontEndIP_Configuration -BackendAddressPool $BackEndPool `
  -LoadBalancingRule $LBRule -Probe $HealthProbe

#Create public IP address for NAT gateway
$NATPublicIP = New-AzPublicIpAddress -Name $NATGatewayName -ResourceGroupName $ResourceGroupName -Location $Location `
  -Sku Standard -AllocationMethod Static  

# Create NAT gateway resource  
$NATGateway = New-AzNatGateway -Name $NatGatewayName -ResourceGroupName $ResourceGroupName -Location $Location -IdleTimeoutInMinutes 10 -PublicIpAddress $NATPublicIP -Sku Standard

#Create backend subnet config  
$SubnetConfig = New-AzVirtualNetworkSubnetConfig -Name $BackEndSubnetName -AddressPrefix  '10.1.0.0/24' -NatGateway $NATGateway

#Create Azure Bastion subnet.  
$BastionSubnetConfig = New-AzVirtualNetworkSubnetConfig -Name  $BastionName -AddressPrefix '10.1.1.0/24' 

#Create a virtual network 
$VirtualNetwork = New-AzVirtualNetwork -Name $VirtualNetworkName -ResourceGroupName $ResourceGroupName -Location $Location `
     -AddressPrefix  '10.1.0.0/16' -Subnet $SubnetConfig,$BastionSubnetConfig

#Create public IP address for bastion host
$BastionPublicIP = New-AzPublicIpAddress -Name $BastionIPName -Location $Location -ResourceGroupName $ResourceGroupName -Sku Standard  -AllocationMethod Static

#Create a bastion host  
New-AzBastion -Name "LBBastionHost" -ResourceGroupName $ResourceGroupName -PublicIpAddress $BastionPublicIP -VirtualNetwork $VirtualNetwork  -AsJob

# Create rule for Network Security Group
$NSGRule = @{
    Name = 'NSGRuleHTTP'
    Description = 'Allow HTTP'
    Protocol = '*'
    SourcePortRange = '*'
    DestinationPortRange = '80'
    SourceAddressPrefix = 'Internet'
    DestinationAddressPrefix = '*'
    Access = 'Allow'
    Priority = '400'
    Direction = 'Inbound'
}
$NSGRule1 = New-AzNetworkSecurityRuleConfig @NSGRule

#Create network security group 
New-AzNetworkSecurityGroup  -Name $NSGNAME -ResourceGroupName $ResourceGroupName -Location $Location -SecurityRules $NSGRule1

#Virtual Machine Creation

# Set the administrator and password for the VMs. ##
$Credentials = New-Object System.Management.Automation.PSCredential ($username, (ConvertTo-SecureString $PlainPassword -AsPlainText -Force))

## Place the virtual network into a variable. ##
 
$VirtualNetworkProfile = Get-AzVirtualNetwork -Name  $VirtualNetworkName -ResourceGroupName $ResourceGroupName

## Place the load balancer into a variable. ##

$LoadBalancerpool = Get-AzLoadBalancer -Name $LoadbalancerName -ResourceGroupName $ResourceGroupName  | Get-AzLoadBalancerBackendAddressPoolConfig

#Place the network security group into a variable.
$NetworkSecurityGroup = Get-AzNetworkSecurityGroup -Name $NSGNAME -ResourceGroupName $ResourceGroupName

#For loop with variable to create virtual machines for load balancer backend pool.  
for ($i=1; $i -le 2; $i++)
{
    $VM="WEB-SERVER"
    #Create Network interface for VMs 
    $VMNic = New-AzNetworkInterface -Name "$VM$i" -Location $Location -ResourceGroupName $ResourceGroupName -Subnet $VirtualNetworkProfile.Subnets[0] `
     -NetworkSecurityGroup $NetworkSecurityGroup -LoadBalancerBackendAddressPool $LoadBalancerpool 
    # Create a virtual machine configuration for VMs 
 
    $VMConfig = New-AzVMConfig -VMSize 'Standard_DS1_v2' -VMName $VM$i `
        | Set-AzVMOperatingSystem -Credential $Credentials -Windows -ComputerName $VM$i  `
        | Set-AzVMSourceImage -PublisherName 'MicrosoftWindowsServer' -Skus '2019-Datacenter' -Offer 'WindowsServer' -Version  'latest' `
        | Add-AzVMNetworkInterface -Id $VMNic.Id 

    #Create the virtual machine for VMs 
    $VirtualMachine = @{
        ResourceGroupName = $ResourceGroupName
        Location = $Location
        VM = $vmConfig
        Zone = "$i"
    }
    New-AzVM @VirtualMachine -AsJob
}

Start-Sleep 300
Sleep 100
#  For loop with variable to install custom script extension on virtual machines.  
for ($i=1; $i -le 2; $i++)
{
$VirtualMachineExtension = @{
    Publisher = 'Microsoft.Compute'
    ExtensionType = 'CustomScriptExtension'
    ExtensionName = 'IIS'
    ResourceGroupName =  $ResourceGroupName
    VMName = "$VM$i"
    Location =  $Location
    TypeHandlerVersion = '1.8'
    SettingString = '{"commandToExecute":"powershell Add-WindowsFeature Web-Server; powershell Add-Content -Path \"C:\\inetpub\\wwwroot\\Default.htm\" -Value $($env:computername)"}'
}
Set-AzVMExtension  @VirtualMachineExtension -AsJob
}

#Check if All jobs are got completed
Get-Job | Receive-Job -Keep

$Get_AllPublicIPs=Get-AzPublicIPAddress  -ResourceGroupName $ResourceGroupName | Select-Object Name, IpAddress , PublicIpAddressVersion, PublicIpAllocationMethod
$LBIP= (Get-AzPublicIPAddress  -ResourceGroupName $ResourceGroupName | Where-Object {$_.Name -EQ "LoadBalancerPublicIP"}).IPAddress
$Get_AllPublicIPs 
 
Write-Host "`nBrowse http://$LBIP to load the webpage`n" -ForegroundColor Green  

#Replace the browser as per your environment.
$Browser="Chrome.exe"
Start-Process $Browser $LBIP -WindowStyle Maximized 

