New-AzResourceLock -LockLevel CanNotDelete `
    -LockName "CannotDelete" -ResourceName "storage-account-Name" `
    -ResourceType Microsoft.Storage/storageAccounts `
    -ResourceGroupName "Resource-Group-Name"
