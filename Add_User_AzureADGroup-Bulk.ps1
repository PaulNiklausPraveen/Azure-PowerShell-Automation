CLS

Import-Module AzureAD

Connect-AzureAD

$GroupName = "Physics Department"

$GroupObjectId = (Get-AzureADGroup -SearchString $GroupName).objectid
 
#Import group members from CSV file

#$GroupMembers = Import-CSV "C:\Temp\GroupMembers.csv"

$count =$Groupmembers.Count
Write-Host "`nNumber of users to be added are $count `n `n" -ForegroundColor Yellow

#Iterate members one by one and add to group

Foreach($GroupMember in $GroupMembers)
{
$UserObjectId = $GroupMember."ObjectId"

$UserName=$GroupMember."DisplayName"

Write-Progress -Activity "Adding member" -Status $UserName

Try
{

Add-AzureADGroupMember -ObjectId $GroupObjectID -RefObjectId $UserObjectID 

}

catch
{

Write-Host "Error occurred for $Groupmember.Displayanme" -ForegroundColor Cyan

Write-Host $_ -ForegroundColor Red

}

}

#List the users in the Group 

Write-Host "Members of the Group $GroupName are listed Below, `n" -ForegroundColor Yellow
Get-AzureADGroupMember -ObjectId $GroupObjectID  | Select   Displayname,UserPrincipalName,UserType