Add-Type -AssemblyName PresentationFramework
$popup = New-Object System.Windows.Window
$popup.Title = "MARK GOT YOU :)"
$popup.WindowStyle = 'ToolWindow'
$popup.WindowStartupLocation = 'CenterScreen'
$popup.SizeToContent = 'WidthAndHeight'
$popup.Topmost = $true
$popup.ResizeMode = 'NoResize'
$popup.WindowState = 'Maximized'
$popup.ShowDialog()

Start-Sleep -Seconds 5

do {
    Start-Process -FilePath "chrome.exe" -ArgumentList "https://www.youtube.com/user/markiplierGAME" -WindowStyle Maximized
    Start-Sleep -Seconds 1
} while ($true)
