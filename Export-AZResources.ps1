#Script to export all Azure Resources

$Resources=@() 
$ResourceGroups=Get-AzResourceGroup
 
foreach($ResourceGroup in $ResourceGroups)
{
    $Resources+=Get-AzResource -ResourceGroupName $ResourceGroup.ResourceGroupName
}

$AZResources=@()

foreach($Resource in $Resources)
{
    $ResourceObject=[PSCustomObject]@{
    Name=$Resource.Name
    ResourceGroupName=$Resource.ResourceGroupName
    Location=$Resource.Location}
    $AZResources+=$ResourceObject
}

$ResourceObject | Export-CSV AzureResources.csv -Notype
