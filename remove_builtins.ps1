# must be run from user not system powershell
Get-AppxPackage *mixedreality* | Remove-AppxPackage -AllUsers
Get-AppxPackage *3dviewer* | Remove-AppxPackage -AllUsers
Get-AppxPackage *xbox* | Remove-AppxPackage -AllUsers
