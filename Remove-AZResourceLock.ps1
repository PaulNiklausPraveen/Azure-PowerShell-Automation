Function Remove-AZLock
{
Param
(
[Parameter(Mandatory)]
[string]$ResourceName,
[Parameter(Mandatory)]
[string]$LockName
)

$Resource=(Get-AzResource -Name $ResourceName)
Remove-AzResourceLock -LockName $LockName -ResourceName $ResourceName -ResourceType $Resource.Type `
-ResourceGroupName $Resource.ResourceGroupName -Force 
}
 
