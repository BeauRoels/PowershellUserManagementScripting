
Function NetmappingPSDriveUserFolder{
$Username = $env:USERNAME
New-PSDrive -Name "U" -Root "\\fs-Personeel\adm\$Username" -Persist -Scope global -PSProvider "FileSystem"
}
#Directeur en onderdirecteur
Function NetmappingPSDriveSlaveFolder{
$Username = $env:USERNAME
New-PSDrive -Name "J" -Root "\\fs-Personeel\adm\Secretariaat" -Persist -Scope global -PSProvider "FileSystem" 
}
Function NetmappingPSDriveFileFolder{
$Username = $env:USERNAME
New-PSDrive -Name "S" -Root "\\fs-Personeel\adm\Directie" -Persist -Scope global -PSProvider "FileSystem" 
}
Function NetmappingPSDriveDeviceFolder{
$Username = $env:USERNAME
New-PSDrive -Name "L" -Root "\\fs-Personeel\Leerlingbegeleiding" -Persist -Scope global -PSProvider "FileSystem" 
}
Function NetmappingPSDriveManagementFolder{
$Username = $env:USERNAME
New-PSDrive -Name "F" -Root "\\fs-Personeel\Economaat\economaat\FACTURATIE" -Persist -Scope global -PSProvider "FileSystem" 
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
NetmappingPSDriveDeviceFolder
NetmappingPSDriveManagementFolder
#Author Beauroels@gmail.com