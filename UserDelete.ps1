
$FileserverLLN = "\\FS-LLN"
$FileserverPERS = "\\FS-Personeel"
$DC = "DC=Handelsschoolaalst, DC=be"
$Domain = "TEST"
$MainGroup = "Leerlingen"
$MainFolder= "leerlingen"
$Moderator= "leerkrachten"

#delete users
function DeleteDisabledUsers {
    $disabledUsers = Get-ADUser -Filter * -Property Enabled | Where-Object {$_.Enabled -like "False"} | Select-Object SamAccountName

    ForEach ($user in $disabledUsers)
    {
       Write-Host "Deleting User account" $user
       Remove-ADUser -Identity $user.SamAccountName
    }
 }
 function Deleteinactiveaccounts {
    $lastdate= (Get-Date).AddDays(-180)
    Get-ADUser -Properties LastLogonDate -Filter {LastLogonDate -lt $lastdate } | Remove-ADUser
 }
 function DeleteAll {
    
   Get-ADUser -Filter * | Remove-ADUser 
 }

 DeleteAll
