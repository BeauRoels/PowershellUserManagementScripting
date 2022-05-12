
Function NetmappingPSDriveUserFolder{
$Username = $env:USERNAME
New-PSDrive -Name "U" -Root "\\fs-Personeel\Economaat\$Username" -Persist -Scope global -PSProvider "FileSystem"
}
Function NetmappingPSDriveSlaveFolder{
$Username = $env:USERNAME
New-PSDrive -Name "E" -Root "\\fs-Personeel\Economaat\economaat" -Persist -Scope global -PSProvider "FileSystem" 
}
Function NetmappingPSDriveFileFolder{
$Username = $env:USERNAME
New-PSDrive -Name "K" -Root "\\fs-Personeel\leerlingbegeleiding\afbetalingsplannen" -Persist -Scope global -PSProvider "FileSystem" 
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

#Author Beauroels@gmail.com