#Imports Azure Module
Import-Module AZ -Force -Verbose

#Mention the tenant id
$TenantID = "WWWW-XXXX-YYYY-ZZZZ-1234"

#Set TLS to 1.2 version
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#Parameter for credentials
$UserName = "username@domain.com"
$Password = "P@55W0rd@23"
  
#Create a Pscredential object
$SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential -argumentlist $UserName, $SecurePassword
   
#Connect to Azure  
Connect-AzAccount –Credential $Credential -Tenant $TenantID

#Specify the Image name,Resourcegroup
$ImageName="ApplicationServer01"
$ResourceGroup="AZResourceGroup1"

#creates an image object and stores it in the variable
$ImageConfigurationuration = New-AzImageConfig -Location 'eastus';

#Blob URL where disk resides.
$OSDisk = "https://storage.blob.core.windows.net/harddisk/OS.vhd"
$DataDisk1 = "https://storage.blob.core.windows.net/harddisk/datadisk1.vhd"
$DataDisk2 = "https://storage.blob.core.windows.net/harddisk/datadisk2.vhd"

#Add OS Disk to the Image
Set-AzImageOsDisk -Image $ImageConfiguration -OsType 'Windows' -OsState 'Generalized' -BlobUri $OSDisk

#Add Data Disk to the image
Add-AzImageDataDisk -Image $ImageConfiguration -Lun 1 -BlobUri $DataDisk1
Add-AzImageDataDisk -Image $ImageConfiguration -Lun 2 -BlobUri $DataDisk2

#Creates an image with mentioned name in the resourcegroup.
New-AzImage -Image $ImageConfiguration -ImageName $ImageName -ResourceGroupName $ResourceGroup