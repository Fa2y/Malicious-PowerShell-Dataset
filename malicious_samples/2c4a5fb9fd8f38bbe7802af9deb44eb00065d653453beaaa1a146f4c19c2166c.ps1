# Set the path to the Paint executable
$PaintPath = "C:\Windows\System32\mspaint.exe"

# Launch Paint in full screen mode
Start-Process $PaintPath -ArgumentList "/pt", "`"$($env:USERPROFILE)\Desktop\smile.bmp`"", "/max"

# Wait for Paint to open
Start-Sleep -Seconds 2

# Simulate a mouse click to select the brush tool
[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point(60, 130)
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")

# Simulate mouse movements to draw a smile on the canvas
[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point(300, 300)
[System.Windows.Forms.SendKeys]::SendWait("{LEFT 50}{DOWN 50}{LEFT 50}{UP 50}{LEFT 50}{DOWN 50}{LEFT 50}")

# Wait for the drawing to complete
Start-Sleep -Seconds 5

# Close the Paint application
Get-Process mspaint | Foreach-Object { $_.CloseMainWindow() | Out-Null }
