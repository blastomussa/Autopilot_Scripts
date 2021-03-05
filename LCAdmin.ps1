$p = "******"
$password = ConvertTo-SecureString -String $p
New-LocalUser -Name "LocalAdmin" -Password $password -Description "Local Admin Account" -UserMayNotChangePassword -AccountNeverExpires -PasswordNeverExpires
Start-Sleep -s 5
Add-LocalGroupMember -Group "Administrators" -Member "LocalAdmin"
