$CSVFolder = "c:\temp\userexport.csv"
$ADServer = "\\ActiveDirectory-SERVER"
$FileServer = "\\ActiveDirectory-SERVER"
$DC = "DC=DOMAIN, DC=be"
$Domain = "DOMAIN"
$MainGroup = "PRIMARYGROUP"
$Group = "GROUP"
$Moderator= "MODERATOR"

Function ExportADUsersToCSVFile{
    #Write users out in CSV file use -properties displayName to force the entity to be loaded and then call it to show it
    Write-Host "Exporting Active direcory users to CSV File..."
    Get-ADUser -Filter * -SearchBase "OU=$MainGroup, $DC" -Properties *  | Select -Property SamAccountName, UserPrincipalName, Surname, DisplayName, Description| Sort-Object Description, Surname| Export-Csv -path "$CSVFolder" -NoTypeInformation 
    Write-Host "CSV file: userexport, has been created in $CSVFolder"
}
ExportADUsersToCSVFile

