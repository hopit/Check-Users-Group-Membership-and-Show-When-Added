#Display What Groups a User is Part of and When They Were Added

Import-Module ActiveDirectory

#Get Username and set Variable
    [string]$username = $( Read-Host "Username you wish to search" )

$userobj = Get-ADUser $username 
write-host "This may take up to 20 seconds to complete. Results will open in a separate window." -Foregroundcolor Yellow
#Active Directory Server To Connect To
$DomainName = (Get-ADDomain).DNSRoot
$ActiveDirectoryServer = Get-ADDomainController -Discover -Domain $DomainName | Select-Object -ExpandProperty Hostname 

Get-ADUser $userobj.DistinguishedName -Properties memberOf | 
Select-Object -ExpandProperty memberOf | 
ForEach-Object { 
Get-ADReplicationAttributeMetadata $_ -Server $ActiveDirectoryServer -ShowAllLinkedValues | 
Where-Object {$_.AttributeName -eq 'member' -and 
$_.AttributeValue -eq $userobj.DistinguishedName} | 
Select-Object FirstOriginatingCreateTime, Object, AttributeValue 
} | Sort-Object FirstOriginatingCreateTime -Descending | Out-GridView -title "IT Service Desk Toolkit - Groups $username is a member of"
write-host "Loading user groups complete. Have a nice day :)" -Foregroundcolor Yellow