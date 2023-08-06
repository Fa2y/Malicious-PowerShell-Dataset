[CmdletBinding()]
   param(
       [int] $ID,
       [string] $Computer,
       [int[]] $Port,
       [switch] $Dns,
       [int] $PortConnectTimeout,
       [string] $scriptPath
   )
   $RunspaceTimers.$ID = Get-Date
   if (-not $PortData.ContainsKey($Computer))
   {
       $PortData[$Computer] = New-Object -TypeName PSObject -Property @{ 
           ComputerName = $Computer
       }
   }
   if ($Dns)
   {
       $ErrorActionPreference = 'SilentlyContinue'
       $HostEntry = [System.Net.Dns]::GetHostEntry($Computer)
       $Result = $?
       $ErrorActionPreference = 'Continue'
       if ($Result)
       {
           if ($HostEntry.HostName.Split('.')[0] -ieq $Computer.Split('.')[0])
           {
               $IPDns = @($HostEntry | Select -Expand AddressList | Select -Expand IPAddressToString)
           }
           else
           {
               $IPDns = @(@($HostEntry.HostName) + @($HostEntry.Aliases)) # -join ';') -join ';' -replace ';\z'
           }
           $PortData[$Computer] | Add-Member -MemberType NoteProperty -Name 'IP/DNS' -Value $IPDns
       }
       else {
           $PortData[$Computer] | Add-Member -MemberType NoteProperty -Name 'IP/DNS' -Value $Null
       }
       continue
   } # end of if $Dns
   foreach ($p in $Port | Sort-Object) { # only one port per thread, legacy code...
       Write-Verbose -Message "Processing ${Computer}, port $p in thread."
       $MySock, $IASyncResult, $Result = $Null, $Null, $Null
       $MySock = New-Object Net.Sockets.TcpClient
       $IASyncResult = [IAsyncResult] $MySock.BeginConnect($Computer, $p, $null, $null)
       $Result = $IAsyncResult.AsyncWaitHandle.WaitOne($PortConnectTimeout, $true)
       if ($MySock.Connected)
       {
           $MySock.Close()
           $MySock.Dispose()
           $MySock = $Null
           Write-Verbose "${Computer}: Port $p is OPEN"
           Write-Host "[${Computer}]: +++ "
           #$PortData[$Computer] | Add-Member -MemberType NoteProperty -Name "Port $p" -Value $True
           $PortData[$Computer] | Add-Member -MemberType NoteProperty -Name "Port $p" -Value "OK"
       }
       else
       {
           $MySock.Close()
           $MySock.Dispose()
           $MySock = $Null
           Write-Verbose "${Computer}: Port $p is CLOSED"
           Write-Host "[${Computer}]: --- "
           #$PortData[$Computer] | Add-Member -MemberType NoteProperty -Name "Port $p" -Value $False
           $PortData[$Computer] | Add-Member -MemberType NoteProperty -Name "Port $p" -Value "---"
       }
       $mutexName = 'psnProc'
       $mutex = New-Object 'Threading.Mutex' $false, $mutexName
       $mutexHole = $mutex.WaitOne()

       $logString = ''
       $obj = $PortData[$Computer]
       [string]$logString = $Computer + ";" + $obj.Ping + ";" + $obj.$("Port $p") + ";" + $obj.'IP/DNS'
      
       Out-File $($scriptPath + "\" + "PC.csv") -InputObject $logString -Encoding utf8 -Force -Append

       $mutex.ReleaseMutex()
   }
