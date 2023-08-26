<#
This PowerShell script will create Azure Kubernetes Cluster.
To install AZ Module, run below cmds.
>Install-Module -Name PowerShellGet -Force
>Install-Module -Name Az -Repository PSGallery -Force
#>
#Import Azure Kubernetes Service
Import-Module  "AZ.AKS" -Verbose
#Install AZAKSCLITool 
Install-AzAksCliTool -KubectlInstallVersion "v1.25.0" -KubectlInstallDestination "C:\Temp" -KubeloginInstallVersion "v0.0.20" -KubeloginInstallDestination "C:\Temp\KS"

#Connect to Azure Account. Update the details below
$SubscriptionID="XXXXXX-XXXXX-XXXXX-XXXXX"
$username = "XXXXXXXXX" 
$TenantID = ""
$password = "XXXXXXX" | ConvertTo-SecureString -asPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($username,$password)
Connect-AzAccount -Credential $credential -ServicePrincipal -Tenant $TenantID

#Fetch Azure Subscriptions to know the subscription ID
#Get-AzSubscription

#Select Azure Subscription
Select-AzSubscription -SubscriptionId $SubScriptionID

#Update the values in the variables as per requirement
$ClusterName="AKSPowerShellCluster"
$NodeCount =1
$location='NorthEurope'
$WorkspaceName = "AzurePowerShellWorkspace"
$DisplayName ="AKSSPN"

#Create Service Principal Account
$AZServicePrincipal = New-AzADServicePrincipal -DisplayName $DisplayName
$Secret=$AZServicePrincipal.PasswordCredentials.SecretText
$ClientID=$AZServicePrincipal.AppId

#Assign Contributor Role
New-AzRoleAssignment -ApplicationId $ClientID -RoleDefinitionName  'Contributor'

#Convert the password to secure string
$ClientSecret = $Secret | ConvertTo-SecureString -AsPlainText -Force

#Create a new object to encapsulate the Application ID and secret
$ServicePrincipalIdAndSecret = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ClientId,$ClientSecret 

#Create New Resource group
$ResourceGroupName = "AZ-Powershell-AKS"
$AzureRG = New-AzResourceGroup $resourceGroupName -location $Location

#Create a new Log Analytics Workspace ID
$WORKSPACE_RESOURCE_ID=New-AzOperationalInsightsWorkspace -Location $Location -Name $WorkspaceName -ResourceGroupName $($AzureRG).ResourceGroupName

#Create new cluster
New-AzAksCluster -ResourceGroupName $($AzureRG).ResourceGroupName -Name $ClusterName -NodeCount $NodeCount -GenerateSshKey -WorkspaceResourceId $($WORKSPACE_RESOURCE_ID) -ServicePrincipalIdAndSecret $ServicePrincipalIdAndSecret -Force 
Import-AzAksCredential -ResourceGroupName $($AzureRG).ResourceGroupName -Name $ClusterName -Force

.\kubectl get nodes

.\kubectl apply -f azure-aks.yaml

.\kubectl get service azure-vote-front 



