#Script to fetch Azure Devops users with license

# Set the Azure DevOps organization URL and Personal Access Token (PAT)
$Organization_Url = "https://dev.azure.com/YourOrganizationName"
$PAT = "YourPersonalAccessTokenKey"

# Create the authorization header
$base64AuthHeader = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($Pat)"))
$headers = @{
    Authorization = "Basic $base64AuthHeader"
}

$uri = "$Organization_Url/_apis/userentitlements?api-version=6.0-preview.3"
$response = Invoke-RestMethod -Uri $uri -Headers $headers
$Users = $response.value | Select-Object -ExpandProperty user

Foreach ($User in $Users) {
    $DisplayName = $User.DisplayName
    $License = $User.AccessLevel.LicensingSource
 "" | Select @{N="DisplayName";E={$Displayname}},@{N="License";E={$License}}
}
