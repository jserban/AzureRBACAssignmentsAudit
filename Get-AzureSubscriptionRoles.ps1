
#Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
$reportInfo=@()
Import-Module Az
Connect-AzAccount

    $subscriptions=Get-AzSubscription 
    ForEach ($subscription in $subscriptions) 
    {
        Set-AzContext -SubscriptionName $subscription.Name
        $roleAssignments=Get-AzRoleAssignment #| Select-Object DisplayName, RoleDefinitionName, Scope, ObjectType | Format-Table
        #
        foreach ($roleAssignment in $roleAssignments)
        {
            $reportObject=New-Object PSObject
            Add-Member -InputObject $reportObject noteproperty Subscription $subscription.Name
            Add-Member -InputObject $reportObject noteproperty DisplayName $roleAssignment.DisplayName
            Add-Member -InputObject $reportObject noteproperty RoleDefinitionName $roleAssignment.RoleDefinitionName
            Add-Member -InputObject $reportObject noteproperty Scope $roleAssignment.Scope
            Add-Member -InputObject $reportObject noteproperty ObjectType $roleAssignment.ObjectType  
            $reportInfo+=$reportObject
        }
    } 
    $reportInfo | Export-Csv -Path ".\azureSubscriptionRoles.csv" -NoTypeInformation