#This PowerShell script will copy a snapshot of a disk to storage container 

 Get-AzStorageAccountKey -ResourceGroupName "TypeResourceGroupname" -Name "TypeStorageaccountname"



# 
$resourceGroupName ="ResourceGroupNAme"
$snapshotName = "datadisk-snapshot"
$sasExpiryDuration = "1500"
$storageAccountName = "TypeStorageaccountname"
$storageContainerName = "Containername"
$storageAccountKey = 'b8E1gwwcQledQAIL4fE9WHkL0Nqni7UeNiZBXzrjxVYAaaaaaaaaaaa=='
$destinationVHDFileName = "datadisk-snapshot-copy"
$sas = Grant-AzSnapshotAccess -ResourceGroupName $ResourceGroupName -SnapshotName $SnapshotName  -DurationInSecond $sasExpiryDuration -Access Read
$destinationContext = New-AzStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey
Start-AzStorageBlobCopy -AbsoluteUri $sas.AccessSAS -DestContainer $storageContainerName -DestContext $destinationContext -DestBlob $destinationVHDFileName

#Copy the snapshot to the storage account 
Start-AzStorageBlobCopy -AbsoluteUri $sas.AccessSAS -DestContainer $storageContainerName -DestContext $destinationContext -DestBlob $destinationVHDFileName

