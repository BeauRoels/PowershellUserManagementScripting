
Function AddNetworkPrinter{
    $PRTHost = "\\fs-LLN\"
    # $PRTName = "KONICA MINOLTA 958SeriesPCL"
    $PRTDomainName = "PRT2 LKRZaal - 758 - (kant parking)"
    # $PRTColl = @("PRT226-Dell Printer E310dw [30055c7bad8f]","PRT225 Brother HL-2250DN","PRT224-2019-Brother HL-2250DN","PRT217-Brother HL-2250DN","PRT2 LKRZaal - 758 - (kant parking)","PRT2 LKRZaal - 758 - (kant hoofdgebouw)")
    # $conn -join ($PRTHost, $PRTDomainName)
    Add-Printer -ConnectionName "\\fs-LLN\PRT2 LKRZaal - 758 - (kant parking)"
    # Add-PrinterDriver -Name "$PRTName" -InfPath "\\fs-LLN\Driver\Windows11\konika758\KOAXOJ_.INF"
}
AddNetworkPrinter
#IMPORT the drivers in the driver store pnputil.exe -i -a C:\Distr\HP-pcl6-x64\*.inf
