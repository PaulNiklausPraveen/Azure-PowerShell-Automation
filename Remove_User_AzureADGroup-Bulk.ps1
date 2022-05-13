
Import-Module AzureAD

Connect-AzureAD

$GroupName = "Physics Department"

$GroupObjectId = (Get-AzureADGroup -SearchString $GroupName).objectid

#Remove One User from the Group

Remove-AzureADGroupMember -ObjectId $GroupObjectId -MemberId  $_.objectid



#Remove all users in the Group
Get-AzureADGroupMember -ObjectId $Groupobjectid | Foreach{ Remove-AzureADGroupMember -ObjectId $GroupObjectId -MemberId  $_.objectid}


