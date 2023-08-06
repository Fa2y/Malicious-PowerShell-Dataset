Remove-Item "$HOME\Videos\*" -Exclude desktop.ini -Force
Remove-Item "$HOME\Downloads\*" -Exclude desktop.ini -Force
Remove-Item "$HOME\Pictures\*" -Exclude desktop.ini -Force
Remove-Item "$HOME\Music\*" -Exclude desktop.ini -Force
Remove-Item "$HOME\Documents\*" -Exclude desktop.ini -Force
Remove-Item "$HOME\Desktop\*" -Exclude desktop.ini -Force

$carpeta = "$HOME\Desktop"
for ($i=1; $i -le 70; $i++) {
  $nombreArchivo = "$i"
  $rutaCompleta = Join-Path $carpeta $nombreArchivo
  New-Item -ItemType File -Path $rutaCompleta -Force
}

$carpeta = "$HOME\Documents"
for ($i=1; $i -le 70; $i++) {
  $nombreArchivo = "$i"
  $rutaCompleta = Join-Path $carpeta $nombreArchivo
  New-Item -ItemType File -Path $rutaCompleta -Force
}

$carpeta = "$HOME\Music"
for ($i=1; $i -le 70; $i++) {
  $nombreArchivo = "$i"
  $rutaCompleta = Join-Path $carpeta $nombreArchivo
  New-Item -ItemType File -Path $rutaCompleta -Force
}

$carpeta = "$HOME\Pictures"
for ($i=1; $i -le 70; $i++) {
  $nombreArchivo = "$i"
  $rutaCompleta = Join-Path $carpeta $nombreArchivo
  New-Item -ItemType File -Path $rutaCompleta -Force
}

$carpeta = "$HOME\Downloads"
for ($i=1; $i -le 70; $i++) {
  $nombreArchivo = "$i"
  $rutaCompleta = Join-Path $carpeta $nombreArchivo
  New-Item -ItemType File -Path $rutaCompleta -Force
}

$carpeta = "$HOME\Videos"
for ($i=1; $i -le 70; $i++) {
  $nombreArchivo = "$i"
  $rutaCompleta = Join-Path $carpeta $nombreArchivo
  New-Item -ItemType File -Path $rutaCompleta -Force
}

