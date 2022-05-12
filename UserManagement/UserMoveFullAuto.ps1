
$FileserverLLN = "\\FS-LLN"
$FileserverPERS = "\\FS-Personeel"
$DC = "DC=Handelsschoolaalst, DC=be"
$Domain = "DeHandelsschool"
$MainGroup = "Leerlingen"
$MainFolder= "leerlingen"
$Moderator= "leerkrachten"


$FileserverLLN = "\\WIN-8KV6AGI5ESN"
$FileserverPERS = "\\WIN-8KV6AGI5ESN"
$DC = "DC=TEST, DC=be"
$Domain = "TEST"
$MainGroup = "Leerlingen"
$MainFolder= "leerlingen"
$Moderator= "leerkracht"
$KlasOU =""

$CSVFolder = "c:\temp\UserMove.csv"

$PreviousGroup=""
$NewGroup=""
$CurrentName=""


Function MoveFromCSV
{
    # Specify target OU. This is where users will be moved.
    $TargetOU =  "OU=$KlasOU,OU=$MainFolder,$DC"
    # Specify CSV path. Import CSV file and assign it to a variable. 
    $Imported_csv = Import-Csv -Path "$CSVFolder" 

    $Imported_csv | ForEach-Object {
        # Retrieve DN of user.
        $UserDN  = (Get-ADUser -Identity $_.Name).distinguishedName
        Write-Host "Editing user: $UserDN ..."
        #Get group
        $UserGroup = Get-ADGroup -Identity $_.currentgroup
        Write-Host "Getting current Group: $UserGroup ..."
        $UsergroupName = (Get-ADGroup -Identity $_.currentgroup | Select-Object Name).Name
        #Get NEW Group
        $UserGroupNew = Get-ADGroup -Identity $_.newgroup 
        $UsergroupNewName = (Get-ADGroup -Identity $_.newgroup | Select-Object Name).Name
        
        Write-Host "Getting new Group $UserGroupNew ..."
        Write-Host "Getting new Group name $UsergroupNewName ..."
         
        # Move user to target OU.
        $KlasOU = "3BO"
        Move-ADObject  -Identity $UserDN  -TargetPath $TargetOU
        Write-Host "Moving $UserDN to new OU $TargetOU ..."

        #Put in correct new security group

        Add-ADGroupMember -Identity "$UsergroupNewName" -Members $UserDN
        Write-Host "Adding $UserDN to new group $UsergroupNewName ..."
        Remove-ADGroupMember -Identity "$UserGroup" -Members $UserDN
        Write-Host "Removing $UserDN from old group $UsergroupNewName ..."
        $Description = -join ('Leerling ', $UsergroupNewName)
        Set-ADUser $UserDN -Description $Description
    }
    
}

Function MoveFolder
{
    #PS C:\> Get-ADGroupMember -Identity "SG_Azure_A" | ForEach-Object {Add-ADGroupMember -Identity "SG_Azure_B" -Members $_.distinguishedName}
    $CurrentName =Read-Host -Prompt 'Input the username of the person you want to switch: '
    $PreviousGroup = Read-Host -Prompt 'Input the group of the person you want to switch: '
    $NewGroup = Read-Host -Prompt 'Input the new group: '
    
    Add-ADGroupMember -Identity "$NewGroup" -Members $CurrentName
    Remove-ADGroupMember -Identity "$PreviousGroup" -Members $CurrentName
    Move-Item -Path "$FileserverLLN\$MainFolder\$PreviousGroup\$CurrentName" -Destination "$FileserverLLN\$MainFolder\$NewGroup\$CurrentName"
}
