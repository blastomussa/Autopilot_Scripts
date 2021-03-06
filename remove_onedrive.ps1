#Remove OnDrive folder from File Explorer

# /v is the REG_DWORD /t Specifies the type of registry entries /d Specifies the data for the new entry /f Adds or deletes registry content without prompting for confirmation.

REG ADD "HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d "0" /f
REG ADD "HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}
" /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d "0" /f
