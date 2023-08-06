Add-Type -AssemblyName System.Windows.Forms
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Win32 {
    [DllImport("user32.dll")]
    public static extern int ShowCursor(bool bShow);
}
"@ # :-D

[Win32]::ShowCursor($false)
# Erstelle ein neues Formular
$form = New-Object System.Windows.Forms.Form

# Setze die Formulareigenschaften
$form.FormBorderStyle = 'None' # Setze das Formular auf randlos
$form.WindowState = 'Maximized' # Maximiere das Formular
$form.BackColor = 'Black' # Setze die Hintergrundfarbe auf Schwarz
$form.Topmost = $true # Setze das Formular immer in den Vordergrund
Start-Process powershell.exe -WindowStyle Hidden -ArgumentList '-Command "[console]::beep(2000,3000)"' #lol
# Zeige das Formular an
$form.ShowDialog() | Out-Null

