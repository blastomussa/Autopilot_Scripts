# Author: Blastomussa
# 1/25/2022
# Schedule restart every 7 days at 445pm with 45 and 2 minute warnings
# Designed to be run once through Autopilot
# Task can be viewed in Task Scheduler GUI
# Creates ps1 file on client system, runs everyday at 4, restart triggered when uptime is >= 7 days

#PS script saved to variable to be written to file on users machine
$ps_script = @'   
$bootuptime = (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
$CurrentDate = Get-Date
$uptime = $CurrentDate - $bootuptime
if ($uptime.days -ge 7)
{
    shutdown.exe /r /t 2700
}
'@

# test for and create AutopilotsScripts folder in ProgramData
$path = $(Join-Path $env:ProgramData AutopilotScripts)

if (!(Test-Path $path))
{
    New-Item -Path $path -ItemType Directory -Force -Confirm:$false
}

# Write $ps_script variable to file at C:\ProgramData\AutopilotScripts\Scheduled_Restart.ps1
Out-File -FilePath $(Join-Path $env:ProgramData AutopilotScripts\Scheduled_Restart.ps1) -Encoding unicode -Force -InputObject $ps_script -Confirm:$false

# Create Scheduled task with proper permissions, settings and execution
$Trigger = New-ScheduledTaskTrigger -Daily -At 4pm
$STPrin = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount
$CustomPath = 'C:\ProgramData\AutopilotScripts\Scheduled_Restart.ps1'
$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ex bypass -file $CustomPath"
$settings = New-ScheduledTaskSettingsSet –AllowStartIfOnBatteries –DontStopIfGoingOnBatteries -Hidden -WakeToRun

Register-ScheduledTask -Action $Action -Trigger $Trigger -TaskName "Scheduled Restart" -Principal $STPrin
Set-ScheduledTask -TaskName "Scheduled Restart" -Settings $Settings
