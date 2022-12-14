
#Install-Module Microsoft.Graph
Connect-MgGraph -Scopes 'Group.Read.All','User.Read.All'
$reportInfo=@()

$groups=Get-MgGroup -All
$groups | Select-Object DisplayName, Description, SecurityEnabled, MailEnabled, Id | Export-Csv -Path ".\azureGroups.csv" -NoTypeInformation
#
foreach ($group in $groups)
{
    $members=Get-MgGroupMember -GroupId $group.Id
    foreach ($member in $members) 
    {
        $user=Get-MgUser -UserId $member.Id | Select-Object DisplayName, Mail, UserPrincipalName, GivenName, Surname, UserType, Id
        $reportObject=New-Object PSObject
        Add-Member -InputObject $reportObject noteproperty Group $group.DisplayName
        Add-Member -InputObject $reportObject noteproperty DisplayName $user.DisplayName
        Add-Member -InputObject $reportObject noteproperty Mail $user.Mail
        Add-Member -InputObject $reportObject noteproperty UserPrincipalName $user.UserPrincipalName
        Add-Member -InputObject $reportObject noteproperty Surname $user.Surname  
        Add-Member -InputObject $reportObject noteproperty GivenName $user.GivenName
        Add-Member -InputObject $reportObject noteproperty UserType $user.UserType  
        Add-Member -InputObject $reportObject noteproperty Id $user.Id  
        $reportInfo+=$reportObject
    }
}
$reportInfo | Export-Csv -Path ".\azureGroupMemberships.csv" -NoTypeInformation