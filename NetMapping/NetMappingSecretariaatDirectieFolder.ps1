
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

Function NetmappingPSDriveFileFolder{
$Username = $env:USERNAME
New-PSDrive -Name "S" -Root "\\fs-Personeel\adm\Directie" -Persist -Scope global -PSProvider "FileSystem" 
}


Function getUPN{
    $Upn = 'voornaam.achternaam@handelsschoolaalst.be'
    $BeforeAt = $Upn.Split('@')[0]
    $FullName = $BeforeAt.Split('.') -join ' '

    $FirstLetter = $BeforeAt.Split('.')[0][0]
    $LastName = $BeforeAt.Split('.')[1]

    $MappedUpn = "$FistLetter.$LastName@handelsschoolaalst.be"

}

NetmappingPSDriveFileFolder
#Author - https://github.com/BeauRoels
