<#This PowerShell script will resize the VM
 
To get the available VM sizes in a region, run the below command,

"Get-AzVMSize -Location "Central US"

#>


$VMName="Server01"

$DesiredVMSize="Standard_DS1_v2"

$VMData=Get-AzVM -Name $VmName

If($VMData.HardwareProfile.VmSize -NE $DesiredVMSize)
{

    Write-Output "Powering down the $VMName to resize"
    
    Stop-AZVM -Name $VMName -ResourceGroupName $VMData.ResourceGroupName -Force 
    
    $Vm.HardwareProfile.VmSize=$DesiredVMSize
    $Vm | Update-AzVM
    
    Write-Output "The size of the VM has been modified and powering on the VM"
    
    Start-AZVM -Name $VMName -ResourceGroupName $VMData.ResourceGroupName
}
Else 
{
    Write-Outpu "The VM is already in the desired size"
}
