
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

Function NetmappingPSDriveDeviceFolder{
$Username = $env:USERNAME
New-PSDrive -Name "L" -Root "\\fs-Personeel\leerlingbegeleiding" -Persist -Scope global -PSProvider "FileSystem" 
}

Function getUPN{
    $Upn = 'voornaam.achternaam@handelsschoolaalst.be'
    $BeforeAt = $Upn.Split('@')[0]
    $FullName = $BeforeAt.Split('.') -join ' '

    $FirstLetter = $BeforeAt.Split('.')[0][0]
    $LastName = $BeforeAt.Split('.')[1]

    $MappedUpn = "$FistLetter.$LastName@handelsschoolaalst.be"

}

NetmappingPSDriveDeviceFolder
#Author - https://github.com/BeauRoels
