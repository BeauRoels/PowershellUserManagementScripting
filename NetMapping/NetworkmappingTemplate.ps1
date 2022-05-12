$FileServer = "\\ActiveDirectory-SERVER"
$DC = "DC=DOMAIN, DC=be"
$Domain = "DOMAIN"
$MainGroup = "PRIMARYGROUP"

Function NetmappingUserFolder{
$Username = $env:USERNAME
New-PSDrive -Name "U" -Root "$FileServer\$Maingroup\$Username" -Persist -Scope global -PSProvider "FileSystem"
}
#Directeur en onderdirecteur
Function NetmappingGroupFolder{
New-PSDrive -Name "J" -Root "$FileServer\$Maingroup" -Persist -Scope global -PSProvider "FileSystem" 
}

Function getUPN{
    $Upn = 'voornaam.achternaam@handelsschoolaalst.be'
    $BeforeAt = $Upn.Split('@')[0]
    $FullName = $BeforeAt.Split('.') -join ' '

    $FirstLetter = $BeforeAt.Split('.')[0][0]
    $LastName = $BeforeAt.Split('.')[1]

    $MappedUpn = "$FistLetter.$LastName@handelsschoolaalst.be"

}
NetmappingUserFolder
NetmappingGroupFolder

#Author Beauroels@gmail.com