
$FileserverLLN = "\\FS-LLN"
$FileserverPERS = "\\FS-Personeel"
$DC = "DC=Handelsschoolaalst, DC=be"
$Domain = "DeHandelsschool"
$MainGroup = "Leerlingen"
$MainFolder= "leerlingen"
$Moderator= "leerkrachten"

#delete users

 Function DeleteLeerlingen
 {
   Write-Host "Deleting all users in Leerlingen"
   Get-ADOrganizationalUnit -LDAPFilter '(name=*)' -SearchBase "OU=Leerlingen, $DC" -SearchScope OneLevel | Remove-ADOrganizationalUnit -Recursive
   Write-Host "Users deleted..."
 }
 Function DeleteLeerlingenDirectory
 {
    Write-Host "Deleting all Folders in Leerlingen Directory"
    Get-ChildItem "$FileserverLLN\$MainFolder" | Remove-Item -Recurse -Force 
    Write-Host "Folders deleted..."
 }
 DeleteLeerlingen
 DeleteLeerlingenDirectory
