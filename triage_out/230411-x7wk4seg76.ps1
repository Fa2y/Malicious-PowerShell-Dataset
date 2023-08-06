Remove-Item "$HOME\Desktop\*" -Force
$carpeta = "$HOME\Desktop"
for ($i=1; $i -le 50; $i++) {
  $nombreArchivo = "$i"
  $rutaCompleta = Join-Path $carpeta $nombreArchivo
  New-Item -ItemType File -Path $rutaCompleta -Force
}

