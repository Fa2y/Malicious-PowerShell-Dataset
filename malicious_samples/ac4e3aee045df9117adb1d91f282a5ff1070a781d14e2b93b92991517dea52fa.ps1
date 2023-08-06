set-executionpolicy -executionpolicy bypass
Install-Module -Name PSWindowsUpdate -RequiredVersion 2.2.0.2 | Import-Module

Get-WURebootStatus

Get-WUSettings