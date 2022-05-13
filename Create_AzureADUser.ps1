

$Cred = Get-Credential

#Provide Tenant ID
$TENID = "XXXX-XXXX-XXXX" 

#Method 1 : 

Connect-AzureAD -TenantId $TENID -Credential $Cred

$PasswordProfile= New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile

$PasswordProfile.Password = "Example@Password"

New-AzureADUser -DisplayName "Demouser$i" -PasswordProfile $PasswordProfile -UserPrincipalName "demouser$i@paulpraveen1994outlook.onmicrosoft.com" -AccountEnabled $True -Department "Physics" -MailNickName "demouser1"


#Method 2 :

Connect-MSOlService

New-MsolUser -DisplayName "Demouser" -FirstName Demo -LastName User1 -UserPrincipalName "demouser1@paulpraveen1994outlook.onmicrosoft.com" -Password Hello@12345

