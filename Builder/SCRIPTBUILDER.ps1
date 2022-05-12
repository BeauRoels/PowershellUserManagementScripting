#Template variables
$TEMPLATE_ONE = "TEMPLATE_ONE"
$TEMPLATE_TWO = "TEMPLATE_TWO"
$TEMPLATE_THREE = "TEMPLATE_THREE"
$TEMPLATE_FOUR = "TEMPLATE_FOUR"
$TEMPLATE_FIVE = "TEMPLATE_FIVE"
$TEMPLATE_SIX = "TEMPLATE_SIX"
$TEMPLATE_SEVEN = "TEMPLATE_SEVEN"
$TEMPLATE_EIGHT = "TEMPLATE_EIGHT"
$TEMPLATE_NINE = "TEMPLATE_NINE"
$TEMPLATE_TEN = "TEMPLATE_TEN"
#Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass


function NetClass
{
    #Class groups in a list
    $Group = @('group1','group2')
    #Call up the template file
    $Template = get-content 'TEMPLATE.ps1'
    $NewFile = $Template.Replace('TEMPLATE_Item',$Item)
    Out-File $NewFile "$Item.ps1"
    
    Foreach($Item in $Group)
    {
        $NewFile=''
        Foreach($Line in $Template)
        {
            #Replace the template variables
            $NewFile += $Line -Replace 'TEMPLATE_Item', $Item
            $NewFile += "`r`n"
        }
        Out-File -InputObject $NewFile -FilePath "$($Item).ps1" -Encoding ASCII
    }
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
InstallPrinter

#Author - https://github.com/BeauRoels