$url = "https://source.unsplash.com/random/1920x1080"
$savePath = "$env:USERPROFILE\Pictures\jamie_oliver_background.jpg"

Invoke-WebRequest $url -OutFile $savePath

Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'Wallpaper' -Value $savePath
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters