$LiveCred = Get-Credential
#Openening a session with microsoft exchange
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $LiveCred -Authentication Basic -AllowRedirection
Import-PSSession $Session



$CSVFolder = "c:\temp\AzureUserExport.csv"
Function AzureExport(){
    #Testing
    $LiveCred = Get-Credential
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $LiveCred -Authentication Basic -AllowRedirection
    Set-ExecutionPolicy RemoteSigned
    Import-PSSession $Session
    (Get-Mailbox) | Foreach {Get-MailboxStatistics $_.Identity | Select DisplayName, LastLogonTime} | Export-CSV $Home\Desktop\LastLogonDate.csv
    Remove-PSSession $Session
}
Function InactiveUSers()
{
    #testing
    $When = ((Get-Date).AddDays(-100)).Date
    Get-MsolUser -Filter {LastLogonDate -lt $When} -Properties * | select-object samaccountname,givenname,@{N="LastLogonDate";E={(Get-MailboxStatistics $_.UserPrincipalName).LastLogonTime}}, Description| Sort-Object Description, Surname| Export-Csv -path "$CSVFolder" -NoTypeInformation 
}
Function OfficeUsers()
{
    $Result=@() 
    #This might break it, i don't know the correct format until i test it. I assume it's EPOCH.
    $When = ((Get-Date).AddDays(-100)).Date
    $AllMailboxes = Get-Mailbox -ResultSize Unlimited
    #Getting the total number of AllMailboxes in from the users in AD.
    $totalMailbox = $AllMailboxes.Count
    $i = 1 
    #Looping through the AllMailboxes.
    $AllMailboxes | ForEach-Object {
    $i++
    $Mailbox = $_
    #Getting the needed stats, using a filter to (hopefully) only get "inactive" users.
    $MailboxStatistics = Get-MailboxStatistics -Identity $Mailbox.UserPrincipalName  | Select LastLogonTime

    #If a user has never logged on to their mailbox, it will be added to the status.
    if ($MailboxStatistics.LastLogonTime -eq $null){
    $lt = "Never Logged In"
    }else{
    $lt = $MailboxStatistics.LastLogonTime }
    
    Write-Progress -activity "Processing $Mailbox" -status "$i out of $totalMailbox completed"
    
    #Adding the results to the final export. 
    $Result += New-Object PSObject -property @{ 
    Name = $Mailbox.DisplayName
    UserPrincipalName = $Mailbox.UserPrincipalName
    LastLogonTime = $lt }
    }
    
    $Result | Export-CSV "$CSVFolder" -NoTypeInformation -Encoding UTF8 
}
OfficeUsers

