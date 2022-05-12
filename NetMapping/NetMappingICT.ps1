
Function NetmappingPSDriveUserFolder{
$Username = $env:USERNAME
New-PSDrive -Name "U" -Root "\\fs-Personeel\leerkrachten\$Username" -Persist -Scope global -PSProvider "FileSystem"
}
#Directeur en onderdirecteur
Function NetmappingPSDriveSlaveFolder{
$Username = $env:USERNAME
New-PSDrive -Name "W" -Root "\\fs-LLN\leerlingen" -Persist -Scope global -PSProvider "FileSystem" 
}
Function NetmappingPSDriveFileFolder{
$Username = $env:USERNAME
New-PSDrive -Name "V" -Root "\\fs-LLN\data\v811s01" -Persist -Scope global -PSProvider "FileSystem" 
}
Function NetmappingPSDriveDeviceFolder{
$Username = $env:USERNAME
New-PSDrive -Name "L" -Root "\\fs-Personeel\Leerkrachten" -Persist -Scope global -PSProvider "FileSystem" 
}
Function NetmappingPSDriveManagementFolder{
$Username = $env:USERNAME
New-PSDrive -Name "I" -Root "\\fs-Personeel\Vakwerkgroep-IT" -Persist -Scope global -PSProvider "FileSystem" 
}
Function NetmappingPSDrivePasswordFolder{
$Username = $env:USERNAME
New-PSDrive -Name "I" -Root "\\fs-Personeel\leerkrachten\ResetPaswoorden" -Persist -Scope global -PSProvider "FileSystem" 
}
Function NetmappingPSDriveICTFolder{
$Username = $env:USERNAME
New-PSDrive -Name "I" -Root "\\fs-LLN\data\ICT" -Persist -Scope global -PSProvider "FileSystem" 
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
NetmappingPSDrivePasswordFolder
NetmappingPSDriveICTFolder
#Author - https://github.com/BeauRoels