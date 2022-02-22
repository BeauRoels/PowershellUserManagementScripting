
$FileserverLLN = "\\FS-LLN"
$FileserverPERS = "\\FS-Personeel"
$DC = "DC=Handelsschoolaalst, DC=be"
$Domain = "DeHandelsschool"
$MainGroup = "Leerlingen"
$MainFolder= "leerlingen"
$Moderator= "leerkrachten"

$FileserverLLN = "\\WIN-8KV6AGI5ESN"
$FileserverPERS = "\\WIN-8KV6AGI5ESN"
$DC = "DC=TEST, DC=be"
$Domain = "TEST"
$MainGroup = "Leerlingen"
$MainFolder= "leerlingen"
$Moderator= "leerkracht"

$DC = "DC=TEST, DC=be"

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
    Get-ChildItem "$FileserverLLN\$MainFolder\*" Remove-Item -Recurse -Force 
    Write-Host "Folders deleted..."
 }
 DeleteLeerlingen
 DeleteLeerlingenDirectory
