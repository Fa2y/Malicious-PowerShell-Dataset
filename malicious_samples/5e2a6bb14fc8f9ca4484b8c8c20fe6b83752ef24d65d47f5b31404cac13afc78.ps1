# Set the path to the Paint executable
$PaintPath = "C:\Windows\System32\mspaint.exe"

# Launch Paint in full screen mode
Start-Process $PaintPath -ArgumentList "/pt", "`"$($env:USERPROFILE)\Desktop\smiley.bmp`"", "/max"

# Wait for Paint to open
Start-Sleep -Seconds 2

# Simulate a mouse click to select the brush tool
[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point(60, 130)
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")

# Simulate mouse movements to draw the smiley face
[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point(400, 400)
[System.Windows.Forms.SendKeys]::SendWait("{LEFT 100}{DOWN 100}{LEFT 50}{UP 50}{LEFT 50}{DOWN 50}{LEFT 50}{UP 100}")

# Wait for the drawing to complete
Start-Sleep -Seconds 
