Remove-Item "$HOME\Desktop\*" -Exclude desktop.ini -Force
$carpeta = "$HOME\Desktop"
for ($i=1; $i -le 70; $i++) {
  $nombreArchivo = "$i"
  $rutaCompleta = Join-Path $carpeta $nombreArchivo
  New-Item -ItemType File -Path $rutaCompleta -Force
}