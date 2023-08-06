Add-Type -AssemblyName PresentationFramework

$popup1 = New-Object System.Windows.Window
$popup1.Title = "Calculator Virus Detected!"
$popup1.WindowStyle = 'ToolWindow'
$popup1.WindowStartupLocation = 'CenterScreen'
$popup1.SizeToContent = 'WidthAndHeight'
$popup1.Topmost = $true
$popup1.ResizeMode = 'NoResize'
$popup1.WindowState = 'Maximized'

$okButton = New-Object System.Windows.Controls.Button
$okButton.Content = "OK"
$okButton.Add_Click({ $popup1.Close() })

$howButton = New-Object System.Windows.Controls.Button
$howButton.Content = "HOW THE FUCK?"
$howButton.Add_Click({ 
    for ($i=1; $i -le 10; $i++) {
        Start-Process -FilePath "calc.exe"
    }
})

$buttonsStackPanel = New-Object System.Windows.Controls.StackPanel
$buttonsStackPanel.Children.Add($okButton)
$buttonsStackPanel.Children.Add($howButton)

$popup1.Content = $buttonsStackPanel
$popup1.ShowDialog()

$popup2 = New-Object System.Windows.Window
$popup2.Title = "Calculator Virus Removed!"
$popup2.WindowStyle = 'ToolWindow'
$popup2.WindowStartupLocation = 'CenterScreen'
$popup2.SizeToContent = 'WidthAndHeight'
$popup2.Topmost = $true
$popup2.ResizeMode = 'NoResize'
$popup2.WindowState = 'Maximized'

$okButton2 = New-Object System.Windows.Controls.Button
$okButton2.Content = "OK"
$okButton2.Add_Click({ $popup2.Close() })

$message = New-Object System.Windows.Controls.TextBlock
$message.Text = "Congratulations, the virus has been removed!"

$buttonsStackPanel2 = New-Object System.Windows.Controls.StackPanel
$buttonsStackPanel2.Children.Add($message)
$buttonsStackPanel2.Children.Add($okButton2)

$popup2.Content = $buttonsStackPanel2
$popup2.ShowDialog()
