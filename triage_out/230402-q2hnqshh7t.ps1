New-Item "$env:UserProfile\Desktop\miArchivo.txt" -ItemType "file"


Set-Content "$env:UserProfile\Desktop\miArchivo.txt" "Este es el contenido de mi archivo de texto."

notepad "$env:UserProfile\Desktop\miArchivo.txt" 