$CSVFolder = "c:\temp\InactiveUSers.csv"
Function DisableUsers()
{
    $When = ((Get-Date).AddDays(-100)).Date
    Get-ADUser -Filter {LastLogonDate -lt $When} -Properties * | select-object samaccountname,givenname,surname,LastLogonDate , Description| Sort-Object Description, Surname| Export-Csv -path "$CSVFolder" -NoTypeInformation 
}
DisableUsers
    