

Function UserPasswordReset()
{
    $Password = ConvertTo-SecureString "Cloud2022" -AsPlainText -Force
    $DC = "DC=Handelsschoolaalst, DC=be"
    $Domain = "DeHandelsschool"
    $MainGroup = "Leerkrachten"
    Get-ADUser -Filter * -SearchBase "OU=$MainGroup,$DC" | Set-ADAccountPassword -Reset -NewPasword $Password #-ChangePasswordAtLogon $true
}
UserPasswordReset 
#Author - https://github.com/BeauRoels