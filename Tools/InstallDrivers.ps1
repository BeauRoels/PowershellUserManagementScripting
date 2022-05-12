
Function AddNetworkPrinterDriver{
    $Path = Read-Host -Prompt 'Input the path of the ...x86.inf file' 
    pnputil.exe /add-driver "$Path"
}
AddNetworkPrinterDriver
#Author - https://github.com/BeauRoels