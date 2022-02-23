#To Create and manage unmanage disk in Azure.

#Set Location as East United States
$Location = "East US"
$ResourceGroupName = "AZ-NEWRG"

#Create a new Resourcegroup
New-AzResourceGroup -Name $ResourceGroupName -Location $Location

#Get properties of the newly created resource group
Get-AzResourceGroup -Name $ResourceGroupName

#Set Disk properties
$DiskConfig = New-AzDiskConfig -Location $location -CreateOption Empty -DiskSizeGB 32 -Sku Premium_LRS  
$DiskName = "AZ-NewRG-disk1"


#Create a new managed Disk
New-AzDisk  -ResourceGroupName $ResourceGroupName -DiskName $diskName -Disk $DiskConfig

#To get the properties of created Disk,
Get-AzDisk -ResourceGroupName $ResourceGroupName -Name $DiskName | Select Name,ResourceGroupName,Location,DiskSizeGB,Tier


#Increase the size of the Azure managed disk from 32GB to 64GB 
New-AzDiskUpdateConfig -DiskSizeGB 64 | Update-AzDisk -ResourceGroupName $ResourceGroupName -DiskName $DiskName

#To check the disk size
Get-AzDisk -ResourceGroupName $ResourceGroupName -Name $DiskName


#Delete the disk AZ-NewRG-disk1
Get-AzDisk -ResourceGroupName $ResourceGroupName -Name $DiskName | Remove-AzDisk -Force


#Delete the ResourceGroup
Remove-AzResourceGroup -Name AZ-NEWRG -Force