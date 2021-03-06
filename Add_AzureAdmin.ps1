#get current AzureAD user
$user = (Get-WMIObject -class Win32_ComputerSystem | select username).username

#add user to administrators group
Add-LocalGroupMember -Group "Administrators" -Member $user

#force restart for changes to take effect
Start-Sleep -s 5
Restart-Computer -force
