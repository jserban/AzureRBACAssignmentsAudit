
#Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
$reportInfo=@()
Import-Module Az
Connect-AzAccount

    $managementGroups=Get-AzManagementGroup 
    ForEach ($managementGroup in $managementGroups) 
    {
        $roleAssignments=Get-AzRoleAssignment -Scope $managementGroup.Id
        #
        foreach ($roleAssignment in $roleAssignments)
        {
            $reportObject=New-Object PSObject
            Add-Member -InputObject $reportObject noteproperty Subscription $managementGroup.Name
            Add-Member -InputObject $reportObject noteproperty DisplayName $roleAssignment.DisplayName
            Add-Member -InputObject $reportObject noteproperty RoleDefinitionName $roleAssignment.RoleDefinitionName
            Add-Member -InputObject $reportObject noteproperty Scope $roleAssignment.Scope
            Add-Member -InputObject $reportObject noteproperty ObjectType $roleAssignment.ObjectType  
            $reportInfo+=$reportObject
        }
    } 
    $reportInfo | Export-Csv -Path ".\azureManagementGroupRoles.csv" -NoTypeInformation