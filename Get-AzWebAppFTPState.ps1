<#
Get FTP states for multiple Azure Webapps from CSV file.CSV file consists of ResourceGroup and ResourceNames(Webappname)
Example : Get-AzWebAppFTPState -CSVPath C:\Temp\Webapplist.csv
#>
Function Get-AzWebAppFTPState {
param(
[String]$CSVPath
)
ForEach($AzureWebApp in $AzureWebApps)
{
(Get-AzWebApp -ResourceGroupName $AzureWebApp.ResourceGroup -Name $AzureWebApp.ResourceName) | Select Name,Location,State,Hostnames,ResourceGroup,@{N='FTPState';E={$_.SiteConfig.FtpsState}}
}
}
