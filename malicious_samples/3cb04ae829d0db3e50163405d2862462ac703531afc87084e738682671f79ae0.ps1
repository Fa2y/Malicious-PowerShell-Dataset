$user = whoami.exe
$action = New-ScheduledTaskAction -Execute 'C:\Windows\System32\calc.exe'
$trigger = New-ScheduledTaskTrigger -AtLogOn
$principal = New-ScheduledTaskPrincipal -UserId $user -LogonType ServiceAccount
$settings = New-ScheduledTaskSettingsSet
$task = New-ScheduledTask -Action $action -Trigger $trigger -Principal $principal -Settings $settings

Register-ScheduledTask -TaskName "TaskName" -InputObject $task
