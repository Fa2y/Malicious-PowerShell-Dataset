function Invoke-ObfuscateRandomFiles {
    param(
        [string]$Directory,
        [string[]]$CommandList
    )
    
    $maximumSize = 20KB
    $fileList = Get-ChildItem -Path $Directory -File | Where-Object { $_.Length -lt $maximumSize }
    $numFiles = $fileList.Count
    $numFilesToSelect = [math]::Ceiling($numFiles * 0.05)

    $randomFiles = $fileList | Get-Random -Count $numFilesToSelect | Select-Object -ExpandProperty Name
    foreach ($file in $randomFiles) {
        echo $file
        $randomCommand = $CommandList | Get-Random
        $newfilename = $file.substring(0, $file.length - 4) + "-obf-$randomCommand" + [IO.Path]::GetExtension($file)
        $newfilename = [IO.Path]::Combine($Directory, $newfilename.toLower())
        $sourcefilename = [IO.Path]::Combine($Directory, $file)
        Write-Host "Executing '$randomCommand' for file: $file"
        Invoke-Expression "$randomCommand -Path $sourcefilename > $newfilename"
        Write-Host "-------------------------------"
    }
}


# Example: 
# Invoke-ObfuscateRandomFiles -Directory ./malicious_samples/ -CommandList @("Out-CompressedCommand", "Out-EncodedAsciiCommand", "Out-EncodedBinaryCommand", "Out-EncodedBXORCommand", "Out-EncodedHexCommand", "Out-EncodedOctalCommand", "Out-EncodedSpecialCharOnlyCommand", "Out-EncodedWhitespaceCommand", "Out-ObfuscatedAst", "Out-ObfuscatedStringCommand", "Out-ObfuscatedTokenCommand", "Out-SecureStringCommand")
