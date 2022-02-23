function Get-HWID {
    $hwid_path = (Join-Path -Path $env:USERPROFILE -ChildPath "\Desktop\HWID")
    New-Item -Type Directory -Path $hwid_path -Force
    Set-Location -Path $hwid_path
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted -Force
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
    Install-Script -Name Get-WindowsAutoPilotInfo -Force
    Get-WindowsAutoPilotInfo.ps1 -OutputFile AutoPilotHWID.csv
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy restricted -Force
}

Get-HWID
