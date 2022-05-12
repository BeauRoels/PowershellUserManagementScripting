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
    $Group = @('3BO','3BOP','3OL','3OR','3TC','3TO','4HA','4HAB','4HINF','4HIP','4HT','4KA2B','4TO','4VRK','5BI','5HA','5INF','5INFA','5INFB','5INF0C','5INF0P','5KA','5OPR','5ST','5VRK','5VRKA','5VRKB','6BI','6HA','6HAA','6HAB','6INF','6INFA','6INFB','6INFOC','6INFOP','6INFOP2','6OPR','6ST','6VRK','6VRKA','6VRKB','7VEVE','7VHO','7VV')
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
    #HP LaserJet Pro M148f-M149f PCL-6 (V4)
    #\\fs-lln\PrintDrive\HP Laserjet Pro M418fdw
    #hpsw642a_x64.inf
    $Hostserver = '\\fs-LLN\'
    $drivers = @('hpsw642a_x64.inf')
    $group2 = @('PRT2 LKRZaal - 758 - (kant parking)','PRT LLNsec - C558 ZW-W','PRT LLNsec - C558 Kleur','PRT2 LKRZaal - 758 - (kant hoofdgebouw)','PRT203-llnbeg-HP LaserJet Pro - M148fdw')
    $Template = get-content 'InstallDriversTEMPLATE..ps1'

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
    #pnputil.exe -i -a C: \ Distr \ HP-pcl6-x64 \ hpcu118u.inf
    #Add-PrinterDriver -Name "$PRTName" -InfPath "\\fs-lln\PrintDrive\HP Laserjet Pro M418fdw"
     #"\\fs-LLN\Driver\Windows11\konika758\KOAXOJ_.INF"
}
function InstallPrinter
{
    #Get the fileserver
    $Hostserver = '\\fs-LLN\'
    #List of printers you want to install - has to be the name on the fileserver
    $group2 = @('PRT2 LKRZaal - 758 - (kant parking)','PRT LLNsec - C558 ZW-W','PRT LLNsec - C558 Kleur','PRT2 LKRZaal - 758 - (kant hoofdgebouw)','PRT203-llnbeg-HP LaserJet Pro - M148fdw','PRT Copycenter - C958','PRT4-DirSec-MFCL2700DW','PRT005-LLNsec-Brother HL-2250DN','PRT-Economaat-Brother MFC-L2700DW','PRT207-Economaat-Brother MFC-8510N','PRT208-Economaat-Ricoh Sp 4520DN','PRT217-Brother HL-2250DN','PRT224-2019-Brother HL-2250DN','PRT225 Brother HL-2250DN series [001ba9d18288]','PRT226-Dell Printer E310dw [30055c7bad8f]','PRT-ICT Brother 2250DN [001ba9d6dc9c]','PRT-Studiezaal-Ricoh SP 4520DN')
    #Gets the template file
    $Template = get-content 'InstallPrintersTEMPLATE.ps1'
    #HP LaserJet Pro M148f-M149f PCL-6 (V4)
    #\\fs-lln\PrintDrive\HP Laserjet Pro M418fdw
    #hpsw642a_x64.inf
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