function Invoke-Pumper ($file, $added_mbs, $output) {

    $insides = [System.IO.File]::ReadAllBytes($file)
    $added_mb = 1024 * 1024 * $added_mbs

    $outputStream = [System.IO.File]::OpenWrite($output)
    $outputStream.Write($insides, 0, $insides.Length)
    $other_by = New-Object byte[] $added_mb
    $outputStream.Write($other_by, 0, $other_by.Length)
    $outputStream.Close()

    Write-Host "Done"
}