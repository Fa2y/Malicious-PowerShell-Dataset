Get-WmiObject Win32_SystemDriver | 
Where-Object { $_.ServiceType -eq "Kernel Driver" -and -not [System.String]::IsNullOrEmpty($_.PathName) } | 
ForEach-Object { [PSCustomObject] @{ Name=$_.Name; Path=$_.PathName } } |
Where-Object { Test-Path $_.Path } |
ForEach-Object { 
    $ErrorActionPreference = "SilentlyContinue"
    $c1 = [X509Certificate]::CreateFromCertFile($_.Path) 
    $ErrorActionPreference = "Continue"
    if ($c1)
    {
        $c2 = New-Object X509Certificate($c1.Handle)
    }
    Add-Member -InputObject $_ -MemberType NoteProperty -Name "CertIssuer" -Value $(if ($c2) { $c2.Issuer } else { "" })
    Add-Member -InputObject $_ -MemberType NoteProperty -Name "CertSubject" -Value $(if ($c2) { $c2.Subject } else { ""})
    $finfo = ([System.IO.FileInfo]$_.Path)
    if ($finfo)
    {
        Add-Member -InputObject $_ -NotePropertyMembers @{ 
            "Description"=$finfo.VersionInfo.FileDescription 
            "Version"=$finfo.VersionInfo.FileVersion
            "ProductVersion"=$finfo.VersionInfo.ProductVersion
            "Product"=$finfo.VersionInfo.ProductName
            "Created"=$finfo.CreationTimeUtc
        }
    }
    $_
}
