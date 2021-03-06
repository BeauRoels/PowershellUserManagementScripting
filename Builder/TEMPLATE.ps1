$FileServer = "\\ActiveDirectory-SERVER"
$DC = "DC=DOMAIN, DC=be"
$Domain = "DOMAIN"
$MainGroup = "PRIMARYGROUP"
$SubGroup = "subgroup"


Function NetmappingPSDriveUserFolder{
$Username = $env:USERNAME
New-PSDrive -Name "U" -Root "$FileServer\$MainGroup\$Username" -Persist -Scope global -PSProvider "FileSystem"
}
Function NetmappingPSDriveSlaveFolder{
$Username = $env:USERNAME
New-PSDrive -Name "O" -Root "$FileServer\$MainGroup\TEMPLATE_KLAS\$SubGroup" -Persist -Scope global -PSProvider "FileSystem" 
}


Function getUPN{
    $Upn = 'voornaam.achternaam@handelsschoolaalst.be'
    $BeforeAt = $Upn.Split('@')[0]
    $FullName = $BeforeAt.Split('.') -join ' '

    $FirstLetter = $BeforeAt.Split('.')[0][0]
    $LastName = $BeforeAt.Split('.')[1]

    $MappedUpn = "$FistLetter.$LastName@handelsschoolaalst.be"

}
NetmappingPSDriveUserFolder
NetmappingPSDriveSlaveFolder

#Author Beauroels@gmail.com
