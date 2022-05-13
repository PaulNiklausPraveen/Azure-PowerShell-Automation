
#Your Custom GroupName

$Group ="Physics Department" 

# The user you want to add

$User="Demouser3"   

#Get Group object ID
          
$Groupobjectid = (Get-AzureADGroup -SearchString $Group).objectid 

#Get User Object ID

$Userobjectid =(Get-AzureADUser -SearchString "$user").objectid

#Add User to the AzureAD Group

Add-AzureADGroupMember -objectid $Groupobjectid -RefObjectId $Userobjectid

#Get the AzureAD members list

Get-AzureADGroupMember -ObjectId $Groupobjectid