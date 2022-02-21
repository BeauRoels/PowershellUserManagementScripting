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

$PreviousGroup=""
$NewGroup=""
$CurrentName=""

Function RequestInput
{

$CurrentName =Read-Host -Prompt 'Input the username of the person you want to switch: '
$PreviousGroup = Read-Host -Prompt 'Input the group of the person you want to switch: '
$NewGroup = Read-Host -Prompt 'Input the new group: '

}

Function MoveFolder
{
    Param($PreviousGroup, $NewGroup)
    Move-Item -Path "$FileserverLLN\$MainFolder\$PreviousGroup\$CurrentName" -Destination "$FileserverLLN\$MainFolder\$NewGroup\$CurrentName"
}
Function AutomaticMoving{
    $users = import-csv -Path C:\users.csv

    #get username from CSV export
        foreach ($user in $users) 
        {
            Remove-ADGroupMember -Identity "$PreviousGroup" -Members $user -whatif

            Add-ADGroupMember -Identity "$NewGroup" -Members $user -whatif

        }

}