
Function NetmappingPSDriveUserFolder{
$Username = $env:USERNAME
New-PSDrive -Name "U" -Root "\\fs-Personeel\leerkrachten\$Username" -Persist -Scope global -PSProvider "FileSystem"
}
Function NetmappingPSDriveLeerling{
$Username = $env:USERNAME
New-PSDrive -Name "L" -Root "\\fs-LLN\Leerlingen" -Persist -Scope global -PSProvider "FileSystem" 
}
Function NetmappingPSDriveWWW{
$Username = $env:USERNAME
New-PSDrive -Name "W" -Root "\\fs-LLN\WWW" -Persist -Scope global -PSProvider "FileSystem" 
}
Function NetmappingPSDriveBord{
$Username = $env:USERNAME
New-PSDrive -Name "X" -Root "\\fs-Personeel\Bordboeken" -Persist -Scope global -PSProvider "FileSystem" 
}
Function NetmappingPSDrivePass{
$Username = $env:USERNAME
New-PSDrive -Name "R" -Root "\\fs-Personeel\Leerkrachten\Resetpaswoorden" -Persist -Scope global -PSProvider "FileSystem" 
}
Function NetmappingPSDriveVakgroepIT{
$Username = $env:USERNAME
New-PSDrive -Name "R" -Root "\\fs-Personeel\Vakwerkgroep-IT" -Persist -Scope global -PSProvider "FileSystem" 
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
NetmappingPSDriveLeerling
NetmappingPSDriveWWW
NetmappingPSDriveBord
NetmappingPSDrivePass
NetmappingPSDriveVakgroepIT
#Author - https://github.com/BeauRoels