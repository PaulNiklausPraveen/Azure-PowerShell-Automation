#Retrieve all resource groups in the current Azure subscription
$ResourceGroups = Get-AzResourceGroup

#Initialize an empty array to store all resources found across resource groups
$Resources = @()

#Loop through each resource group
Foreach ($ResourceGroup in $ResourceGroups) {
    # Get all resources within the current resource group and append them to the $Resources array
  
    $Resources += Get-AzResource -ResourceGroupName $ResourceGroup.ResourceGroupName
}

#Initialize an ArrayList for efficient storage and fast addition of custom resource information
 
$ResourceInformation = [System.Collections.Generic.List[PSObject]]::new()

#Loop through each resource found in the $Resources array
Foreach ($Resource in $Resources) {
    # Create a custom object for each resource containing key information: Name, Resource Group, and Location
    $ResourceInfo = [PSCustomObject]@{
        Name              = $Resource.Name                 
        ResourceGroupName = $Resource.ResourceGroupName    
        Location          = $Resource.Location 
        ResourceType      = $Resource.ResourceType 
        
    }

    # Step 6: Add the custom object to the ArrayList for better performance
    $ResourceInformation.Add($ResourceInfo)
}

#Display the collected resource information in the console

$ResourceInformation 

# Export the resource information to a CSV file for external analysis (uncomment the next line to enable this)

$ResourceInformation | Export-Csv -Path "C:\AzureResources.csv" -Force -NoTypeInformation
