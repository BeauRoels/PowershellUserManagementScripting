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
    $newDBPrimegroup = Read-Host -Prompt 'Input the main group table from the database (example: students)'
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
        $NewFile += $Line 
        $NewFile += "`r`n"
    }
        Out-File -InputObject $NewFile -FilePath "$($NewScript).ps1" -Encoding ASCII
}

function NetClasstest
{
    $Group = @('5')
    $Template = get-content 'TEMPLATE.ps1'
    #$NewFile = $Template.Replace('TEMPLATE_KLAS',$Item)
    #Out-File $NewFile "$Item.ps1"
    
    Foreach($Item in $Group)
    {
        $NewFile=''
        Foreach($Line in $Template)
        {
            $NewFile += $Line -Replace 'TEMPLATE_KLAS', $Item
            $NewFile += "`r`n"
        }
        Out-File -InputObject $NewFile -FilePath "$($Item).ps1" -Encoding ASCII
    }
}
function InstallPrinterDriver
{
    $Hostserver = '\\SERVER\'
    $drivers = @('DRIVER.inf')
    $group2 = @('printername1','printername2')
    $Template = get-content 'InstallDriversTEMPLATE.ps1'

    Foreach($Item in $group2)
    {
        Foreach($Line in $Template)
        {
            #Makes the connection name
            $conn = -join ($Hostserver, $Item)
            #Replaces the template variables in the file
            $Line = $Line -Replace 'TEMPLATE_PRINTERDRIVER', 'Add-PrinterDriver -Name '
            $Line = $Line -Replace 'TEMPLATE_DRIVERNAME', $conn
            $Line = $Line -Replace 'TEMPLATE_INFPATH', $conn
            $Line = $Line -Replace 'TEMPLATE_PATH', $conn

            $NewFile += $Line
            $NewFile += "`r`n"
        }
    }
    #Install driver to driver store
}
function InstallPrinter
{
    #Get the fileserver
    $Hostserver = '\\fs-LLN\'
    #List of printers you want to install - has to be the name on the fileserver
    $group2 = @('printername1','Printername2')
    #Gets the template file
    $Template = get-content 'InstallPrintersTEMPLATE.ps1'
    Foreach($Item in $group2)
    {
        $NewFile=''
        Foreach($Line in $Template)
        {
            #Makes the connection name
            $conn = -join ($Hostserver, $Item)
            #Replaces the template variables in the file
            $Line = $Line -Replace 'TEMPLATE_PRINTERADD', 'Add-Printer -ConnectionName'
            $Line = $Line -Replace 'TEMPLATE_PRINT', $conn
            $NewFile += $Line
            $NewFile += "`r`n"
        }
        $filename = $Item -replace '\s','' -replace '\[',"" -replace '\]',""
        Out-File -InputObject $NewFile -FilePath "$($filename).ps1" -Encoding ASCII
    }
}
NetClass

#Author - https://github.com/BeauRoels