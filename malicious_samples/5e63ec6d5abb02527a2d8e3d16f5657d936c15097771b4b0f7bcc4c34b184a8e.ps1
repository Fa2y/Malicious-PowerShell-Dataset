# 指定要执行的程序路径

$ProgramPath = "C:\Users\admin\Desktop\Start.exe"

# 创建任务计划的操作
$Action = New-ScheduledTaskAction -Execute $ProgramPath

# 自启动
$Trigger = New-ScheduledTaskTrigger -AtStartup

# 创建任务计划的安全主体，以管理员权限运行
$Principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -RunLevel Highest

Register-ScheduledTask -Action $Action -Trigger $Trigger -Principal $Principal -TaskName "MyProgram Task" -Description "This task runs MyProgram.exe with administrator privileges."


#卸载任务计划
#Unregister-ScheduledTask -TaskName "MyProgram Task" -Confirm:$false