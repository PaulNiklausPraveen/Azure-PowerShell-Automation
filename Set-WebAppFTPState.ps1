<#
Set-WebAppFTPState -AZWebappFilePath C:\Temp\DisableFTPLIST.csv -FTPState Disabled
#>


Function Set-WebAppFTPState {
[cmdletbinding()]
param(
[Parameter(Mandatory)]
[String]$AZWebappFilePath,
[Parameter(Mandatory)]
[ValidateSet('AllAllowed','Disabled','FtpsOnly' )]
[string]$FTPState
)

$AzureWebApps=Import-CSV $AZWebappFilePath
ForEach($AzureWebApp in $AzureWebApps){

Set-AzWebApp -Name $AzureWebApp.ResourceName -ResourceGroupName $AzureWebApp.ResourceGroup -FtpsState $FTPState 

}

}

 
