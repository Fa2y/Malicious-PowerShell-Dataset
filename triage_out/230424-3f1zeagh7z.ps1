function Show-MyMessage{
    param(
        $Message = 'Default message',
        $Title = 'Program Message',
        $Location = '100,100'
    )
    Add-Type -AssemblyName System.Windows.Forms
    $form = [System.Windows.Forms.Form]::New()
    $form.StartPosition = 'Manual'
    $form.Location = $Location
    $form.Text = $Title
    $label =  [System.Windows.Forms.Label]::New()
    $form.Controls.Add($label)
    $label.Dock = 'Fill'
    $label.Text = $Message
    $form.ShowDialog()
}
Show-MyMessage
$longMsg = @'

   This is an example of a very long message
   with many lines to display
   in your new box

           --- The Management
'@
Show-MyMessage $longMsg -Location '300,300'