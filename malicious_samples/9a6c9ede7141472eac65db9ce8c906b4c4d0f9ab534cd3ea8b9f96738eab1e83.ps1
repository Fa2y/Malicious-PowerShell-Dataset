# Start Microsoft Paint
Start-Process mspaint

# Wait for Paint to load
Start-Sleep -Seconds 2

# Set the cursor position and draw the smiley face
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
$cursor = New-Object System.Windows.Forms.Cursor([System.Windows.Forms.Cursor]::Current.Handle)
[Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point(300,300)
[System.Windows.Forms.SendKeys]::SendWait(":)")

# Repeat the drawing
$repeatCount = 5
for ($i=0; $i -lt $repeatCount; $i++) {
    # Wait for a second
    Start-Sleep -Seconds 1
    
    # Set the cursor position and draw the smiley face again
    [Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point(350,350)
    [System.Windows.Forms.SendKeys]::SendWait(":)")
}
