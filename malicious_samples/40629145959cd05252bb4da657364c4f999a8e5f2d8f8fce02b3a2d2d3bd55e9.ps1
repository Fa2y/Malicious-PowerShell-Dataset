$url = "https://www.google.com/search?q=saul+goodman&tbm=isch&tbo=u&source=univ&sa=X&ved=0ahUKEwi4t4yhs4_TAhUEzGMKHbgdBu8Q7AkIRA&biw=1920&bih=950"
$wc = New-Object System.Net.WebClient
$html = $wc.DownloadString($url)
$startIndex = $html.IndexOf("imgres?imgurl=") + 15
$endIndex = $html.IndexOf("&amp;imgrefurl=",$startIndex)
$imageUrl = $html.SubString($startIndex,$endIndex - $startIndex)
$imageUrl = $imageUrl.Replace("&amp;","&")
$image = $wc.DownloadFile($imageUrl, "saul_goodman.jpg")

Add-Type -AssemblyName System.Windows.Forms
$desktop = [System.Windows.Forms.SystemInformation]::MonitorWorkingArea
set-itemproperty -path 'HKCU:\Control Panel\Desktop' -name Wallpaper -value "C:\saul_goodman.jpg"
[System.Windows.Forms.Application]::SetWallpaper("C:\saul_goodman.jpg")