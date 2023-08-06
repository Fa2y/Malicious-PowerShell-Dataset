# Start the Paint application
Start-Process mspaint

# Wait for Paint to open
Start-Sleep -Seconds 3

# Set the coordinates for the smiley face
$smileyFace = @( (100, 100), (125, 75), (150, 100), (150, 125), (100, 125) )

# Open Paint's drawing tools
$wshell = New-Object -ComObject wscript.shell
$wshell.SendKeys('%{h}n')

# Loop through each point in the smiley face and draw it
foreach ($point in $smileyFace) {
    [System.Windows.Forms.Cursor]::Position = [System.Drawing.Point]::new($point[0], $point[1])
    [System.Windows.Forms.Mouse]::LeftDown()
    [System.Windows.Forms.Cursor]::Position = [System.Drawing.Point]::new($point[0] + 1, $point[1] + 1)
    [System.Windows.Forms.Mouse]::LeftUp()
    Start-Sleep -Milliseconds 100
}

# Close Paint
Get-Process mspaint | Stop-Process
