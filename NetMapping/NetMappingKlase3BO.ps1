
Function NetmappingPSDriveUserFolder{
$Username = $env:USERNAME
New-PSDrive -Name "U" -Root "\\fs-LLN\Leerlingen\$Username" -Persist -Scope global -PSProvider "FileSystem"
}
Function NetmappingPSDriveSlaveFolder{
$Username = $env:USERNAME
New-PSDrive -Name "O" -Root "\\fs-LLN\Leerlingen\3BO\Opdrachten" -Persist -Scope global -PSProvider "FileSystem" 
}
Function NetmappingPSDriveFileFolder{
$Username = $env:USERNAME
New-PSDrive -Name "W" -Root "\\fs-LLN\www" -Persist -Scope global -PSProvider "FileSystem" 
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
NetmappingPSDriveFileFolder
#Author - https://github.com/BeauRoels
