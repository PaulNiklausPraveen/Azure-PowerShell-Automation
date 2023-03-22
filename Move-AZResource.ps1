<#
This PowerShell Script will Move the Resources to another Resource Group
Requires -Version 7.0 
#>

Connect-AzAccount

$ResourceName="Type Azure Resource Name"
$DestinationResourceGroupName="Type Destination ResourceGroup"

#Define Functions
Function Get-ResourceGroupID {
    param([String] $ResourceGroupName)
    $ResourceGroupID=(Get-AzResourceGroup -Name $ResourceGroupName).ResourceId
    Return $ResourceGroupID
}
Function Get-ResourceGroupName {
    Param ([String] $ResourceName)
    $ResourceGroupName=(Get-AzResource -Name $ResourceName).ResourceGroupName
    Return $ResourceGroupName    
}
Function Get-ResourceId {
    Param ([String] $ResourceName)
    $ResourceID=(Get-AzResource -Name $ResourceName).ResourceId
    Return $ResourceID
}
$ResourceId=(Get-ResourceId $ResourceName)
$SourceResourceGroupName=(Get-ResourceGroupName $ResourceName)
$SourceResourceGroupId=(Get-ResourceGroupID $SourceResourceGroupName)
$DestinationResourceGroupId=(Get-ResourceGroupID $DestinationResourceGroupName)

Try {
#validate if resource can move to other resourcegroup
Invoke-AzResourceAction -Action validateMoveResources -ResourceId $SourceResourceGroupId -Parameters @{resources=@($ResourceId);targetResourceGroup= $DestinationResourceGroupId} -Force -ErrorAction Stop

Move-AzResource -DestinationResourceGroupName $DestinationResourceGroupName -ResourceId $ResourceId -Force

}
Catch {
$_.Exception.Message
}

#Validate if resource has been moved or not
(Get-ResourceGroupName $ResourceName) -Eq $DestinationResourceGroupName  ? "$ResourceName has been moved to $DestinationResourceGroupName" :  `
  "Failed to move the resource $ResourceName to $DestinationResourceGroupName Group"
