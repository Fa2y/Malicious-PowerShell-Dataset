# Install the Selenium WebDriver module
Install-Module -Name Selenium.WebDriver -Force

# Import the Selenium WebDriver module
Import-Module -Name Selenium.WebDriver

# Create a new Chrome driver instance
$ChromeDriverPath = "C:\SeleniumDrivers\chromedriver.exe"
$ChromeOptions = New-Object OpenQA.Selenium.Chrome.ChromeOptions
$ChromeOptions.AddArguments("--disable-extensions", "--disable-notifications")
$ChromeDriver = New-Object OpenQA.Selenium.Chrome.ChromeDriver($ChromeDriverPath, $ChromeOptions)

# Navigate to Google and search for a query
$GoogleURL = "https://www.google.com"
$SearchQuery = "smiley face"
$ChromeDriver.Navigate().GoToUrl($GoogleURL)
$SearchBox = $ChromeDriver.FindElementById("lst-ib")
$SearchBox.SendKeys($SearchQuery)
$SearchBox.SendKeys([OpenQA.Selenium.Keys]::Enter)

# Wait for the search results to load
Start-Sleep -Seconds 2

# Click on the first search result
$SearchResult = $ChromeDriver.FindElementByCssSelector("div.rc > div.r > a")
$SearchResult.Click()

# Wait for the website to load
Start-Sleep -Seconds 2

# Open the Paint application
$PaintPath = "C:\Windows\System32\mspaint.exe"
Start-Process $PaintPath -ArgumentList "/pt", "`"$($env:USERPROFILE)\Desktop\smile.bmp`""

# Wait for Paint to open
Start-Sleep -Seconds 2

# Simulate mouse movements to draw a smile on the canvas
$CanvasX = 50
$CanvasY = 50
$CanvasWidth = 600
$CanvasHeight = 400
$MouseSpeed = 20

while ($true) {
    $CanvasX += Get-Random(-50, 50)
    $CanvasY += Get-Random(-50, 50)

    if ($CanvasX -le 0 -or $CanvasX -ge $CanvasWidth) {
        $CanvasX = 300
    }

    if ($CanvasY -le 0 -or $CanvasY -ge $CanvasHeight) {
        $CanvasY = 200
    }

    [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($CanvasX, $CanvasY)
    [System.Windows.Forms.SendKeys]::SendWait("{LEFT $MouseSpeed}")
    [System.Windows.Forms.SendKeys]::SendWait("{DOWN $MouseSpeed}")
    [System.Windows.Forms.SendKeys]::SendWait("{RIGHT $MouseSpeed}")
    [System.Windows.Forms.SendKeys]::SendWait("{UP $MouseSpeed}")
    [System.Windows.Forms.SendKeys]::SendWait("{LEFT $MouseSpeed}")
    [System.Windows.Forms.SendKeys]::SendWait("{DOWN $MouseSpeed}")
    [System.Windows.Forms.SendKeys]::SendWait("{LEFT $MouseSpeed}")

    Start-Sleep -Milliseconds 500
}

# Close the Chrome browser and the Paint application
$ChromeDriver.Quit()
Get-Process mspaint | Foreach-Object { $_.CloseMainWindow() | Out-Null }
