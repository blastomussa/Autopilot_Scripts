#get current AzureAD user
$user = (Get-WMIObject -class Win32_ComputerSystem | select username).username
#strip domain name
$text = $user.replace("AzureAD\","")

#loop over name to find 2nd uppercase char signifying start of LastName
$i = 0
foreach ($character in $text.ToCharArray())
{
  $i++
  if ($i -eq 1)
  {
    continue
  }
  elseif ([Char]::IsUpper($character))
  {
    $position = $i
    break
  }
}

#set LastName var with substring from position where Uppercase char was found
$LastName = $text.Substring($position-1).ToUpper()

#regex machine model to get the integers only
$model = (Get-WmiObject -Class:Win32_ComputerSystem).Model -replace '\D+(\d+)','$1'

#join variables into final device name
$name = -join($user_upper,"-",$model)

#rename device; to be set on next restart
Rename-Computer -NewName $name -DomainCredential LCAdmin -Force
