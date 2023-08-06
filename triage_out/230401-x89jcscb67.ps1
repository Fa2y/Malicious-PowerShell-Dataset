# Set the path to the Chrome executable
$ChromePath = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"

# Set the URL to the Epic website
$Url = "https://www.epic.com/"

# Launch a new Chrome window with the URL
Start-Process $ChromePath -ArgumentList $Url
