#Template variables
$ADServer = "\\ActiveDirectory-SERVER"
$FileServer = "\\ActiveDirectory-SERVER"
$DC = "DC=DOMAIN, DC=be"
$Domain = "DOMAIN"
$MainGroup = "PRIMARYGROUP"
$Group = "GROUP"
$Moderator= "MODERATOR"

$year = (Get-Date).year + 1
$DatabaseGroup = "subgroup"
$DatabasePrimaryGroup = "primarygroup"

$MainFolder= "PRIMARYFOLDER"
$CSVFolder = "c:\temp\userexport.csv"
$SharedFolder = "sharedfolder"

#Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass


function NetClass
{
    $Template = get-content 'UserCreateTEMPLATE.ps1'

    $NewScript = "test"
    $newADServer = Read-Host -Prompt 'Input the Active Directory Server'
    $newFileServer = Read-Host -Prompt 'Input the File Server'
    $newDomain = Read-Host -Prompt 'Input the Domain'
    $newDC = Read-Host -Prompt 'Input the full Domain example "DC=DOMAIN, DC=be"'
    $newMainGroup = Read-Host -Prompt 'Input the primarygroup'
    $newModerator= Read-Host -Prompt 'Input the moderator group'
    $newDBgroup = Read-Host -Prompt 'Input the group record from the database (example: class from students)'
    $newDBPrimegroup = Read-Host -Prompt 'Input the main group table from the database (example: lln)'
    $newMainFolder = Read-Host -Prompt 'Input the main group folder name'
    $newSharedFolder = Read-Host -Prompt 'Input the shared folder name'
    $NewFile=''
    Foreach($Line in $Template)
    {
        #Replace the template variables
        $Line = $Line -Replace "TEMPLATE_ADSERVER", $newADServer
        $Line = $Line -Replace "TEMPLATE_FILESERVER", $newFileServer
        $Line = $Line -Replace "DC=DOMAIN, DC=be", $newDC
        $Line = $Line -Replace "TEMPLATE_DOMAIN", $newDomain
        $Line = $Line -Replace "TEMPLATE_MAINGROUP", $newMainGroup
        $Line = $Line -Replace "TEMPLATE_MODERATOR", $newModerator
        $Line = $Line -Replace "TEMPLATE_DBGROUP", $newDBgroup
        $Line = $Line -Replace "TEMPLATE_DBPRIMEGROUP", $newDBPrimegroup
        $Line = $Line -Replace "TEMPLATE_MAINFOLDER", $newMainFolder
        $Line = $Line -Replace "TEMPLATE_SHAREDFOLDER", $newSharedFolder
        $Line = $Line -Replace "TEMPLATE_DATABASE_GROUP", $newDBgroup
        $NewFile += $Line 
        $NewFile += "`r`n"
    }
        Out-File -InputObject $NewFile -FilePath "$($NewScript).ps1" -Encoding ASCII
}
NetClass

#Author - https://github.com/BeauRoels