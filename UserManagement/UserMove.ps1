$ADServer = "\\ActiveDirectory-SERVER"
$FileServer = "\\ActiveDirectory-SERVER"
$DC = "DC=DOMAIN, DC=be"
$Domain = "DOMAIN"
$MainGroup = "PRIMARYGROUP"
$Group = "GROUP"
$MainFolder= "PRIMARYFOLDER"
$Moderator= "MODERATOR"
$ScriptFolder = "c:\Windows\SYSVOL\domain\scripts"
$GroupOU =""

$CSVFolder = "c:\temp\UserMove.csv"

$PreviousGroup=""
$NewGroup=""
$CurrentName=""

Function MoveWithManualInput
{

    #Correction if user puts in invalid user

    $ValidUsername = $False
    $ValidCurrentGroup = $False
    $ValidNewGroup = $False

    while (-not $ValidUsername)
    {
        $CurrentName =Read-Host -Prompt 'Input the username of the person you want to switch ' 
        try
        {
            $UserDNTest = Get-ADUser -Identity $CurrentName
            
            $ValidUsername = $True
        }
        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
        {
           Write-Host "$CurrentName is an invalid user!"

        }
    }
    while (-not $ValidCurrentGroup)
    {
        $PreviousGroup = Read-Host -Prompt 'Input the group of the person you want to switch '
        try
        {
            $GroupTest = Get-ADGroup -Identity $PreviousGroup
            
             $ValidCurrentGroup = $True
        }
        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
        {
           Write-Host "$PreviousGroup is an invalid group!"

        }
    }
    while (-not $ValidNewGroup)
    {
       $NewGroup = Read-Host -Prompt 'Input the new group '
        try
        {
           $GroupNewTest = Get-ADGroup -Identity $NewGroup
            
            $ValidNewGroup = $True
        }
        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
        {
           Write-Host "$PreviousGroup is an invalid group!"

        }
    }
     

    
    $GroupOU = $NewGroup
    #setting the Target OU, in this case 'leerlingen'
    $TargetOU =  "OU=$GroupOU,OU=$MainFolder,$DC"
    #updating the new desscription to be in line with the new group
    $Description = "Leerling $NewGroup"
    #getting the Distinguished name of the user from Active directory
    $UserDN = (Get-ADUser -Identity "$CurrentName").distinguishedName

    $Source = Get-AdObject -Identity $UserDN
    $Target = Get-AdObject -Identity $TargetOU
    #Setting the correct batfile, will be outdated when switching to GPO's
    $batFile = -join ($NewGroup, '.bat')
    $HomeDirectory= "$ADServer\$MainFolder\$NewGroup\$CurrentName"

    #Second error check if ad object isn't found
    If ($Null -eq $Source)
    {
    Write-Host "------ MOVE-ADOBJECT SOURCE DOESNT EXIST"
    }
    If ($Null -eq $Target )
    {
    Write-Host "------ MOVE-ADOBJECT TARGET DOESNT EXIST"
    }   

    Write-Host "Changing user $CurrentName from $PreviousGroup to group $NewGroup and OU $GroupOU"
    #Adding the user to their new group and deleting them from their old group
    Add-ADGroupMember -Identity "$NewGroup" -Members $UserDN
    Remove-ADGroupMember -Identity "$PreviousGroup" -Members $CurrentName
    #Updating the users description and scriptpath for the bat file
    Set-ADUser $CurrentName -Description $Description -scriptPath "$ScriptFolder\$batFile" -Title $NewGroup

    #Moving the folders and their subfolders to the new group folder
    Move-ADObject  -Identity $UserDN  -TargetPath $TargetOU
    Move-Item -Force -Path "$ADServer\$MainFolder\$PreviousGroup\$CurrentName" -Destination "$ADServer\$MainFolder\$NewGroup\$CurrentName"
    Set-ADUser $CurrentName -HomeDirectory "$HomeDirectory"

}

MoveWithManualInput