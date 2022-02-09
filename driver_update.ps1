# Author: Blastomussa
# 2/8/2022
# Schedule driver update every 14 days
# Designed to be run once through Autopilot
# Task can be viewed in Task Scheduler GUI
# Creates ps1 file on client system, runs on Wednesdays every 4 weeks at 12PM,
# Must be run with elevated priveleges

# Dell Command Update CLI script
$ps_script = @'
$dcu_cli = 'C:\Program Files\Dell\CommandUpdate\dcu-cli.exe'

# test for dell command update cli
if (Test-Path -Path $dcu_cli) {
    # BIOS not included in update
    Start-Process -FilePath "C:\Program Files\Dell\CommandUpdate\dcu-cli.exe" -ArgumentList "/scan -updatetype=firmware,driver,apps -silent -updateSeverity=recommended,critical,security" -Wait
    Start-Process -FilePath "C:\Program Files\Dell\CommandUpdate\dcu-cli.exe" -ArgumentList "/applyupdates -updatetype=firmware,driver,apps -silent -reboot=disable -updateSeverity=recommended,critical,security" -Wait
    Exit 0
} else {
    Exit 1
}
'@

# test for and create AutopilotsScripts folder in ProgramData
$path = $(Join-Path $env:ProgramData AutopilotScripts)

if (!(Test-Path $path))
{
    New-Item -Path $path -ItemType Directory -Force -Confirm:$false
}

# Write $ps_script variable to file at C:\ProgramData\AutopilotScripts\driver_update.ps1
Out-File -FilePath $(Join-Path $env:ProgramData AutopilotScripts\driver_update.ps1) -Encoding unicode -Force -InputObject $ps_script -Confirm:$false

# Create Scheduled task with proper permissions, settings and execution
$Trigger = New-ScheduledTaskTrigger -Weekly -WeeksInterval 4 -DaysOfWeek Wednesday -At 12pm

# Use system account with elevated priveleges 
$STPrin = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount

# Set Task action
$CustomPath = 'C:\ProgramData\AutopilotScripts\driver_update.ps1'
$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ex bypass -file $CustomPath"

# Configure Task settings
$settings = New-ScheduledTaskSettingsSet –AllowStartIfOnBatteries –DontStopIfGoingOnBatteries -Hidden -WakeToRun

# Resister task and apply settings
Register-ScheduledTask -Action $Action -Trigger $Trigger -TaskName "Dell Command Update" -Principal $STPrin
Set-ScheduledTask -TaskName "Dell Command Update" -Settings $Settings
