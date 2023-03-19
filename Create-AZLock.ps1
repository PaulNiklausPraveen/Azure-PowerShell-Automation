Function Lock-AZResource{

param([String] $ResourceName)


Function Get-AZResourceGroup
{
    Param([String] $ResourceName)
    $Resource=Get-AzResource -Name $ResourceName
    Return $Resource.ResourceGroupName
}

$ResourceType=(Get-AzResource -Name $ResourceName).Type

New-AzResourceLock -LockLevel ReadOnly -LockName "ReadOnlyLock-$($ResourceName)" -ResourceName $ResourceName -ResourceType $ResourceType `
-ResourceGroupName (Get-AZResourceGroup $ResourceName) -Force 



} 
 
