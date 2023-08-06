param(
    [string]
    $Vhosts = 'vhosts.txt'
)

$VhostsData = [string[]](Get-Content $Vhosts)
$VhostsData = $VhostsData | Get-Unique

# Protocol and IP to connect to, e.g. 8.8.8.8
$Uri = ''
# Primary domain, e.g. .example.com
$Domain = ''
# The first one to test is working, compare size of reply for other domains
$VhostsData = @('www',$VhostsData)

$OrigHeaders = @'
Host:
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:72.0) Gecko/20100101 Firefox/72.0
Accept: */*
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate, br
Origin: https://www.gp.se
Connection: keep-alive
Referer: https://www.gp.se/
'@  -split "`r" -replace "`n"
$HeadHash = [ordered]@{}
foreach ($HeadRow in $OrigHeaders)
{
    $key,$value = $HeadRow -split ':'
    if ($key -ne "Connection") 
    {
        $HeadHash[$key] = $value.Trim()
    }
}

$results = @()
$OrigContentLength = 0
foreach ($CurrentVhost in $VhostsData) {
    $HeadHash['Host'] = ($CurrentVhost + $Domain) -replace '..','.'
    Write-Host "Trying $($HeadHash['Host']) on $($Uri).."
    $r = Invoke-WebRequest -Uri $Uri -Headers $HeadHash -Method "GET"
    $r | Add-Member -NotePropertyName "Host" -NotePropertyValue $CurrentVhost
    $results += $r
    if ($OrigContentLength -eq 0)
    {
        $OrigContentLength = $r.RawContentLength
    } else {
        if ($r.RawContentLength -ne $OrigContentLength)
        {
            Write-Host "Found something of different length on host $CurrentVhost$Domain"
        }
    }
}
