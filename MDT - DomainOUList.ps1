$OrganizatioanlUnits = Get-AdOrganizationalUnit -Filter *
$a = New-Object System.Collections.ArrayList
FOREACH ($OU IN $OrganizatioanlUnits) {
    $Name     = $OU.Name
    $FullPath = $OU.DistinguishedName 
    [void]$DomainOU.Add('<DomainOU value="' + $FullPath + '">' + $Name + '</DomainOU>' + "`n")
    
}


$DomainOUList = @"
<?xml version="1.0" encoding="utf-8"?>
<DomainOUs>
$DomainOU
</DomainOUs>
"@


Out-File -InputObject $DomainOUList -FilePath C:\Users\$env:USERNAME\desktop\domainOUList.xml