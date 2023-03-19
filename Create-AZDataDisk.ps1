$VMName ="server1"
$ResourceGroupName ="ResourceGroup1"
$DiskName="datadisk2"

 
$VirtualMachine=Get-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName
 
$VirtualMachine | Add-AzVMDataDisk -Name $DiskName -DiskSizeInGB 50-CreateOption Empty -Lun 0

$VirtualMachine | Update-AzVM
