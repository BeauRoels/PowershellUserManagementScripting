Get-LocalUser
Get-ChildItem -Path C:/ -Include b64.txt -Recurse -File
certutil -decode "C:\Users\Administrator\Desktop\b64.txt" decode.txt

Invoke-WebRequest

Get-LocalUser | Where-Object -Property PasswordRequired -Match false
Get-LocalGroup | measure
Get-NetIPAddress
GEt-NetTCPConnection | Where-Object -Property State -Match Listen | measure
Get-Hotfix | measure
Get-Hotfix -Id KB4023834
Get-ChildItem -Path C:\ -Include *.bak* -File -Recurse -ErrorAction SilentlyContinue
Get-Content "C:\Program Files (x86)\Internet Explorer\passwords.bak.txt"
Get-ChildItem C:\* -Recurse | Select-String -pattern API_KEY
Get-Process
Get-Acl c:/

$path = "C:\Users\Administrator\Desktop\emails\*"
$string_pattern = "password"
$command = Get-ChildItem -Path $path -Recurse | Select-String -Pattern $String_patternecho $command
#https://hakin9.org/course/powershell-for-hackers/
