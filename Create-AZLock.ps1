Function Lock-AZResource{

param(
[Parameter(Mandatory)]
[String] $ResourceName,
[Parameter(Mandatory)]
[ValidateSet("ReadOnly","CanNotDelete")]
[string] $LockLevel
)


Function Get-AZResourceGroup
{
    Param([String] $ResourceName)
    $Resource=Get-AzResource -Name $ResourceName
    Return $Resource.ResourceGroupName
}

$ResourceType=(Get-AzResource -Name $ResourceName).Type

New-AzResourceLock -LockLevel $LockLevel -LockName "ReadOnlyLock-$($ResourceName)" -ResourceName $ResourceName -ResourceType $ResourceType `
-ResourceGroupName (Get-AZResourceGroup $ResourceName) -Force 



} 
 
