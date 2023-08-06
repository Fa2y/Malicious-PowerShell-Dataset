Add-Type -AssemblyName PresentationFramework
$popup = New-Object System.Windows.Window
$popup.Title = "ERROR"
$popup.WindowStyle = 'ToolWindow'
$popup.WindowStartupLocation = 'CenterScreen'
$popup.SizeToContent = 'WidthAndHeight'
$popup.Topmost = $true
$popup.ResizeMode = 'NoResize'
$popup.WindowState = 'Maximized'
$popup.Background = "Rainbow" # setting rainbow background
$popup.ShowDialog()

$player = New-Object System.Media.SoundPlayer "C:\Path\To\MarkiplierMusic.wav" # change path to Markiplier music
$player.Play()

do {
    [System.Windows.Forms.MessageBox]::Show("Error", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    Start-Sleep -Seconds 1
} while ($true)
