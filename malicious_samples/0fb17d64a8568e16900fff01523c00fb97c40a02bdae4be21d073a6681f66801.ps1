Start-Sleep -Seconds 5
Add-Type -AssemblyName System.Windows.Forms
$screenWidth = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
$screenHeight = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height
$random = New-Object System.Random
do {
    $x = $random.Next(0, $screenWidth)
    $y = $random.Next(0, $screenHeight)
    [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
    Start-Sleep -Milliseconds 500
} while ($true)

