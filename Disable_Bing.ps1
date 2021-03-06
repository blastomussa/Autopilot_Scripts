#Disable Bing search in start menu; requires restart

# /v is the REG_DWORD /t Specifies the type of registry entries /d Specifies the data for the new entry /f Adds or deletes registry content without prompting for confirmation.

REG ADD "Computer\HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\Explorer
" /v DisableSearchBoxSuggestions /t REG_DWORD /d "1" /f
