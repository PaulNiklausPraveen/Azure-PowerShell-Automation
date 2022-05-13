 




New-AzureADGroup -DisplayName "Physics Department" -SecurityEnabled $true -Description "Department of Physics" -MailEnabled $false -MailNickName "NotSet"

#confirm Group is created
Get-AzureADGroup -SearchString "Physics"