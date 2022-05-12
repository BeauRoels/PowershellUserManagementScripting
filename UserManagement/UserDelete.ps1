$ADServer = "\\ActiveDirectory-SERVER"
$FileServer = "\\ActiveDirectory-SERVER2"
$DC = "DC=DOMAIN, DC=be"
$Domain = "DOMAIN"
$MainGroup = "PRIMARYGROUP"
$Group = "GROUP"
$MainFolder= "PRIMARYFOLDER"
$Moderator= "MODERATOR"

#delete users

 Function DeleteUsers
 {
   Write-Host "Deleting all users in PRIMARYGROUP"
   Get-ADOrganizationalUnit -LDAPFilter '(name=*)' -SearchBase "OU=$Group, $DC" -SearchScope OneLevel | Remove-ADOrganizationalUnit -Recursive
   Write-Host "Users deleted..."
 }
 Function DeleteUserDirectory
 {
    Write-Host "Deleting all Folders in PRIMARYFOLDER Directory"
    Get-ChildItem "$ADServer\$MainFolder" | Remove-Item -Recurse -Force 
    Write-Host "Folders deleted..."
 }
 DeleteUsers
 DeleteUserDirectory
