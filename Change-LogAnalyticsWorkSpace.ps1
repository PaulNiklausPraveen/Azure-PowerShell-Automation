<# 
This PowerShell script will change the Log analytics workspace, we can use this script to change the vms to new workspace.
#>

Set-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord

Update the Application ID below to connect.
$Application_Id ="XXXXX-XXXXX-XXXXX-XXXXX"
$Tenant_Id= "XXXXX-XXXXX-XXXXX-XXXXX"
$Secret_Id = ConvertTo-SecureString "XXXXX-XXXXX-XXXXX-XXXXX" -AsPlainText -Force
$Credentials = New-Object System.Management.Automation.PSCredential($Application_Id , $Secret_Id)
Connect-AzAccount -Credential $Credentials -TenantId $Tenant_Id -ServicePrincipal 

#Update the subscription id
$SubscriptionID="XXXXX-XXXXX-XXXXX-XXXXX"
Select-AzSubscription -SubscriptionID $SubscriptionID

$VMList =Get-Content C:\temp\vmlist.txt
Foreach($VMName in $VMList)
{
 
$VM = get-azvm -VMName $VMName -WarningAction SilentlyContinue
Write-Host "Removing to old Workspace for $($vmname)" -ForegroundColor Yellow
Remove-AzVMExtension -ResourceGroupName $vm.ResourceGroupName -VMName $vm.Name -Name MicrosoftMonitoringAgent -Force
$workspaceId = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
$workspaceKey = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

$PublicSettings = @{"workspaceId" = $workspaceId;"stopOnMultipleConnections" = $False}
$ProtectedSettings = @{"WorkspaceKey" = $WorkspaceKey}

Write-Host "Adding to new Workspace for $($vm.name)" -ForegroundColor Green
Set-AZVMExtension -ExtensionName "MicrosoftMonitoringAgent" -ResourceGroupName $vm.resourcegroupname -VMName $vm.name `
-Publisher "Microsoft.EnterpriseCloud.Monitoring" `
-ExtensionType "MicrosoftMonitoringAgent" `
-TypeHandlerVersion 1.0 `
-Settings $PublicSettings `
-ProtectedSettings $ProtectedSettings `
-Location $vm.Location
}
