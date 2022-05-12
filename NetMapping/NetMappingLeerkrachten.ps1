
Function NetmappingPSDriveUserFolder{
$Username = $env:USERNAME
New-PSDrive -Name "U" -Root "\\fs-Personeel\leerkrachten\$Username" -Persist -Scope global -PSProvider "FileSystem"
}
Function NetmappingPSDriveSlaveFolder{
$Username = $env:USERNAME
New-PSDrive -Name "L" -Root "\\fs-LLN\Leerlingen" -Persist -Scope global -PSProvider "FileSystem" 
}
Function NetmappingPSDriveFileFolder{
$Username = $env:USERNAME
New-PSDrive -Name "W" -Root "\\fs-LLN\WWW" -Persist -Scope global -PSProvider "FileSystem" 
}
Function NetmappingPSDriveDeviceFolder{
$Username = $env:USERNAME
New-PSDrive -Name "X" -Root "\\fs-Personeel\Bordboeken" -Persist -Scope global -PSProvider "FileSystem" 
}
Function NetmappingPSDriveManagementFolder{
$Username = $env:USERNAME
New-PSDrive -Name "R" -Root "\\fs-Personeel\Leerkrachten\Resetpaswoorden" -Persist -Scope global -PSProvider "FileSystem" 
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
#Author - https://github.com/BeauRoels