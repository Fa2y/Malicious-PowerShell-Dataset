## Copyright (c) Microsoft Corporation.
## Licensed under the MIT license.

#=======================================Script parameters =====================================

param
(
    # DebugLevel parameter is deprecated
    # SQL LogScout will generate *_DEBUG.LOG with verbose level 5 logging for all executions
    # to enable debug messages in console, modify $global:DEBUG_LEVEL in LoggingFacility.ps1
    [Parameter(Position=0,HelpMessage='Choose 0|1|2|3|4|5')]
    [int32] $DebugLevel = 0,

    [Parameter(Position=1,HelpMessage='Choose a plus-sign separated list of one or more of: Basic,GeneralPerf,DetailedPerf,Replication,AlwaysOn,Memory,DumpMemory,WPR,Setup. Or MenuChoice')]
    [string[]] $Scenario=[String]::Empty,

    #servername\instnacename is an optional parameter since there is code that auto-discovers instances
    [Parameter(Position=2)]
    [string] $ServerName = [String]::Empty,

    [Parameter(Position=3,HelpMessage='Specify a valid path for your output folder, or type "UsePresentDir"')]
    [string] $CustomOutputPath = "PromptForCustomDir",

    #scenario is an optional parameter since there is a menu that covers for it if not present
    [Parameter(Position=4,HelpMessage='Choose DeleteDefaultFolder|NewCustomFolder')]
    [string] $DeleteExistingOrCreateNew = [String]::Empty,

    #specify start time for diagnostic
    [Parameter(Position=5,HelpMessage='Format is: "2020-10-27 19:26:00"')]
    [string] $DiagStartTime = "0000",
    
    #specify end time for diagnostic
    [Parameter(Position=6,HelpMessage='Format is: "2020-10-27 19:26:00"')]
    [string] $DiagStopTime = "0000",

    #specify quiet mode for any Y/N prompts
    [Parameter(Position=7,HelpMessage='Choose Quiet|Noisy')]
    [string] $InteractivePrompts = "Noisy"

    
)


#=======================================Globals =====================================
[console]::TreatControlCAsInput = $true
[string]$global:present_directory = ""
[string]$global:output_folder = ""
[string]$global:internal_output_folder = ""
[string]$global:custom_user_directory = ""  # This is for log folder selected by user other that default
[string]$global:userLogfolderselected = ""
[string]$global:perfmon_active_counter_file = "LogmanConfig.txt"
[bool]$global:perfmon_counters_restored = $false
[string]$NO_INSTANCE_NAME = "no_instance_found"
[string]$global:sql_instance_conn_str = $NO_INSTANCE_NAME #setting the connection sting to $NO_INSTANCE_NAME initially
[System.Collections.ArrayList]$global:processes = New-Object -TypeName System.Collections.ArrayList
[System.Collections.ArrayList] $global:ScenarioChoice = @()
[bool] $global:stop_automatically = $false
[string] $global:xevent_target_file = "xevent_LogScout_target"
[string] $global:xevent_session = "xevent_SQLLogScout"
[string] $global:xevent_alwayson_session = "SQLLogScout_AlwaysOn_Data_Movement"
[bool] $global:xevent_on = $false
[bool] $global:perfmon_is_on = $false
[bool] $global:perfmon_scenario_enabled = $false
[bool] $global:sqlvsswriter_has_run = $false
[string] $global:app_version = ""
[string] $global:host_name = hostname
[string] $global:wpr_collector_name = ""
[bool] $global:instance_independent_collection = $false
[int] $global:scenario_bitvalue  = 0
[int] $global:sql_major_version = -1


#constants
[string] $BASIC_NAME = "Basic"
[string] $GENERALPERF_NAME = "GeneralPerf"
[string] $DETAILEDPERF_NAME = "DetailedPerf"
[string] $REPLICATION_NAME = "Replication"
[string] $ALWAYSON_NAME = "AlwaysOn"
[string] $NETWORKTRACE_NAME = "NetworkTrace"
[string] $MEMORY_NAME = "Memory"
[string] $DUMPMEMORY_NAME = "DumpMemory"
[string] $WPR_NAME = "WPR"
[string] $SETUP_NAME = "Setup"
[string] $BACKUPRESTORE_NAME = "BackupRestore"
[string] $IO_NAME = "IO"
[string] $LIGHTPERF_NAME = "LightPerf"
[string[]] $global:ScenarioArray = @($BASIC_NAME,$GENERALPERF_NAME,$DETAILEDPERF_NAME,$REPLICATION_NAME,$ALWAYSON_NAME,$NETWORKTRACE_NAME,$MEMORY_NAME,$DUMPMEMORY_NAME,$WPR_NAME,$SETUP_NAME,$BACKUPRESTORE_NAME,$IO_NAME,$LIGHTPERF_NAME)

[int] $BasicScenId = 0
[int] $GeneralPerfScenId = 1
[int] $DetailedPerfScenId = 2
[int] $ReplicationScenId = 3
[int] $AlwaysOnScenId = 4
[int] $NetworkTraceScenId = 5
[int] $MemoryScenId = 6
[int] $DumpMemoryScenId = 7
[int] $WprScenId = 8
[int] $SetupScenId = 9
[int] $BackupRestoreScenId = 10
[int] $IOScenId = 11
[int] $LightPerfScenId = 12


# 00000000000001 (1)   = Basic
# 00000000000010 (2)   = GeneralPerf
# 00000000000100 (4)   = DetailedPerf
# 00000000001000 (8)   = Replication
# 00000000010000 (16)  = alwayson
# 00000000100000 (32)  = networktrace
# 00000001000000 (64)  = memory
# 00000010000000 (128) = DumpMemory
# 00000100000000 (256) = WPR
# 00001000000000 (512) = Setup
# 00010000000000 (1024)= BackupRestore
# 00100000000000 (2048)= IO
# 01000000000000 (4096)= LightPerf
# 10000000000000 (8192)= futureBit


[int] $global:basicBit         = 1
[int] $global:generalperfBit   = 2 
[int] $global:detailedperfBit  = 4
[int] $global:replBit          = 8
[int] $global:alwaysonBit      = 16
[int] $global:networktraceBit  = 32
[int] $global:memoryBit        = 64
[int] $global:dumpMemoryBit    = 128
[int] $global:wprBit           = 256
[int] $global:setupBit         = 512
[int] $global:BackupRestoreBit = 1024
[int] $global:IOBit            = 2048
[int] $global:LightPerfBit     = 4096
[int] $global:futureScBit      = 8192


#=======================================Start of \OUTPUT and \ERROR directories and files Section

function Init-AppVersion()
{
    $major_version = "4"
    $minor_version = "1"
    $build = "11"
    $global:app_version = $major_version + "." + $minor_version + "." + $build
    Write-LogInformation "SQL LogScout version: $global:app_version"
}
function InitCriticalDirectories()
{
    #initialize this directories
    Set-PresentDirectory 
    Set-OutputPath
    Set-InternalPath

}


function Set-PresentDirectory()
{
	Write-LogDebug "inside" $MyInvocation.MyCommand -DebugLogLevel 2
    $global:present_directory = Convert-Path -Path "."
    
    Write-LogInformation "The Present folder for this collection is" $global:present_directory 
}

function Set-OutputPath()
{

	Write-LogDebug "inside" $MyInvocation.MyCommand -DebugLogLevel 2
    
        #default final directory to present directory (.)
        [string] $final_directory  = $global:present_directory

        # if "UsePresentDir" is passed as a param value, then create where SQL LogScout runs
        if ($CustomOutputPath -eq "UsePresentDir")
        {
            $final_directory  = $global:present_directory
        }
        #if a custom directory is passed as a parameter to the script. Parameter validation also runs Test-Path on $CustomOutputPath
        elseif (Test-Path -Path $CustomOutputPath)
        {
            $final_directory = $CustomOutputPath

        }
        elseif ($CustomOutputPath -eq "PromptForCustomDir")    
        {
            $userlogfolder = Read-Host "Would your like the logs to be collected on a non-default drive and directory?" -CustomLogMessage "Prompt CustomDir Console Input:"
            $HelpMessage = "Please enter a valid input (Y or N)"

            $ValidInput = "Y","N"
            $AllInput = @()
            $AllInput += , $ValidInput
            $AllInput += , $userlogfolder
            $AllInput += , $HelpMessage

            $YNselected = validateUserInput($AllInput)
            

            if ($YNselected -eq "Y")
            {
                [string] $customOutDir = [string]::Empty

                while([string]::IsNullOrWhiteSpace($customOutDir) -or !(Test-Path -Path $customOutDir))
                {

                    $customOutDir = Read-Host "Enter an output folder with no quotes (e.g. C:\MyTempFolder or C:\My Folder)" -CustomLogMessage "Get Custom Output Folder Console Input:"
                    if ($customOutDir -eq "" -or !(Test-Path -Path $customOutDir))
                    {
                        Write-Host "'" $customOutDir "' is not a valid path. Please, enter a valid drive and folder location" -ForegroundColor Yellow
                    }
                }

                $final_directory =  $customOutDir
            }


        }

        #the output folder is subfolder of current folder where the tool is running
        $global:output_folder =  ($final_directory + "\output\")

}

function Set-NewOutputPath 
{
    Write-LogDebug "inside" $MyInvocation.MyCommand -DebugLogLevel 2

    [string] $new_output_folder_name = "_" + @(Get-Date -Format ddMMyyhhmmss) + "\"
    $global:output_folder = $global:output_folder.Substring(0, ($global:output_folder.Length-1)) + $new_output_folder_name    
    
}

function Set-InternalPath()
{
	Write-LogDebug "inside" $MyInvocation.MyCommand -DebugLogLevel 2
    
    #the \internal folder is subfolder of \output
    $global:internal_output_folder =  ($global:output_folder  + "internal\")
    
}

function Create-PartialOutputFilename ([string]$server)
{
    Write-LogDebug "inside" $MyInvocation.MyCommand

    if ($global:output_folder -ne "")
    {
        $server_based_file_name = $server -replace "\\", "_"
        $output_file_name = $global:output_folder + $server_based_file_name + "_" + @(Get-Date -Format FileDateTime)
    }
    Write-LogDebug "The server_based_file_name: " $server_based_file_name -DebugLogLevel 3
    Write-LogDebug "The output_path_filename is: " $output_file_name -DebugLogLevel 2
    
    return $output_file_name
}

function Create-PartialErrorOutputFilename ([string]$server)
{
    Write-LogDebug "inside" $MyInvocation.MyCommand

	
	if (($server -eq "") -or ($null -eq $server)) 
	{
		$server = hostname 
	}
	
    $error_folder = $global:internal_output_folder 
    
    $server_based_file_name = $server -replace "\\", "_"
    $error_output_file_name = $error_folder + $server_based_file_name + "_" + @(Get-Date -Format FileDateTime)
    
    Write-LogDebug "The error_output_path_filename is: " $error_output_file_name -DebugLogLevel 2
    
    return $error_output_file_name
}

function Reuse-or-RecreateOutputFolder() {
    Write-LogDebug "inside" $MyInvocation.MyCommand

    Write-LogDebug "Output folder is: $global:output_folder" -DebugLogLevel 3
    Write-LogDebug "Error folder is: $global:internal_output_folder" -DebugLogLevel 3
    
    try {
    
        #delete entire \output folder and files/subfolders before you create a new one, if user chooses that
        if (Test-Path -Path $global:output_folder)  
        {
            if ([string]::IsNullOrWhiteSpace($DeleteExistingOrCreateNew) )
            {
                Write-LogInformation ""
        
                [string]$DeleteOrNew = ""
                Write-LogWarning "It appears that output folder '$global:output_folder' has been used before."
                Write-LogWarning "You can choose to:"
                Write-LogWarning " - Delete (D) the \output folder contents and recreate it"
                Write-LogWarning " - Create a new (N) folder using \Output_ddMMyyhhmmss format." 
                Write-LogWarning "   You can delete the new folder manually in the future"
    
                while (-not(($DeleteOrNew -eq "D") -or ($DeleteOrNew -eq "N"))) 
                {
                    $DeleteOrNew = Read-Host "Delete ('D') or create New ('N') >" -CustomLogMessage "Output folder Console input:"
                    
                    $DeleteOrNew = $DeleteOrNew.ToString().ToUpper()
                    if (-not(($DeleteOrNew -eq "D") -or ($DeleteOrNew -eq "N"))) {
                        Write-LogError ""
                        Write-LogError "Please chose [D] to DELETE the output folder $global:output_folder and all files inside of the folder."
                        Write-LogError "Please chose [N] to CREATE a new folder"
                        Write-LogError ""
                    }
                }

            }

            elseif ($DeleteExistingOrCreateNew -in "DeleteDefaultFolder","NewCustomFolder") 
            {
                Write-LogDebug "The DeleteExistingOrCreateNew parameter is $DeleteExistingOrCreateNew" -DebugLogLevel 2

                switch ($DeleteExistingOrCreateNew) 
                {
                    "DeleteDefaultFolder"   {$DeleteOrNew = "D"}
                    "NewCustomFolder"       {$DeleteOrNew = "N"}
                }
                
            }

        }#end of IF

        
        #Get-Childitem -Path $output_folder -Recurse | Remove-Item -Confirm -Force -Recurse  | Out-Null
        if ($DeleteOrNew -eq "D") 
        {
            #delete the existing \output folder
            Remove-Item -Path $global:output_folder -Force -Recurse  | Out-Null
            Write-LogWarning "Deleted $global:output_folder and its contents"
        }
        elseif ($DeleteOrNew -eq "N") 
        {

            #these two calls updates the two globals for the new output and internal folders using the \Output_ddMMyyhhmmss format.
            
            # [string] $new_output_folder_name = "_" + @(Get-Date -Format ddMMyyhhmmss) + "\"
            # $global:output_folder = $global:output_folder.Substring(0, ($global:output_folder.Length-1)) + $new_output_folder_name

            Set-NewOutputPath
            Write-LogDebug "The new output path is: $global:output_folder" -DebugLogLevel 3
        
            #call Set-InternalPath to reset the \Internal folder
            Set-InternalPath
            Write-LogDebug "The new error path is: $global:internal_output_folder" -DebugLogLevel 3
        }

        

	
        #create an output folder AND error directory in one shot (creating the child folder \internal will create the parent \output also). -Force will not overwrite it, it will reuse the folder
        New-Item -Path $global:internal_output_folder -ItemType Directory -Force | out-null 
        
        Write-LogInformation "Output path: $global:output_folder"  #DO NOT CHANGE - Message is backward compatible
        Write-LogInformation "Error  path is" $global:internal_output_folder 
    }
    catch {
        $function_name = $MyInvocation.MyCommand
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "$function_name Function failed with error:  $error_msg"
        return $false
    }
}

function Build-FinalOutputFile([string]$output_file_name, [string]$collector_name, [bool]$needExtraQuotes, [string]$fileExt = ".out")
{
	Write-LogDebug "inside" $MyInvocation.MyCommand -DebugLogLevel 2
	
	$final_output_file = $output_file_name +"_" + $collector_name + $fileExt
	
	if ($needExtraQuotes)
	{
		$final_output_file = "`"" + $final_output_file + "`""
	}
	
	return $final_output_file
}

function Build-InputScript([string]$present_directory, [string]$collector_name)
{
	Write-LogDebug "inside" $MyInvocation.MyCommand -DebugLogLevel 2
	$input_script = "`"" + $present_directory+"\"+$collector_name +".sql" + "`""
	return $input_script
}

function Build-FinalErrorFile([string]$partial_error_output_file_name, [string]$collector_name, [bool]$needExtraQuotes)
{
	Write-LogDebug "inside" $MyInvocation.MyCommand -DebugLogLevel 2
	
	$error_file = $partial_error_output_file_name + "_"+ $collector_name + "_errors.out"
	
	if ($needExtraQuotes)
	{
		$error_file = "`"" + $error_file + "`""
	}
	
	
	return $error_file
}


#=======================================End of \OUTPUT and \ERROR directories and files Section

#======================================== START of Process management  SECTION



function StartNewProcess()
{
    param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [String] $FilePath,

        [Parameter(Mandatory=$false, Position=1)]
        [String] $ArgumentList = [String]::Empty,

        [Parameter(Mandatory=$false, Position=2)]
        [System.Diagnostics.ProcessWindowStyle] $WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Minimized,
    
        [Parameter(Mandatory=$false, Position=3)]
        [String] $RedirectStandardError = [String]::Empty,    
    
        [Parameter(Mandatory=$false, Position=4)]
        [String] $RedirectStandardOutput = [String]::Empty,

        [Parameter(Mandatory=$false, Position=5)]
        [bool] $Wait = $false
    )

    Write-LogDebug "inside" $MyInvocation.MyCommand

    [console]::TreatControlCAsInput = $true

    try 
    {
        #build a hash table of parameters
            
        $StartProcessParams = @{            
            FilePath= $FilePath
        }    

        if ($ArgumentList -ne [String]::Empty)
        {
            [void]$StartProcessParams.Add("ArgumentList", $ArgumentList)     
        }

        if ($null -ne $WindowStyle)
        {
            [void]$StartProcessParams.Add("WindowStyle", $WindowStyle)     
        }

        if ($RedirectStandardOutput -ne [String]::Empty)
        {
            [void]$StartProcessParams.Add("RedirectStandardOutput", $RedirectStandardOutput)     
        }

        if ($RedirectStandardError -ne [String]::Empty)
        {
            [void]$StartProcessParams.Add("RedirectStandardError", $RedirectStandardError)     
        }

        # we will always use -PassThru because we want to keep track of processes launched
        [void]$StartProcessParams.Add("PassThru", $null)     

        if ($true -eq $Wait)
        {
            [void]$StartProcessParams.Add("Wait", $null)
        }
        #print the command executed
        Write-LogDebug $FilePath $ArgumentList

        # start the process
        #equivalent to $p = Start-Process -FilePath $FilePath -ArgumentList $ArgumentList -WindowStyle $WindowStyle -RedirectStandardOutput $RedirectStandardOutput -RedirectStandardError $RedirectStandardError -PassThru -Wait
        $p = Start-Process @StartProcessParams

        #touch a few properties to make sure the process object is populated with them - specifically name and start time
        $pn = $p.ProcessName
        $sh = $p.SafeHandle
        $st = $p.StartTime

        # add the process object to the array of started processes (if it has not exited already)
        if($false -eq $p.HasExited)   
        {
            [void]$global:processes.Add($p)
        }

    }
    catch 
    {
        $mycommand = $MyInvocation.MyCommand
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand failed with error:  $error_msg"
        return
    }
    

}

#======================================== START of Process management  LOG SECTION


#======================================== START of Console LOG SECTION
. ./LoggingFacility.ps1
#======================================== END of Console LOG SECTION

#======================================== START of File Attribute Validation SECTION
. ./Confirm-FileAttributes.ps1
#======================================== END of File Attribute Validation SECTION

#======================================== Start OF Diagnostics Collection SECTION

function Replicate ([string] $char, [int] $cnt)
{
    $finalstring = $char * $cnt;
    return $finalstring;
}


function PadString (  [string] $arg1,  [int] $arg2 )
{
     $spaces = Replicate " " 256
     $retstring = "";
    if (!$arg1 )
    {
        $retstring = $spaces.Substring(0, $arg2);
     }
    elseif ($arg1.Length -eq  $arg2)
    {
        $retstring= $arg1;
       }
    elseif ($arg1.Length -gt  $arg2)
    {
        $retstring = $arg1.Substring(0, $arg2); 
        
    }
    elseif ($arg1.Length -lt $arg2)
    {
        $retstring = $arg1 + $spaces.Substring(0, ($arg2-$arg1.Length));
    }
    return $retstring;
}

function GetWindowsHotfixes () 
{
    Write-LogDebug "inside" $MyInvocation.MyCommand

    [console]::TreatControlCAsInput = $true

    $collector_name = "WindowsHotfixes"
    $server = $global:sql_instance_conn_str

    Write-LogInformation "Executing Collector: $collector_name"

    try {    
        ##create output filenames using the path + servername + date and time
        $partial_output_file_name = Create-PartialOutputFilename ($server)
        $output_file = Build-FinalOutputFile -output_file_name $partial_output_file_name -collector_name $collector_name -needExtraQuotes $false
    
        Write-LogDebug "The partial_output_file_name is $partial_output_file_name" -DebugLogLevel 3
        Write-LogDebug "The output_file is $output_file" -DebugLogLevel 3

        #collect Windows hotfixes on the system
        $hotfixes = Get-WmiObject -Class "win32_quickfixengineering"

        #in case CTRL+C is pressed
        HandleCtrlC

        [System.Text.StringBuilder]$rs_runningdrives = New-Object -TypeName System.Text.StringBuilder

        #Running drivers header
        [void]$rs_runningdrives.Append("-- Windows Hotfix List --`r`n")
        [void]$rs_runningdrives.Append("HotfixID       InstalledOn    Description                   InstalledBy  `r`n")
        [void]$rs_runningdrives.Append("-------------- -------------- ----------------------------- -----------------------------`r`n") 

        [int]$counter = 1
        foreach ($hf in $hotfixes) {
            $hotfixid = $hf["HotfixID"] + "";
            $installedOn = $hf["InstalledOn"] + "";
            $Description = $hf["Description"] + "";
            $InstalledBy = $hf["InstalledBy"] + "";
            $output = PadString  $hotfixid 15
            $output += PadString $installedOn  15;
            $output += PadString $Description 30;
            $output += PadString $InstalledBy  30;
            [void]$rs_runningdrives.Append("$output`r`n") 

            #in case CTRL+C is pressed
            HandleCtrlC
        }
        Add-Content -Path ($output_file) -Value ($rs_runningdrives.ToString())
    }
    catch {
        $function_name = $MyInvocation.MyCommand
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "$function_name Function failed with error:  $error_msg"
        return
    }
}



function GetEventLogs($server) 
{
    Write-LogDebug "inside" $MyInvocation.MyCommand

    [console]::TreatControlCAsInput = $true
    
    $collector_name = $MyInvocation.MyCommand
    Write-LogInformation "Executing Collector:" $collector_name

    $server = $global:sql_instance_conn_str

    try {
        ##create error output filenames using the path + servername + date and time
        $partial_output_file_name = Create-PartialOutputFilename ($server)

        $partial_error_output_file_name = Create-PartialErrorOutputFilename($server)
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $false
    
        Write-LogDebug "The partial_output_file_name is $partial_output_file_name" -DebugLogLevel 3
    
        #in case CTRL+C is pressed
        HandleCtrlC

        $sbWriteLogBegin = {

            [System.Text.StringBuilder]$TXTEvtOutput = New-Object -TypeName System.Text.StringBuilder
            [System.Text.StringBuilder]$CSVEvtOutput = New-Object -TypeName System.Text.StringBuilder

            # TXT header
            [void]$TXTEvtOutput.Append("Date Time".PadRight(25))
            [void]$TXTEvtOutput.Append("Type/Level".PadRight(16))
            [void]$TXTEvtOutput.Append("Computer Name".PadRight(17))
            [void]$TXTEvtOutput.Append("EventID".PadRight(8))
            [void]$TXTEvtOutput.Append("Source".PadRight(51))
            [void]$TXTEvtOutput.Append("Task Category".PadRight(20))
            [void]$TXTEvtOutput.Append("Username".PadRight(51))
            [void]$TXTEvtOutput.AppendLine("Message")
            [void]$TXTEvtOutput.AppendLine("-" * 230)

            # CSV header
            [void]$CSVEvtOutput.AppendLine("`"EntryType`",`"TimeGenerated`",`"Source`",`"EventID`",`"Category`",`"Message`"")
        }

        $sbWriteLogProcess = {
            
            [string]$TimeGenerated = $_.TimeGenerated.ToString("MM/dd/yyyy hh:mm:ss tt")
            [string]$EntryType = $_.EntryType.ToString()
            [string]$MachineName = $_.MachineName.ToString()
            [string]$EventID = $_.EventID.ToString()
            [string]$Source = $_.Source.ToString()
            [string]$Category = $_.Category.ToString()
            [string]$UserName = $_.UserName
            [string]$Message = ((($_.Message.ToString() -replace "`r") -replace "`n", " ") -replace "`t", " ")

            # during testing some usernames are blank so we handle just like Windows Event Viewer displaying "N/A"
            if ($null -eq $UserName) {$UserName = "N/A"}

            # during testing some categories are "(0)" and Windows Event Viewer displays "None", so we just mimic same behavior
            if ("(0)" -eq $Category) {$Category = "None"}

            # TXT event record
            [void]$TXTEvtOutput.Append($TimeGenerated.PadRight(25))
            [void]$TXTEvtOutput.Append($EntryType.PadRight(16))
            [void]$TXTEvtOutput.Append($MachineName.PadRight(17))
            [void]$TXTEvtOutput.Append($EventID.PadRight(8))
            [void]$TXTEvtOutput.Append($Source.PadRight(50).Substring(0, 50).PadRight(51))
            [void]$TXTEvtOutput.Append($Category.PadRight(20))            
            [void]$TXTEvtOutput.Append($UserName.PadRight(50).Substring(0, 50).PadRight(51))
            [void]$TXTEvtOutput.AppendLine($Message)

            # CSV event record
            [void]$CSVEvtOutput.Append('"' + $EntryType + '",')
            [void]$CSVEvtOutput.Append('"' + $TimeGenerated + '",')
            [void]$CSVEvtOutput.Append('"' + $Source + '",')
            [void]$CSVEvtOutput.Append('"' + $EventID + '",')
            [void]$CSVEvtOutput.Append('"' + $Category + '",')
            [void]$CSVEvtOutput.AppendLine('"' + $Message + '"')

            $evtCount++

            # write to the files every 10000 events
            if (($evtCount % 10000) -eq 0) {
                
                $TXTevtfile.Write($TXTEvtOutput.ToString())
                $TXTevtfile.Flush()
                [void]$TXTEvtOutput.Clear()

                $CSVevtfile.Write($CSVEvtOutput.ToString())
                $CSVevtfile.Flush()
                [void]$CSVEvtOutput.Clear()

                Write-LogInformation "   Produced $evtCount records in the EventLog"

                #in case CTRL+C is pressed
                HandleCtrlC

            }

        }
        
        $sbWriteLogEnd = {
            # at end of process we write any remaining messages, flush and close the file    
            if ($TXTEvtOutput.Length -gt 0){
                $TXTevtfile.Write($TXTEvtOutput.ToString())
            }
            $TXTevtfile.Flush()
            $TXTevtfile.Close()

            if ($CSVEvtOutput.Length -gt 0){
                $CSVevtfile.Write($CSVEvtOutput.ToString())
            }
            $CSVevtfile.Flush()
            $CSVevtfile.Close()
            
            Remove-Variable -Name "TXTEvtOutput"
            Remove-Variable -Name "CSVEvtOutput"

            Write-LogInformation "   Produced $evtCount records in the EventLog"
        }

        Write-LogInformation "Gathering Application EventLog in TXT and CSV format  "
        
        $TXTevtfile = New-Object -TypeName System.IO.StreamWriter -ArgumentList (($partial_output_file_name + "_EventLog_Application.out"), $false, [System.Text.Encoding]::ASCII)
        $CSVevtfile = New-Object -TypeName System.IO.StreamWriter -ArgumentList (($partial_output_file_name + "_EventLog_Application.csv"), $false, [System.Text.Encoding]::ASCII)

        [int]$evtCount = 0

        Get-EventLog -LogName Application -After (Get-Date).AddDays(-90) | ForEach-Object -Begin $sbWriteLogBegin -Process $sbWriteLogProcess -End $sbWriteLogEnd 2>> $error_file | Out-Null
        
        Write-LogInformation "Application EventLog in TXT and CSV format completed!"

        #in case CTRL+C is pressed
        HandleCtrlC
        
        Write-LogInformation "Gathering System EventLog in TXT and CSV format  "

        $TXTevtfile = New-Object -TypeName System.IO.StreamWriter -ArgumentList (($partial_output_file_name + "_EventLog_System.out"), $false, [System.Text.Encoding]::ASCII)
        $CSVevtfile = New-Object -TypeName System.IO.StreamWriter -ArgumentList (($partial_output_file_name + "_EventLog_System.csv"), $false, [System.Text.Encoding]::ASCII)

        [int]$evtCount = 0

        Get-EventLog -LogName System -After (Get-Date).AddDays(-90) | ForEach-Object -Begin $sbWriteLogBegin -Process $sbWriteLogProcess -End $sbWriteLogEnd 2>> $error_file | Out-Null
        
        Write-LogInformation "System EventLog in TXT and CSV format completed!"

    }
    catch {
        $mycommand = $MyInvocation.MyCommand 
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand failed with error:  $error_msg"
        return
    }

}

function GetPowerPlan($server) 
{
    #power plan
    Write-LogDebug "inside" $MyInvocation.MyCommand

    [console]::TreatControlCAsInput = $true

    $server = $global:sql_instance_conn_str

    try {
        ##create error output filenames using the path + servername + date and time
        $partial_output_file_name = Create-PartialOutputFilename ($server)
    
        Write-LogDebug "The partial_output_file_name is $partial_output_file_name" -DebugLogLevel 3
        $collector_name = "PowerPlan"
        Write-LogInformation "Executing Collector: $collector_name"
        $output_file = Build-FinalOutputFile -output_file_name $partial_output_file_name -collector_name $collector_name -needExtraQuotes $false
        $power_plan_name = Get-WmiObject -Class win32_powerplan -Namespace root\cimv2\power | Where-Object IsActive -eq $true | Select-Object ElementName #|Out-File -FilePath $output_file
        Set-Content -Value $power_plan_name.ElementName -Path $output_file
        HandleCtrlC
    }
    catch {
        $mycommand = $MyInvocation.MyCommand
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand failed with error:  $error_msg"
        return
    }

}

function Update-Coma([string]$in){
    if([string]::IsNullOrWhiteSpace($in)){
        return ""
    }else{
        return $in.Replace(",",".")
    }
}

function GetRunningDrivers() 
{
    <#
    .SYNOPSIS
        Get a list of running drivers in the system.
    .DESCRIPTION
        Writes a list of running drivers in the system in both TXT and CSV format.
    .PARAMETER FileName
        Specifies the file name to be written to. Extension TXT and CSV will be automatically added.
    .EXAMPLE
        .\Get-RunningDrivers"
#>


    Write-LogDebug "Inside" $MyInvocation.MyCommand

    $server = $global:sql_instance_conn_str

    [console]::TreatControlCAsInput = $true

    try 
    {
        
        $partial_output_file_name = Create-PartialOutputFilename ($server)

        Write-LogDebug "The partial_output_file_name is $partial_output_file_name" -DebugLogLevel 3

    
        $collector_name = "RunningDrivers"
        $output_file_csv = ($partial_output_file_name + "_RunningDrivers.csv")
        $output_file_txt = ($partial_output_file_name + "_RunningDrivers.txt")
        Write-LogInformation "Executing Collector: $collector_name"
    
        Write-LogDebug $output_file_csv
        Write-LogDebug $output_file_txt
    
        #gather running drivers
        $driverproperties = Get-WmiObject Win32_SystemDriver | `
            where-object { $_.State -eq "Running" } | `
            Select-Object -Property PathName | `
            ForEach-Object { $_.Pathname.Replace("\??\", "") } | `
            Get-ItemProperty | `
            Select-Object -Property Length, LastWriteTime -ExpandProperty "VersionInfo" | `
            Sort-Object CompanyName, FileDescription

        [System.Text.StringBuilder]$TXToutput = New-Object -TypeName System.Text.StringBuilder
        [System.Text.StringBuilder]$CSVoutput = New-Object -TypeName System.Text.StringBuilder

        #CSV header
        [void]$CSVoutput.Append("ID,Module Path,Product Version,File Version,Company Name,File Description,File Size,File Time/Date String,`r`n")

        [int]$counter = 1

        foreach ($driver in $driverproperties) {
            [void]$TXToutput.Append("Module[" + $counter + "] [" + $driver.FileName + "]`r`n")
            [void]$TXToutput.Append("  Company Name:      " + $driver.CompanyName + "`r`n")
            [void]$TXToutput.Append("  File Description:  " + $driver.FileDescription + "`r`n")
            [void]$TXToutput.Append("  Product Version:   (" + $driver.ProductVersion + ")`r`n")
            [void]$TXToutput.Append("  File Version:      (" + $driver.FileVersion + ")`r`n")
            [void]$TXToutput.Append("  File Size (bytes): " + $driver.Length + "`r`n")
            [void]$TXToutput.Append("  File Date:         " + $driver.LastWriteTime + "`r`n")
            [void]$TXToutput.Append("`r`n`r`n")

            [void]$CSVoutput.Append($counter.ToString() + ",")
            [void]$CSVoutput.Append((Update-Coma($driver.FileName)) + ",")
            [void]$CSVoutput.Append((Update-Coma($driver.ProductVersion)) + ",")
            [void]$CSVoutput.Append((Update-Coma($driver.FileVersion)) + ",")
            [void]$CSVoutput.Append((Update-Coma($driver.CompanyName)) + ",")
            [void]$CSVoutput.Append((Update-Coma($driver.FileDescription)) + ",")
            [void]$CSVoutput.Append($driver.Length.ToString() + ",")
            [void]$CSVoutput.Append($driver.LastWriteTime.ToString() + ",")
            [void]$CSVoutput.Append("`r`n")
        
            #in case CTRL+C is pressed
            HandleCtrlC

            $counter++
        }

        Add-Content -Path ($output_file_txt) -Value ($TXToutput.ToString())
        Add-Content -Path ($output_file_csv) -Value ($CSVoutput.ToString())
    }
    catch {
        $mycommand = $MyInvocation.MyCommand
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand Function failed with error:  $error_msg"
        return     
    }
}

function GetSQLSetupLogs(){
    
    Write-LogDebug "Inside" $MyInvocation.MyCommand

    [console]::TreatControlCAsInput = $true

    $collector_name = "SQLSetupLogs"
    Write-LogInformation "Executing Collector: $collector_name"

    try{
        Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\*\Bootstrap\' |
        ForEach-Object {

            [string]$SQLVersion = Split-Path -Path $_.BootstrapDir | Split-Path -Leaf
            [string]$DestinationFolder = $global:output_folder + $env:COMPUTERNAME + "_SQL" + $SQLVersion + "_Setup_Bootstrap"
        
            Write-LogDebug "_.BootstrapDir: $_.BootstrapDir" -DebugLogLevel 2
            Write-LogDebug "DestinationFolder: $DestinationFolder" -DebugLogLevel 2
        
            [string]$BootstrapLogFolder = $_.BootstrapDir + "Log\"

            if(Test-Path -Path $BootstrapLogFolder){

                Write-LogDebug "Executing: Copy-Item -Path ($BootstrapLogFolder) -Destination $DestinationFolder -Recurse"
                try{
                    Copy-Item -Path ($BootstrapLogFolder) -Destination $DestinationFolder -Recurse -ErrorAction Stop
                } catch {
                    Write-LogError "Error executing Copy-Item"
                    Write-LogError $_
                }

            } else {

                Write-LogWarning "Skipped copying SQL Setup logs from $BootstrapLogFolder"
                Write-LogWarning "Reason: Path is not valid."

            }
            
            #in case CTRL+C is pressed
            HandleCtrlC
        }
    } catch {
        Write-LogError "Error Collecting SQL Server Setup Log Files"
        Write-LogError $_
    }

}
    
function MSDiagProcsCollector() 
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand

    [console]::TreatControlCAsInput = $true

    $server = $global:sql_instance_conn_str


    ##create error output filenames using the path + servername + date and time
    $partial_error_output_file_name = Create-PartialErrorOutputFilename($server)

    Write-LogDebug "The partial_error_output_file_name is $partial_error_output_file_name" -DebugLogLevel 3

    #in case CTRL+C is pressed
    HandleCtrlC

    try {

        #msdiagprocs.sql
        #the output is potential errors so sent to error file
        $collector_name = "MSDiagProcs"
        $input_script = Build-InputScript $global:present_directory $collector_name
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $true
        $executable = "sqlcmd.exe"
        $argument_list = "-S" + $server + " -E -Hsqllogscout -w8000 -o" + $error_file + " -i" + $input_script
        Write-LogInformation "Executing Collector: $collector_name"
        StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden
    }
    
    catch {
        $mycommand = $MyInvocation.MyCommand
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand failed with error:  $error_msg"
        return
    }
    
}

function GetXeventsGeneralPerf() 
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand

    $server = $global:sql_instance_conn_str

    [console]::TreatControlCAsInput = $true

    try {
        
        ##create error output filenames using the path + servername + date and time
        $partial_output_file_name = Create-PartialOutputFilename ($server)
        $partial_error_output_file_name = Create-PartialErrorOutputFilename($server)
    
        Write-LogDebug "The partial_output_file_name is $partial_output_file_name" -DebugLogLevel 3
        Write-LogDebug "The partial_error_output_file_name is $partial_error_output_file_name" -DebugLogLevel 3

        #XEvents file: xevent_general.sql - GENERAL Perf
        

        $collector_name = "xevent_general"
        $xevent_core_script = Build-InputScript $global:present_directory "xevent_core"
        $xevent_general_script = Build-InputScript $global:present_directory $collector_name
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $true
        $executable = "sqlcmd.exe"
        $inputScriptCombined = [String]::Empty

        if ($true -eq $global:xevent_on)
        {
            $inputScriptCombined = $xevent_general_script
        }
        else 
        {
            $inputScriptCombined = $xevent_core_script + "," + $xevent_general_script
        }
        
        $argument_list = "-S" + $server + " -E -Hsqllogscout -w8000 -o" + $error_file + " -i" + $inputScriptCombined
        Write-LogInformation "Executing Collector: $collector_name"
        StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden
        
        Start-Sleep -Seconds 2

        #in case CTRL+C is pressed
        HandleCtrlC

        if ($true -ne $global:xevent_on)
        {
            #add Xevent target
            $collector_name = "xevent_general_target"
            $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $true
            $alter_event_session_add_target = "IF HAS_PERMS_BY_NAME(NULL, NULL, 'ALTER ANY EVENT SESSION') = 1 BEGIN ALTER EVENT SESSION [$global:xevent_session] ON SERVER ADD TARGET package0.event_file(SET filename=N'" + $partial_output_file_name + "_" + $global:xevent_target_file + ".xel' " + ", max_file_size=(500), max_rollover_files=(50)); END" 
            $executable = "sqlcmd.exe"
            $argument_list = "-S" + $server + " -E -Hsqllogscout -w8000 -o" + $error_file + " -Q`"" + $alter_event_session_add_target + "`""
            Write-LogInformation "Executing Collector: $collector_name"
            StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden

            #in case CTRL+C is pressed
            HandleCtrlC

            #start the XEvent session
            $collector_name = "xevent_general_Start"
            $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $true
            $alter_event_session_start = "IF HAS_PERMS_BY_NAME(NULL, NULL, 'ALTER ANY EVENT SESSION') = 1 BEGIN ALTER EVENT SESSION [$global:xevent_session]  ON SERVER STATE = START; END"
            $executable = "sqlcmd.exe"
            $argument_list = "-S" + $server + " -E -Hsqllogscout -w8000 -o" + $error_file + " -Q`"" + $alter_event_session_start + "`""
            Write-LogInformation "Executing Collector: $collector_name"
            StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden
            
            # set the Xevent has been started flag to be true
            $global:xevent_on = $true
        }

    }
    catch {
        $mycommand = $MyInvocation.MyCommand 
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand failed with error:  $error_msg"
        return
    }
}

function GetXeventsDetailedPerf() 
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand

    $server = $global:sql_instance_conn_str

    [console]::TreatControlCAsInput = $true

    try 
    {
        ##create error output filenames using the path + servername + date and time
        $partial_output_file_name = Create-PartialOutputFilename ($server)
        $partial_error_output_file_name = Create-PartialErrorOutputFilename($server)
    
        Write-LogDebug "The partial_output_file_name is $partial_output_file_name" -DebugLogLevel 3
        Write-LogDebug "The partial_error_output_file_name is $partial_error_output_file_name" -DebugLogLevel 3

        #XEvents file: xevent_detailed.sql - Detailed Perf
       
        $collector_name = "xevent_detailed"
        $xevent_detail_script = Build-InputScript $global:present_directory $collector_name
        $xevent_core_script = Build-InputScript $global:present_directory "xevent_core"
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $true
        $executable = "sqlcmd.exe"
        $inputScriptCombined = [String]::Empty

        if ($true -eq $global:xevent_on)
        {
            $inputScriptCombined = $xevent_detail_script
        }
        else 
        {
            $inputScriptCombined = $xevent_core_script + "," + $xevent_detail_script
        }
        
        $argument_list = "-S" + $server + " -E -Hsqllogscout -w8000 -o" + $error_file + " -i" + $inputScriptCombined
        Write-LogInformation "Executing Collector: $collector_name"
        StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden
        
        Start-Sleep -Seconds 2

        #in case CTRL+C is pressed
        HandleCtrlC

        if ($true -ne $global:xevent_on)
        {
            #add Xevent target
            $collector_name = "xevent_detailed_target"
            $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $true
            $alter_event_session_add_target = "IF HAS_PERMS_BY_NAME(NULL, NULL, 'ALTER ANY EVENT SESSION') = 1 BEGIN ALTER EVENT SESSION [$global:xevent_session] ON SERVER ADD TARGET package0.event_file(SET filename=N'" + $partial_output_file_name + "_" + $global:xevent_target_file + ".xel'" + ", max_file_size=(500), max_rollover_files=(50)); END" 
            $executable = "sqlcmd.exe"
            $argument_list = "-S" + $server + " -E -Hsqllogscout -w8000 -o" + $error_file + " -Q`"" + $alter_event_session_add_target + "`""
            Write-LogInformation "Executing Collector: $collector_name"
            StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden
            
            #in case CTRL+C is pressed
            HandleCtrlC

            #start the XEvent session
            $collector_name = "xevent_detailed_Start"
            $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $true
            $alter_event_session_start = "IF HAS_PERMS_BY_NAME(NULL, NULL, 'ALTER ANY EVENT SESSION') = 1 BEGIN ALTER EVENT SESSION [$global:xevent_session]  ON SERVER STATE = START; END" 
            $executable = "sqlcmd.exe"
            $argument_list = "-S" + $server + " -E -Hsqllogscout -w8000 -o" + $error_file + " -Q`"" + $alter_event_session_start + "`""
            Write-LogInformation "Executing Collector: $collector_name"
            StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden
            
            # set the Xevent has been started flag to be true
            $global:xevent_on = $true
        }

    }
    catch {
        $mycommand = $MyInvocation.MyCommand
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand failed with error:  $error_msg"
        return
    }
}

function GetAlwaysOnDiag() 
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand

    $server = $global:sql_instance_conn_str

    [console]::TreatControlCAsInput = $true

    try {
        
        $partial_output_file_name = Create-PartialOutputFilename ($server)
        $partial_error_output_file_name = Create-PartialErrorOutputFilename($server)
    
        Write-LogDebug "The partial_error_output_file_name is $partial_error_output_file_name" -DebugLogLevel 3
        Write-LogDebug "The partial_output_file_name is $partial_output_file_name" -DebugLogLevel 3

        #in case CTRL+C is pressed
        HandleCtrlC

        #AlwaysOn Basic Info
        $collector_name = "AlwaysOnDiagScript"
        $input_script = Build-InputScript $global:present_directory $collector_name
        $output_file = Build-FinalOutputFile -output_file_name $partial_output_file_name -collector_name $collector_name -needExtraQuotes $true
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name  -needExtraQuotes $false
        $executable = "sqlcmd.exe"
        $argument_list = "-S" + $server + " -E -Hsqllogscout -w8000 -o" + $output_file + " -i" + $input_script
        Write-LogInformation "Executing Collector: $collector_name"
        
        StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden -RedirectStandardError $error_file
        
    }
    catch {
        $mycommand = $MyInvocation.MyCommand
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand failed with error:  $error_msg"
        return
    }

}

function GetXeventsAlwaysOnMovement() 
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand

    $server = $global:sql_instance_conn_str


    [console]::TreatControlCAsInput = $true

    try {
        
    
        ##create error output filenames using the path + servername + date and time
        $partial_output_file_name = Create-PartialOutputFilename ($server)
        $partial_error_output_file_name = Create-PartialErrorOutputFilename($server)
    
        Write-LogDebug "The partial_output_file_name is $partial_output_file_name" -DebugLogLevel 3
        Write-LogDebug "The partial_error_output_file_name is $partial_error_output_file_name" -DebugLogLevel 3

        #in case CTRL+C is pressed
        HandleCtrlC

        
        $collector_name = "xevent_AlwaysOn_Data_Movement"
        $xevent_AlwaysOnDataMovement_script = Build-InputScript $global:present_directory $collector_name
        $xevent_core_script = Build-InputScript $global:present_directory "xevent_core"
        #$input_script = Build-InputScript $global:present_directory $collector_name
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $true
        $executable = "sqlcmd.exe"
        $argument_list = "-S" + $server + " -E -Hsqllogscout -w8000 -o" + $error_file + " -i" + $xevent_core_script + "," + $xevent_AlwaysOnDataMovement_script
        Write-LogInformation "Executing Collector: $collector_name"
        
        StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden
        
        Start-Sleep -Seconds 2

        #in case CTRL+C is pressed
        HandleCtrlC

        #add Xevent target
        $collector_name = "AlwaysOn_Data_Movement_target"
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $true
        $alter_event_session_add_target = "IF HAS_PERMS_BY_NAME(NULL, NULL, 'ALTER ANY EVENT SESSION') = 1 BEGIN ALTER EVENT SESSION [$global:xevent_alwayson_session] ON SERVER ADD TARGET package0.event_file(SET filename=N'" + $partial_output_file_name + "_" + $collector_name + ".xel'" + ", max_file_size=(500), max_rollover_files=(50)); END" 
        $executable = "sqlcmd.exe"
        $argument_list = "-S" + $server + " -E -Hsqllogscout -w8000 -o" + $error_file + " -Q`"" + $alter_event_session_add_target + "`""
        Write-LogInformation "Executing Collector: $collector_name"
        
        StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden
        
        #in case CTRL+C is pressed
        HandleCtrlC

        #start the XEvent session
        $collector_name = "AlwaysOn_Data_Movement_Start"
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $true
        $alter_event_session_start = "IF HAS_PERMS_BY_NAME(NULL, NULL, 'ALTER ANY EVENT SESSION') = 1 BEGIN ALTER EVENT SESSION [$global:xevent_alwayson_session]  ON SERVER STATE = START; END" 
        $executable = "sqlcmd.exe"
        $argument_list = "-S" + $server + " -E -Hsqllogscout -w8000 -o" + $error_file + " -Q`"" + $alter_event_session_start + "`""
        Write-LogInformation "Executing Collector: $collector_name"
        
        StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden
        
    }
    catch {
        $mycommand = $MyInvocation.MyCommand
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand failed with error:  $error_msg"
        return
    }
}

function GetAlwaysOnHealthXel
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand
    [console]::TreatControlCAsInput = $true

    $collector_name = "AlwaysOnHealthXevent"
    Write-LogInformation "Executing Collector: $collector_name"

    try{
            $server = $global:sql_instance_conn_str

            $partial_error_output_file_name = Create-PartialErrorOutputFilename($server)
            Write-LogDebug "The partial_error_output_file_name is $partial_error_output_file_name" -DebugLogLevel 3
            $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $false


            if ($server -notlike '*\*')
            {
                $vInstance = "MSSQLSERVER"
            } 
            if ($server -like '*\*')
            {
                $selectInstanceName = $global:sql_instance_conn_str              
                $server = Strip-InstanceName($selectInstanceName) 
                $vInstance = $server
            }
            [string]$DestinationFolder = $global:output_folder 


            #in case CTRL+C is pressed
            HandleCtrlC
            
            $vRegInst = (Get-ItemProperty -Path HKLM:"SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL").$vInstance
            $vRegPath = "SOFTWARE\Microsoft\Microsoft SQL Server\" + $vRegInst + "\MSSQLServer\Parameters" 
            $vLogPath = (Get-ItemProperty -Path HKLM:$vRegPath).SQLArg1 -replace '-e'
            $vLogPath = $vLogPath -replace 'ERRORLOG'
            Get-ChildItem -Path $vLogPath -Filter AlwaysOn_health*.xel | Copy-Item -Destination $DestinationFolder 2>> $error_file | Out-Null

        } catch {
            Write-LogError $_
            $mycommand = $MyInvocation.MyCommand 
            $error_msg = $PSItem.Exception.Message 
            Write-LogError "Function $mycommand failed with error:  $error_msg"
        }

}


function GetXeventBackupRestore 
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand

    $server = $global:sql_instance_conn_str

    [console]::TreatControlCAsInput = $true

    try 
    {
        if ($global:sql_major_version -ge 13)
        {
            ##create error output filenames using the path + servername + date and time
            $partial_output_file_name = Create-PartialOutputFilename ($server)
            $partial_error_output_file_name = Create-PartialErrorOutputFilename($server)

            Write-LogDebug "The partial_output_file_name is $partial_output_file_name" -DebugLogLevel 3
            Write-LogDebug "The partial_error_output_file_name is $partial_error_output_file_name" -DebugLogLevel 3

            #XEvents file: xevent_backup_restore.sql - Backup Restore
       

            $collector_name  = "xevent_backup_restore"
            $xevent_core_script = Build-InputScript $global:present_directory "xevent_core"
            $xevent_backup_restore_script = Build-InputScript $global:present_directory $collector_name #"xevent_backup_restore"
            $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $true
            $executable = "sqlcmd.exe"
            $inputScriptCombined = [String]::Empty

            if ($true -eq $global:xevent_on)
            {
                $inputScriptCombined = $xevent_backup_restore_script
            }
            else 
            {
                $inputScriptCombined = $xevent_core_script + "," + $xevent_backup_restore_script
            }
            
            $argument_list = "-S" + $server + " -E -Hsqllogscout -w8000 -o" + $error_file + " -i" + $inputScriptCombined
            Write-LogInformation "Executing Collector: $collector_name"
            
            StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden
            

            Start-Sleep -Seconds 2

            #in case CTRL+C is pressed
            HandleCtrlC

            if ($true -ne $global:xevent_on)
            {
                


                
                #add Xevent target
                $collector_name = "xevent_backuprestore_target"
                $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $true
                $alter_event_session_add_target = "IF HAS_PERMS_BY_NAME(NULL, NULL, 'ALTER ANY EVENT SESSION') = 1 BEGIN ALTER EVENT SESSION [$global:xevent_session] ON SERVER ADD TARGET package0.event_file(SET filename=N'" + $partial_output_file_name + "_" + $global:xevent_target_file + ".xel' " + ", max_file_size=(500), max_rollover_files=(50)); END" 
                $executable = "sqlcmd.exe"
                $argument_list = "-S" + $server + " -E -Hsqllogscout -w8000 -o" + $error_file + " -Q`"" + $alter_event_session_add_target + "`""
                Write-LogInformation "Executing Collector: $collector_name"
                
                StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden
                
                
                #in case CTRL+C is pressed
                HandleCtrlC

                #start the XEvent session
                $collector_name = "xevent_backuprestore_start"
                $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $true
                $alter_event_session_start = "IF HAS_PERMS_BY_NAME(NULL, NULL, 'ALTER ANY EVENT SESSION') = 1 BEGIN ALTER EVENT SESSION [$global:xevent_session]  ON SERVER STATE = START; END"
                $executable = "sqlcmd.exe"
                $argument_list = "-S" + $server + " -E -Hsqllogscout -w8000 -o" + $error_file + " -Q`"" + $alter_event_session_start + "`""
                Write-LogInformation "Executing Collector: $collector_name"
                
                StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden
                
                # set the Xevent has been started flag to be true
                $global:xevent_on = $true

            }

        }
        else
        {
            Write-LogDebug "Backup_restore_progress_trace XEvent exists in SQL Server 2016 and higher and cannot be collected for instance $server. "
        }
        


    }
    catch {
        $mycommand = $MyInvocation.MyCommand 
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand failed with error:  $error_msg"
        return
    }
}

function GetBackupRestoreTraceFlags
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand

    $server = $global:sql_instance_conn_str

    [console]::TreatControlCAsInput = $true

    try {
        $partial_output_file_name = Create-PartialOutputFilename ($server)
        $partial_error_output_file_name = Create-PartialErrorOutputFilename($server)
    
        Write-LogDebug "The partial_error_output_file_name is $partial_error_output_file_name" -DebugLogLevel 3
        Write-LogDebug "The partial_output_file_name is $partial_output_file_name" -DebugLogLevel 3

        #SQL Server Slow SQL Server Backup and Restore
        $collector_name = "EnableTraceFlag"
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $true
        $trace_flag_enabled = "DBCC TRACEON(3004,3212,3605,-1)"
        $executable = "sqlcmd.exe"
        $argument_list = "-S" + $server + " -E -Hsqllogscout -w8000 -o" + $error_file + " -Q`"" + $trace_flag_enabled + "`""
        Write-LogInformation "Executing Collector: $collector_name"
        
        StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden
        
        
    }
    catch {
        $mycommand = $MyInvocation.MyCommand 
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand failed with error:  $error_msg"
        return     
    }
}

function GetVSSAdminLogs()
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand

    $server = $global:sql_instance_conn_str

    [console]::TreatControlCAsInput = $true


    try 
    {
        $partial_output_file_name = Create-PartialOutputFilename ($server)
        $partial_error_output_file_name = Create-PartialErrorOutputFilename($server)
    
        Write-LogDebug "The partial_error_output_file_name is $partial_error_output_file_name" -DebugLogLevel 3
        Write-LogDebug "The partial_output_file_name is $partial_output_file_name" -DebugLogLevel 3

        #in case CTRL+C is pressed
        HandleCtrlC

        #list VSS Admin providers
        $collector_name = "VSSAdmin_Providers"
        $output_file = Build-FinalOutputFile -output_file_name $partial_output_file_name -collector_name $collector_name -needExtraQuotes $false
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name  
        $argument_list = " list providers"
        $executable = "VSSAdmin.exe"
        Write-LogInformation "Executing Collector: $collector_name"
        
        StartNewProcess -FilePath $executable -ArgumentList $argument_list -RedirectStandardOutput $output_file -WindowStyle Hidden -RedirectStandardError $error_file
        

        $collector_name = "VSSAdmin_Shadows"
        $output_file = Build-FinalOutputFile -output_file_name $partial_output_file_name -collector_name $collector_name -needExtraQuotes $false
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name  
        $argument_list = " list shadows"
        $executable = "VSSAdmin.exe"
        Write-LogInformation "Executing Collector: $collector_name"
        
        StartNewProcess -FilePath $executable -ArgumentList $argument_list -RedirectStandardOutput $output_file -WindowStyle Hidden -RedirectStandardError $error_file
        

        Start-Sleep -Seconds 1

        $collector_name = "VSSAdmin_Shadowstorage"
        $output_file = Build-FinalOutputFile -output_file_name $partial_output_file_name -collector_name $collector_name -needExtraQuotes $false
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name  
        $argument_list = " list shadowstorage"
        $executable = "VSSAdmin.exe"
        Write-LogInformation "Executing Collector: $collector_name"
        
        StartNewProcess -FilePath $executable -ArgumentList $argument_list -RedirectStandardOutput $output_file -WindowStyle Hidden -RedirectStandardError $error_file
        

        
        $collector_name = "VSSAdmin_Writers"
        $output_file = Build-FinalOutputFile -output_file_name $partial_output_file_name -collector_name $collector_name -needExtraQuotes $false
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name  
        $argument_list = " list writers"
        $executable = "VSSAdmin.exe"
        Write-LogInformation "Executing Collector: $collector_name"
        
        StartNewProcess -FilePath $executable -ArgumentList $argument_list -RedirectStandardOutput $output_file -WindowStyle Hidden -RedirectStandardError $error_file
        

            
    }
    catch {
        $mycommand = $MyInvocation.MyCommand
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand failed with error:  $error_msg"
        return
    }

}

function GetSQLVSSWriterLog()
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand
    
    [console]::TreatControlCAsInput = $true
    
    if ($true -eq $global:sqlvsswriter_has_run)
    {
        return
    }

    # set this to true
    $global:sqlvsswriter_has_run = $true

    if ($global:sql_major_version -lt 15)
    {
        Write-LogDebug "SQL Server major version is $global:sql_major_version. Not collecting SQL VSS log" -DebugLogLevel 4
        return
    }


    try 
    {
        [string]$DestinationFolder = $global:output_folder
        
         # if backup restore scenario, we will get a verbose trace
        if ($true -eq (IsScenarioEnabled -scenarioBit $global:BackupRestoreBit))
        {
            #  collect verbose SQL VSS Writer log if SQL 2019
            $file = 'C:\Program Files\Microsoft SQL Server\90\Shared\SqlWriterConfig.ini'
            (Get-Content $file).Replace("TraceLevel=DEFAULT","TraceLevel=VERBOSE") | Set-Content $file
            (Get-Content $file).Replace("TraceFileSizeMb=1","TraceFileSizeMb=10") | Set-Content $file

            $matchfoundtracelevel = Get-Content $file | Select-String -Pattern 'TraceLevel=VERBOSE' -CaseSensitive -SimpleMatch
            
            if ([String]::IsNullOrEmpty -ne $matchfoundtracelevel)
            {
                Write-LogDebug "The TraceLevel is setting is: $matchfoundtracelevel" -DebugLogLevel 4
            }

            $matchfoundFileSize = Get-Content $file | Select-String -Pattern 'TraceFileSizeMb=10' -CaseSensitive -SimpleMatch
            
            if ([String]::IsNullOrEmpty -ne $matchfoundFileSize)
            {
                Write-LogDebug "The TraceFileSizeMb is: $matchfoundFileSize" -DebugLogLevel 4
            }
            

            Write-LogWarning "To enable SQL VSS VERBOSE loggging, the SQL VSS Writer service must be restarted now and when shutting down data collection. This is a very quick process."
            $userinputvss = Read-Host "Do you want to restart SQL VSS Writer Service>" 
            $HelpMessage = "Please enter a valid input (Y or N)"

            $ValidInput = "Y","N"
            $AllInput = @()
            $AllInput += , $ValidInput
            $AllInput += , $userinputvss
            $AllInput += , $HelpMessage

            $userinputvss = validateUserInput($AllInput)

            if($userinputvss -eq "Y")
            {
                Restart-Service SQLWriter -force
                Write-LogInformation "SQLWriter Service has been restarted."
            }
            if($userinputvss -eq "N")
            {
                Write-LogInformation "You have chosen not to restart SQLWriter Service. No verbose logging will be collected"
            }

            # copy the SqlWriterConfig.txt file in all scenarios
            $file = 'C:\Program Files\Microsoft SQL Server\90\Shared\SqlWriterLogger.txt'
            Get-childitem $file |  Copy-Item -Destination $DestinationFolder | Out-Null
        }    
        
        # if Basic scenario only, then collect the default SQL 2019+ VSS writer trace
        elseif (($true -eq (IsScenarioEnabled -scenarioBit $global:basicBit)) `
                -and ($false -eq (IsScenarioEnabled -scenarioBit $global:BackupRestoreBit)) 
                )     
        {
            $file = 'C:\Program Files\Microsoft SQL Server\90\Shared\SqlWriterLogger.txt'
            Get-childitem $file |  Copy-Item -Destination $DestinationFolder | Out-Null
        }
    }
    catch 
    {
        $mycommand = $MyInvocation.MyCommand 
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand failed with error:  $error_msg"
    }
    finally 
    {
        # we just finished executing this once, don't repeat
        $global:sqlvsswriter_has_run = $true
        Write-LogDebug "Inside finally block for SQLVSSWriter log." -DebugLogLevel 5
    }
}
function GetSysteminfoSummary() 
{

    Write-LogDebug "Inside" $MyInvocation.MyCommand

    $server = $global:sql_instance_conn_str

    [console]::TreatControlCAsInput = $true

    try 
    {
        $partial_output_file_name = Create-PartialOutputFilename ($server)
        $partial_error_output_file_name = Create-PartialErrorOutputFilename($server)
    
        Write-LogDebug "The partial_error_output_file_name is $partial_error_output_file_name" -DebugLogLevel 3
        Write-LogDebug "The partial_output_file_name is $partial_output_file_name" -DebugLogLevel 3

        #in case CTRL+C is pressed
        HandleCtrlC

        #Systeminfo (MSInfo)
        $collector_name = "SystemInfo_Summary"
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name $collector_name  
        $output_file = Build-FinalOutputFile -output_file_name $partial_output_file_name -collector_name $collector_name -needExtraQuotes $false
        $executable = "systeminfo"
        $argument_list = "/FO LIST"
        Write-LogInformation "Executing Collector: $collector_name"
        
        StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden -RedirectStandardError $error_file -RedirectStandardOutput $output_file
        
    }
    catch {
        $mycommand = $MyInvocation.MyCommand 
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand failed with error:  $error_msg"
        return
    }
}

function GetMisciagInfo() 
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand
    
    [console]::TreatControlCAsInput = $true

    $server = $global:sql_instance_conn_str

    try {
        
    
        $partial_output_file_name = Create-PartialOutputFilename ($server)
        $partial_error_output_file_name = Create-PartialErrorOutputFilename($server)
    
        Write-LogDebug "The partial_error_output_file_name is $partial_error_output_file_name" -DebugLogLevel 3
        Write-LogDebug "The partial_output_file_name is $partial_output_file_name" -DebugLogLevel 3

        #in case CTRL+C is pressed
        HandleCtrlC

        #misc DMVs 
        $collector_name = "MiscPssdiagInfo"
        $input_script = Build-InputScript $global:present_directory $collector_name
        $output_file = Build-FinalOutputFile -output_file_name $partial_output_file_name -collector_name $collector_name -needExtraQuotes $true
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $false
        $executable = "sqlcmd.exe"
        $argument_list = "-S" + $server + " -E -Hsqllogscout -w8000 -o" + $output_file + " -i" + $input_script
        Write-LogInformation "Executing Collector: $collector_name"
        
        StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden -RedirectStandardError $error_file
        

    }
    catch 
    {
        $mycommand = $MyInvocation.MyCommand
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand failed with error:  $error_msg"
        return
    }
}

function GetErrorlogs() 
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand

    
    [console]::TreatControlCAsInput = $true

    $server = $global:sql_instance_conn_str
  
    try {
        
    
        $partial_output_file_name = Create-PartialOutputFilename ($server)
        $partial_error_output_file_name = Create-PartialErrorOutputFilename($server)
    
        Write-LogDebug "The partial_error_output_file_name is $partial_error_output_file_name" -DebugLogLevel 3
        Write-LogDebug "The partial_output_file_name is $partial_output_file_name" -DebugLogLevel 3

        #in case CTRL+C is pressed
        HandleCtrlC

        #errorlogs
        $collector_name = "collecterrorlog"
        $input_script = Build-InputScript $global:present_directory $collector_name 
        $output_file = Build-FinalOutputFile -output_file_name $partial_output_file_name -collector_name $collector_name -needExtraQuotes $true
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $false
        $executable = "sqlcmd.exe"
        $argument_list = "-S" + $server + " -E -Hsqllogscout -w8000 -W -o" + $output_file + " -i" + $input_script
        Write-LogInformation "Executing Collector: $collector_name"
        
        StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden -RedirectStandardError $error_file
        
    }
    catch {
        $mycommand = $MyInvocation.MyCommand 
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand failed with error:  $error_msg"
        return
    }

}

function GetTaskList () 
{

    Write-LogDebug "Inside" $MyInvocation.MyCommand

    $server = $global:sql_instance_conn_str

    [console]::TreatControlCAsInput = $true

    try {

        $partial_output_file_name = Create-PartialOutputFilename ($server)
        $partial_error_output_file_name = Create-PartialErrorOutputFilename($server)
    
        Write-LogDebug "The partial_error_output_file_name is $partial_error_output_file_name" -DebugLogLevel 3
        Write-LogDebug "The partial_output_file_name is $partial_output_file_name" -DebugLogLevel 3

        ##task list
        #tasklist processes
    
        $collector_name = "TaskListVerbose"
        $output_file = Build-FinalOutputFile -output_file_name $partial_output_file_name -collector_name $collector_name -needExtraQuotes $false
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name  -needExtraQuotes $false
        $executable = "tasklist.exe"
        $argument_list = "/V"
        Write-LogInformation "Executing Collector: $collector_name"
        
        StartNewProcess -FilePath $executable -ArgumentList $argument_list -RedirectStandardOutput $output_file -WindowStyle Hidden -RedirectStandardError $error_file

        #in case CTRL+C
        HandleCtrlC


        #tasklist services
        $collector_name = "TaskListServices"
        $output_file = Build-FinalOutputFile -output_file_name $partial_output_file_name -collector_name $collector_name -needExtraQuotes $false
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name  -needExtraQuotes $false
        $executable = "tasklist.exe"
        $argument_list = "/SVC"
        Write-LogInformation "Executing Collector: $collector_name"
        
        StartNewProcess -FilePath $executable -ArgumentList $argument_list -RedirectStandardOutput $output_file -WindowStyle Hidden -RedirectStandardError $error_file
        
            
    }
    catch {
        $mycommand = $MyInvocation.MyCommand 
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand failed with error:  $error_msg"
        return
    }
}

function GetRunningProfilerXeventTraces () 
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand

    $server = $global:sql_instance_conn_str

    [console]::TreatControlCAsInput = $true

    try {
        $partial_output_file_name = Create-PartialOutputFilename ($server)
        $partial_error_output_file_name = Create-PartialErrorOutputFilename($server)
    
        Write-LogDebug "The partial_error_output_file_name is $partial_error_output_file_name" -DebugLogLevel 3
        Write-LogDebug "The partial_output_file_name is $partial_output_file_name" -DebugLogLevel 3

        #in case CTRL+C is pressed
        HandleCtrlC

        #active profiler traces and xevents
        $collector_name = "ExistingProfilerXeventTraces"
        $output_file = Build-FinalOutputFile -output_file_name $partial_output_file_name -collector_name $collector_name -needExtraQuotes $true
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $false
        $input_script = Build-InputScript $global:present_directory "Profiler Traces"
        $executable = "sqlcmd.exe"
        $argument_list = "-S" + $server + " -E -Hsqllogscout -w8000 -o" + $output_file + " -i " + $input_script
        Write-LogInformation "Executing Collector: $collector_name"
        
        StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden -RedirectStandardError $error_file
        
    }
    catch {
        $mycommand = $MyInvocation.MyCommand 
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand failed with error:  $error_msg"
        return
    }


}

function GetHighCPUPerfStats () 
{

    Write-LogDebug "Inside" $MyInvocation.MyCommand

    [console]::TreatControlCAsInput = $true

    $server = $global:sql_instance_conn_str

    try {
        $partial_output_file_name = Create-PartialOutputFilename ($server)
        $partial_error_output_file_name = Create-PartialErrorOutputFilename($server)
    
        Write-LogDebug "The partial_error_output_file_name is $partial_error_output_file_name" -DebugLogLevel 3
        Write-LogDebug "The partial_output_file_name is $partial_output_file_name" -DebugLogLevel 3

        #in case CTRL+C is pressed
        HandleCtrlC

        #SQL Server High CPU Perf Stats
        $collector_name = "HighCPU_perfstats"
        $input_script = Build-InputScript $global:present_directory $collector_name
        $output_file = Build-FinalOutputFile -output_file_name $partial_output_file_name -collector_name $collector_name -needExtraQuotes $true
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name  -needExtraQuotes $false
        $executable = "sqlcmd.exe"
        $argument_list = "-S" + $server + " -E -Hsqllogscout -w8000 -o" + $output_file + " -i" + $input_script
        Write-LogInformation "Executing Collector: $collector_name"
        
        StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden -RedirectStandardError $error_file
        
    }
    catch {
        $mycommand = $MyInvocation.MyCommand
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand failed with error:  $error_msg"
        return
    }

}

function GetPerfStats () 
{

    Write-LogDebug "Inside" $MyInvocation.MyCommand

    $server = $global:sql_instance_conn_str

    [console]::TreatControlCAsInput = $true

    try {
        $partial_output_file_name = Create-PartialOutputFilename ($server)
        $partial_error_output_file_name = Create-PartialErrorOutputFilename($server)
    
        Write-LogDebug "The partial_error_output_file_name is $partial_error_output_file_name" -DebugLogLevel 3
        Write-LogDebug "The partial_output_file_name is $partial_output_file_name" -DebugLogLevel 3

        #in case CTRL+C is pressed
        HandleCtrlC

        #SQL Server Perf Stats
        $collector_name = "SQLServerPerfStats"
        $input_script = Build-InputScript $global:present_directory "SQL Server Perf Stats"
        $output_file = Build-FinalOutputFile -output_file_name $partial_output_file_name -collector_name $collector_name -needExtraQuotes $true
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $false 
        $executable = "sqlcmd.exe"
        $argument_list = "-S" + $server + " -E -Hsqllogscout -w8000 -o" + $output_file + " -i" + $input_script
        Write-LogInformation "Executing Collector: $collector_name"
        StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden -RedirectStandardError $error_file
        
    }
    catch {
        $mycommand = $MyInvocation.MyCommand
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand failed with error:  $error_msg"
        return
    }

}

function GetPerfStatsSnapshot ([string] $TimeOfCapture="Startup") 
{

    Write-LogDebug "Inside" $MyInvocation.MyCommand

    [console]::TreatControlCAsInput = $true


    if ($global:sql_instance_conn_str -eq $NO_INSTANCE_NAME)
    {
        Write-LogWarning "No SQL Server instance specified, thus skipping execution of PerfStats shutdown collector"
        return
    }

    $server = $global:sql_instance_conn_str

    try {
        $partial_output_file_name = Create-PartialOutputFilename ($server)
        $partial_error_output_file_name = Create-PartialErrorOutputFilename($server)
    
        Write-LogDebug "The partial_error_output_file_name is $partial_error_output_file_name" -DebugLogLevel 3
        Write-LogDebug "The partial_output_file_name is $partial_output_file_name" -DebugLogLevel 3

        #in case CTRL+C is pressed
        HandleCtrlC

        #SQL Server Perf Stats Snapshot
        $collector_name = "SQLServerPerfStatsSnapshot"+ $TimeOfCapture
        $input_script = Build-InputScript $global:present_directory "SQL Server Perf Stats Snapshot"
        $output_file = Build-FinalOutputFile -output_file_name $partial_output_file_name -collector_name $collector_name -needExtraQuotes $true
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $false
        $executable = "sqlcmd.exe"
        $argument_list = "-S" + $server + " -E -Hsqllogscout -w8000 -o" + $output_file + " -i" + $input_script
        Write-LogInformation "Executing Collector: $collector_name"
        StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden -RedirectStandardError $error_file
        
    }
    catch {
        $mycommand = $MyInvocation.MyCommand
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand failed with error:  $error_msg"
        return
    }

}

function GetPerfmonCounters () 
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand
    
    [console]::TreatControlCAsInput = $true

    if ($true -eq $global:perfmon_is_on)
    {
        Write-LogDebug "Perfmon has already been started by another collector." -DebugLogLevel 3
        return
    }

    $server = $global:sql_instance_conn_str
    $internal_folder = $global:internal_output_folder

    try {
        $partial_output_file_name = Create-PartialOutputFilename ($server)
        $partial_error_output_file_name = Create-PartialErrorOutputFilename($server)
    
        Write-LogDebug "The partial_error_output_file_name is $partial_error_output_file_name" -DebugLogLevel 3
        Write-LogDebug "The partial_output_file_name is $partial_output_file_name" -DebugLogLevel 3
    
        #in case CTRL+C is pressed
        HandleCtrlC

        #Perfmon
        $collector_name = "Perfmon"
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $false
        $output_file = Build-FinalOutputFile -output_file_name $partial_output_file_name -collector_name $collector_name -needExtraQuotes $true
        $executable = "cmd.exe"
        $argument_list = "/C logman stop logscoutperfmon & logman delete logscoutperfmon & logman CREATE COUNTER -n logscoutperfmon -cf `"" + $internal_folder + "LogmanConfig.txt`" -f bin -si 00:00:05 -max 250 -cnf 01:00:00  -o " + $output_file + "  & logman start logscoutperfmon "
        Write-LogInformation "Executing Collector: $collector_name"
        StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden -RedirectStandardOutput $error_file

        #turn on the perfmon notification to let others know it is enabled
        $global:perfmon_is_on = $true
    }
    catch {
        $mycommand = $MyInvocation.MyCommand
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand failed with error:  $error_msg"
        return
    }

}

function GetServiceBrokerInfo () 
{

    Write-LogDebug "Inside" $MyInvocation.MyCommand

    $server = $global:sql_instance_conn_str

    [console]::TreatControlCAsInput = $true

    try {
        $partial_output_file_name = Create-PartialOutputFilename ($server)
        $partial_error_output_file_name = Create-PartialErrorOutputFilename($server)
    
        Write-LogDebug "The partial_error_output_file_name is $partial_error_output_file_name" -DebugLogLevel 3
        Write-LogDebug "The partial_output_file_name is $partial_output_file_name" -DebugLogLevel 3

        #in case CTRL+C is pressed
        HandleCtrlC

        #Service Broker collection
        $collector_name = "SSB_diag"
        $input_script = Build-InputScript $global:present_directory $collector_name
        $output_file = Build-FinalOutputFile -output_file_name $partial_output_file_name -collector_name $collector_name -needExtraQuotes $true
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $false
        $executable = "sqlcmd.exe"
        $argument_list = "-S" + $server + " -E -Hsqllogscout -w8000 -o" + $output_file + " -i" + $input_script
        Write-LogInformation "Executing Collector: $collector_name"
        StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden -RedirectStandardError $error_file

    }
    catch {
        $mycommand = $MyInvocation.MyCommand
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand failed with error:  $error_msg"
        return
    }

}

function GetTempdbSpaceLatchingStats () 
{
    
    Write-LogDebug "Inside" $MyInvocation.MyCommand

    $server = $global:sql_instance_conn_str

    try {

        $partial_output_file_name = Create-PartialOutputFilename ($server)
        $partial_error_output_file_name = Create-PartialErrorOutputFilename($server)
    
        Write-LogDebug "The partial_error_output_file_name is $partial_error_output_file_name" -DebugLogLevel 3
        Write-LogDebug "The partial_output_file_name is $partial_output_file_name" -DebugLogLevel 3

        #Tempdb space and latching
        $collector_name = "TempDBAnalysis"
        $input_script = Build-InputScript $global:present_directory $collector_name
        $output_file = Build-FinalOutputFile -output_file_name $partial_output_file_name -collector_name $collector_name -needExtraQuotes $true
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $false
        $executable = "sqlcmd.exe"
        $argument_list = "-S" + $server + " -E -Hsqllogscout -w8000 -o" + $output_file + " -i" + $input_script
        Write-LogInformation "Executing Collector: $collector_name"
        StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden -RedirectStandardError $error_file


    }
    catch {
        $mycommand = $MyInvocation.MyCommand
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand failed with error:  $error_msg"
        return
    }

}

function GetLinkedServerInfo () 
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand

    $server = $global:sql_instance_conn_str

    try {
        $partial_output_file_name = Create-PartialOutputFilename ($server)
        $partial_error_output_file_name = Create-PartialErrorOutputFilename($server)
    
        Write-LogDebug "The partial_error_output_file_name is $partial_error_output_file_name" -DebugLogLevel 3
        Write-LogDebug "The partial_output_file_name is $partial_output_file_name" -DebugLogLevel 3


        #Linked Server configuration
        $collector_name = "linked_server_config"
        $input_script = Build-InputScript $global:present_directory $collector_name
        $output_file = Build-FinalOutputFile -output_file_name $partial_output_file_name -collector_name $collector_name -needExtraQuotes $true
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $false
        $executable = "sqlcmd.exe"
        $argument_list = "-S" + $server + " -E -Hsqllogscout -w8000 -o" + $output_file + " -i" + $input_script
        Write-LogInformation "Executing Collector: $collector_name"
        StartNewProcess -FilePath  $executable -ArgumentList $argument_list -WindowStyle Hidden -RedirectStandardError $error_file

    }
    catch {
        $mycommand = $MyInvocation.MyCommand 
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand failed with error:  $error_msg"
        return
    }

}

function GetQDSInfo () 
{
    
    Write-LogDebug "Inside" $MyInvocation.MyCommand

    $server = $global:sql_instance_conn_str

    try {

        $partial_output_file_name = Create-PartialOutputFilename ($server)
        $partial_error_output_file_name = Create-PartialErrorOutputFilename($server)
    
        Write-LogDebug "The partial_error_output_file_name is $partial_error_output_file_name" -DebugLogLevel 3
        Write-LogDebug "The partial_output_file_name is $partial_output_file_name" -DebugLogLevel 3

        #Query Store
        $collector_name = "Query Store"
        $input_script = Build-InputScript $global:present_directory $collector_name
        $output_file = Build-FinalOutputFile -output_file_name $partial_output_file_name -collector_name $collector_name -needExtraQuotes $true
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $false
        $executable = "sqlcmd.exe"
        $argument_list = "-S" + $server + " -E -Hsqllogscout -w8000 -o" + $output_file + " -i" + $input_script
        Write-LogInformation "Executing Collector: $collector_name"
        StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden -RedirectStandardError $error_file

    }
    catch {
        $mycommand = $MyInvocation.MyCommand 
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand failed with error:  $error_msg"
        return
    }

}

function GetReplMetadata () 
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand

    $server = $global:sql_instance_conn_str

    try {

        $partial_output_file_name = Create-PartialOutputFilename ($server)
        $partial_error_output_file_name = Create-PartialErrorOutputFilename($server)
    
        Write-LogDebug "The partial_error_output_file_name is $partial_error_output_file_name" -DebugLogLevel 3
        Write-LogDebug "The partial_output_file_name is $partial_output_file_name" -DebugLogLevel 3

        #Replication Metadata
        $collector_name = "Repl_Metadata_Collector"
        $input_script = Build-InputScript $global:present_directory $collector_name
        $output_file = Build-FinalOutputFile -output_file_name $partial_output_file_name -collector_name $collector_name -needExtraQuotes $true
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $false
        $executable = "sqlcmd.exe"
        $argument_list = "-S" + $server + " -E -Hsqllogscout -w8000 -o" + $output_file + " -i" + $input_script
        Write-LogInformation "Executing Collector: $collector_name"
        StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden -RedirectStandardError $error_file

    }
    catch {
        $mycommand = $MyInvocation.MyCommand
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand failed with error:  $error_msg"
        return
    }

}

function GetChangeDataCaptureInfo ([string] $TimeOfCapture = "Startup") {
    
    Write-LogDebug "Inside" $MyInvocation.MyCommand

    $server = $global:sql_instance_conn_str

    try {
        $partial_output_file_name = Create-PartialOutputFilename ($server)
        $partial_error_output_file_name = Create-PartialErrorOutputFilename($server)
    
        Write-LogDebug "The partial_error_output_file_name is $partial_error_output_file_name" -DebugLogLevel 3
        Write-LogDebug "The partial_output_file_name is $partial_output_file_name" -DebugLogLevel 3

        #Change Data Capture (CDC)
        $collector_name = "ChangeDataCapture"
        $input_script = Build-InputScript $global:present_directory $collector_name
        $collector_name_time_of_capture = $collector_name + $TimeOfCapture
        $output_file = Build-FinalOutputFile -output_file_name $partial_output_file_name -collector_name $collector_name_time_of_capture -needExtraQuotes $true
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name_time_of_capture -needExtraQuotes $false
        $executable = "sqlcmd.exe"
        $argument_list = "-S" + $server + " -E -Hsqllogscout -w8000 -o" + $output_file + " -i" + $input_script
        Write-LogInformation "Executing Collector: $collector_name"
        StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden -RedirectStandardError $error_file

    }
    catch {
        $mycommand = $MyInvocation.MyCommand
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand failed with error:  $error_msg"
        return
    }

}

function GetChangeTracking ([string] $TimeOfCapture = "Startup") 
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand

    $server = $global:sql_instance_conn_str

    try {
        $partial_output_file_name = Create-PartialOutputFilename ($server)
        $partial_error_output_file_name = Create-PartialErrorOutputFilename($server)
    
        Write-LogDebug "The partial_error_output_file_name is $partial_error_output_file_name" -DebugLogLevel 3
        Write-LogDebug "The partial_output_file_name is $partial_output_file_name" -DebugLogLevel 3

        #Change Tracking
        $collector_name = "Change_Tracking"
        $input_script = Build-InputScript $global:present_directory $collector_name
        $collector_name_time_of_capture = $collector_name + $TimeOfCapture
        $output_file = Build-FinalOutputFile -output_file_name $partial_output_file_name -collector_name $collector_name_time_of_capture -needExtraQuotes $true
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name_time_of_capture -needExtraQuotes $false
        $executable = "sqlcmd.exe"
        $argument_list = "-S" + $server + " -E -Hsqllogscout -w8000 -o" + $output_file + " -i" + $input_script
        Write-LogInformation "Executing Collector: $collector_name"
        StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden -RedirectStandardError $error_file

    }
    catch {
        $mycommand = $MyInvocation.MyCommand
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand failed with error:  $error_msg"
        return
    }

}

function GetFilterDrivers () 
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand

    [console]::TreatControlCAsInput = $true

    $server = $global:sql_instance_conn_str

    try {
        $partial_output_file_name = Create-PartialOutputFilename ($server)
        $partial_error_output_file_name = Create-PartialErrorOutputFilename($server)
    
        Write-LogDebug "The partial_error_output_file_name is $partial_error_output_file_name" -DebugLogLevel 3
        Write-LogDebug "The partial_output_file_name is $partial_output_file_name" -DebugLogLevel 3

        #in case CTRL+C is pressed
        HandleCtrlC

        #filter drivers
        $collector_name = "FLTMC_Filters"
        $output_file = Build-FinalOutputFile -output_file_name $partial_output_file_name -collector_name $collector_name -needExtraQuotes $false
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name  
        $argument_list = " filters"
        $executable = "fltmc.exe"
        Write-LogInformation "Executing Collector: $collector_name"
        StartNewProcess -FilePath $executable -ArgumentList $argument_list -RedirectStandardOutput $output_file -WindowStyle Hidden -RedirectStandardError $error_file


        #filters instance
        $collector_name = "FLTMC_Instances"
        $output_file = Build-FinalOutputFile -output_file_name $partial_output_file_name -collector_name $collector_name -needExtraQuotes $false
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name  
        $executable = "fltmc.exe"
        $argument_list = " instances"
        Write-LogInformation "Executing Collector: $collector_name"
        
        StartNewProcess -FilePath $executable -ArgumentList $argument_list -RedirectStandardOutput $output_file -WindowStyle Hidden -RedirectStandardError $error_file

    }
    catch {
        $mycommand = $MyInvocation.MyCommand
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand failed with error:  $error_msg"
        return
    }

}


function GetNetworkTrace () 
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand

    [console]::TreatControlCAsInput = $true
    
    $server = $global:sql_instance_conn_str

    $internal_folder = $global:internal_output_folder

    try {
        $partial_output_file_name = Create-PartialOutputFilename ($server)
        $partial_error_output_file_name = Create-PartialErrorOutputFilename($server)
    
        Write-LogDebug "The partial_error_output_file_name is $partial_error_output_file_name" -DebugLogLevel 3
        Write-LogDebug "The partial_output_file_name is $partial_output_file_name" -DebugLogLevel 3
    
        #in case CTRL+C is pressed
        HandleCtrlC

        #Perfmon
        $collector_name = $NETWORKTRACE_NAME
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $false
        $netsh_output = Build-FinalOutputFile -output_file_name $partial_output_file_name -collector_name "delete" -needExtraQuotes $true -fileExt ".me"
        $output_file = Build-FinalOutputFile -output_file_name $partial_output_file_name -collector_name $collector_name -needExtraQuotes $true -fileExt "_"
        $param2 =  Split-Path (Split-Path $output_file -Parent) -Leaf
        $executable = "cmd.exe"
        #$argument_list = "/C netsh trace start sessionname='sqllogscout_nettrace' report=yes persistent=yes capture=yes tracefile=" + $output_file
        $argument_list  = "/c StartNetworkTrace.bat " + $output_file + " " + $netsh_output
        Write-LogInformation "Executing Collector: $collector_name"
        Write-LogDebug $param2
        StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden -RedirectStandardOutput $error_file
    }
    catch {
        $mycommand = $MyInvocation.MyCommand
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand failed with error:  $error_msg"
        return
    }

}

function GetMemoryDumps () 
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand


    try {
    
        $InstanceSearchStr = ""
        #strip the server name from connection string so it can be used for looking up PID
        $instanceonly = Strip-InstanceName -NetnamePlusInstance $global:sql_instance_conn_str


        #if default instance use "MSSQLSERVER", else "MSSQL$InstanceName
        if ($instanceonly -eq $global:host_name) {
            $InstanceSearchStr = "MSSQLSERVER"
        }
        else {
            $InstanceSearchStr = "MSSQL$" + $instanceonly

        }
		$collector_name = "Memorydump"
        Write-LogDebug "Output folder is $global:output_folder" -DebugLogLevel 2
        Write-LogDebug "Service name is $InstanceSearchStr" -DebugLogLevel 2
        Write-LogInformation "Executing Collector: $collector_name"
        #invoke SQLDumpHelper
        .\SQLDumpHelper.ps1 -DumpOutputFolder $global:output_folder -InstanceOnlyName $InstanceSearchStr
    }
    catch {
        $mycommand = $MyInvocation.MyCommand
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand failed with error:  $error_msg"
        return
    }
} 

function GetWindowsVersion
{
   #Write-LogDebug "Inside" $MyInvocation.MyCommand

   try {
       $winver = [Environment]::OSVersion.Version.Major    
   }
   catch {
        $mycommand = $MyInvocation.MyCommand
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand failed with error:  $error_msg"
        return
   }
   
   
   #Write-Debug "Windows version is: $winver" -DebugLogLevel 3

   return $winver;
}

function GetWPRTrace () 
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand

    [console]::TreatControlCAsInput = $true

    $wpr_win_version = GetWindowsVersion

    if ($wpr_win_version -lt 8) 
    {
        Write-LogError "Windows Performance Recorder is not available on this version of Windows"
        exit;   
    } 
    else 
    {
        try {

            $partial_error_output_file_name = Create-PartialErrorOutputFilename -server $server
    
            Write-LogDebug "The partial_error_output_file_name is $partial_error_output_file_name" -DebugLogLevel 3

            #choose collector type

            
            [string[]] $WPRArray = "CPU", "Heap and Virtual memory", "Disk and File I/O", "Filter drivers"
            $WPRIntRange = 0..($ScenarioArray.Length - 1)  

            Write-LogInformation "Please select one of the following Data Collection Type:`n"
            Write-LogInformation ""
            Write-LogInformation "ID   WRP Profile"
            Write-LogInformation "--   ---------------"

            for ($i = 0; $i -lt $WPRArray.Count; $i++) {
                Write-LogInformation $i "  " $WPRArray[$i]
            }
            $isInt = $false
            
            Write-LogInformation ""
            Write-LogWarning "Enter the WPR Profile ID for which you want to collect performance data. Then press Enter" 

            $ValidInput = "0","1","2","3"
            $wprIdStr = Read-Host "Enter the WPR Profile ID from list above>" -CustomLogMessage "WPR Profile Console input:"
            $HelpMessage = "Please enter a valid input (0,1,2 or 3)"

            #$AllInput = $ValidInput,$WPR_YesNo,$HelpMessage 
            $AllInput = @()
            $AllInput += , $ValidInput
            $AllInput += , $wprIdStr
            $AllInput += , $HelpMessage
        
            $wprIdStr = validateUserInput($AllInput)

            Write-LogInformation "WPR Profile Console input: $wprIdStr"
            
            try {
                $wprIdStrIdInt = [convert]::ToInt32($wprIdStr)
                $isInt = $true
            }

            catch [FormatException] {
                Write-LogError "The value entered for ID '", $ScenIdStr, "' is not an integer"
                continue 
            }
            
            If ($isInt -eq $true) {
                #Perfmon
                
                switch ($wprIdStr) {
                    "0" { 
                        $collector_name = $global:wpr_collector_name= "WPR_CPU"
                        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $false
                        $executable = "cmd.exe"
                        $argument_list = "/C wpr.exe -start CPU -filemode "
                        Write-LogInformation "Executing Collector: $collector_name"
                        StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden -RedirectStandardOutput $error_file
                        
                        Start-Sleep -s 15
                    }
                    "1" { 
                        $collector_name = $global:wpr_collector_name = "WPR_HeapAndVirtualMemory"
                        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $false
                        $executable = "cmd.exe"
                        $argument_list = "/C wpr.exe -start Heap -start VirtualAllocation  -filemode "
                        Write-LogInformation "Executing Collector: $collector_name"
                        StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden -RedirectStandardOutput $error_file
                        
                        Start-Sleep -s 15
                    }
                    "2" { 
                        $collector_name = $global:wpr_collector_name = "WPR_DiskIO_FileIO"
                        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $false
                        $executable = "cmd.exe"
                        $argument_list = "/C wpr.exe -start DiskIO -start FileIO -filemode "
                        Write-LogInformation "Executing Collector: $collector_name"
                        StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden -RedirectStandardOutput $error_file
                        
                        Start-Sleep -s 15
                    }
                    "3" { 
                        $collector_name = $global:wpr_collector_name = "WPR_MiniFilters"
                        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $false
                        $executable = "cmd.exe"
                        $argument_list = "/C wpr.exe -start Minifilter -filemode "
                        Write-LogInformation "Executing Collector: $collector_name"
                        StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden -RedirectStandardOutput $error_file
                        
                        Start-Sleep -s 15
                    }                    
                }
            }
        }
        catch {
            $mycommand = $MyInvocation.MyCommand 
            $error_msg = $PSItem.Exception.Message 
            Write-LogError "Function $mycommand failed with error:  $error_msg"
            return
        }
    }

}

function GetMemoryLogs()
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand

    [console]::TreatControlCAsInput = $true

    $server = $global:sql_instance_conn_str

    try {
        $partial_output_file_name = Create-PartialOutputFilename ($server)
        $partial_error_output_file_name = Create-PartialErrorOutputFilename($server)
    
        Write-LogDebug "The partial_error_output_file_name is $partial_error_output_file_name" -DebugLogLevel 3
        Write-LogDebug "The partial_output_file_name is $partial_output_file_name" -DebugLogLevel 3

        #Change Tracking
        $collector_name = "SQL_Server_Mem_Stats"
        $input_script = Build-InputScript $global:present_directory $collector_name
        $output_file = Build-FinalOutputFile -output_file_name $partial_output_file_name -collector_name $collector_name -needExtraQuotes $true
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $false
        $executable = "sqlcmd.exe"
        $argument_list = "-S" + $server + " -E -Hsqllogscout -w8000 -o" + $output_file + " -i" + $input_script
        Write-LogInformation "Executing Collector: $collector_name"
        StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden -RedirectStandardError $error_file
        
        
    }
    catch {
        $function_name = $MyInvocation.MyCommand 
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "$function_name Function failed with error:  $error_msg"
        return
    }


}

function GetClusterInformation()
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand

    [console]::TreatControlCAsInput = $true

    $server = $global:sql_instance_conn_str
    $output_folder = $global:output_folder
    $ClusterError = 0
    $collector_name = "ClusterInfo"
    $partial_output_file_name = Create-PartialOutputFilename ($server)
    
    Write-LogInformation "Executing Collector: $collector_name"

    $output_file = Build-FinalOutputFile -output_file_name $partial_output_file_name -collector_name $collector_name -needExtraQuotes $false -fileExt ".out"
    [System.Text.StringBuilder]$rs_ClusterLog = New-Object -TypeName System.Text.StringBuilder

    try 
    {
            Import-Module FailoverClusters
            [void]$rs_ClusterLog.Append("-- Windows Cluster Name --`r`n")
            $clusterName = Get-cluster
            [void]$rs_ClusterLog.Append("$clusterName`r`n")
            
            # dumping windows cluster log
            Write-LogWarning "Collecting Windows cluster log for all running nodes, this process may take some time....." 
            Get-ClusterLog -Destination $output_folder  -UseLocalTime | Out-Null
    }
    catch 
    {
        $ClusterError = 1
        $function_name = $MyInvocation.MyCommand 
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "$function_name - Cluster is not found...:  $error_msg"
    }
    
    if ($ClusterError -eq 0)
    {
        try 
        {
                #Cluster Registry Hive
                $collector_name = "ClusterRegistryHive"
                
                $output_file = Build-FinalOutputFile -output_file_name $partial_output_file_name -collector_name $collector_name -needExtraQuotes $false -fileExt ".out"
                Get-ChildItem 'HKLM:HKEY_LOCAL_MACHINE\Cluster' -Recurse | Out-File -FilePath $output_file
                
                $output_file = Build-FinalOutputFile -output_file_name $partial_output_file_name -collector_name $collector_name -needExtraQuotes $true -fileExt ".hiv"
                $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name  -needExtraQuotes $false
                $executable = "reg.exe"
                $argument_list = "save `"HKEY_LOCAL_MACHINE\Cluster`" $output_file"
                Write-LogInformation "Executing Collector: $collector_name"
                
                StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden -RedirectStandardError $error_file

        }
        catch
        {
                $function_name = $MyInvocation.MyCommand 
                $error_msg = $PSItem.Exception.Message 
                Write-LogError "$function_name - Error while accessing cluster registry keys...:  $error_msg"
        }

        try 
        {
            [void]$rs_ClusterLog.Append("-- Cluster Nodes --`r`n")
            $clusternodenames =  Get-Clusternode | Out-String
            [void]$rs_ClusterLog.Append("$clusternodenames`r`n") 
        }
        catch 
        {
            $function_name = $MyInvocation.MyCommand 
            $error_msg = $PSItem.Exception.Message 
            Write-LogError "$function_name - Error while accessing cluster (node):  $error_msg"
        }

        try
        {
            [void]$rs_ClusterLog.Append("-- Cluster Network Interfaces --`r`n")
            $ClusterNetworkInterface = Get-ClusterNetworkInterface | Out-String
            [void]$rs_ClusterLog.Append("$ClusterNetworkInterface`r`n") 
        }
        catch
        {
            $function_name = $MyInvocation.MyCommand 
            $error_msg = $PSItem.Exception.Message 
            Write-LogError "$function_name - Error while accessing Cluster Network Interface:  $error_msg"
        }

        try 
        {
            [void]$rs_ClusterLog.Append("-- Cluster Shared Volume(s) --`r`n")
            $ClusterSharedVolume = Get-ClusterSharedVolume | Out-String
            [void]$rs_ClusterLog.Append("$ClusterSharedVolume`r`n") 

        }
        catch
        {
            $function_name = $MyInvocation.MyCommand 
            $error_msg = $PSItem.Exception.Message 
            Write-LogError "$function_name - Error while accessing Cluster Shared Volume:  $error_msg"
        }

        try 
        {
            [void]$rs_ClusterLog.Append("-- Cluster Cluster Quorum --`r`n")
            $ClusterQuorum = Get-ClusterQuorum | Format-List * | Out-String
            [void]$rs_ClusterLog.Append("$ClusterQuorum`r`n") 


            Get-Clusterquorum | ForEach-Object {
                        $cluster = $_.Cluster
                        $QuorumResource = $_.QuorumResource
                        $QuorumType = $_.QuorumType
            
                        # $results = New-Object PSObject -property @{
                        # "QuorumResource" = $QuorumResource
                        # "QuorumType" = $QuorumType
                        # "cluster" = $Cluster
                        } | Out-String

            [void]$rs_ClusterLog.Append("$results`r`n") 
           
        }
        catch 
        {
            $function_name = $MyInvocation.MyCommand 
            $error_msg = $PSItem.Exception.Message 
            Write-LogError "$function_name - Error while accessing Cluster Quorum:  $error_msg"
        }

        try 
        {
            [void]$rs_ClusterLog.Append("-- Cluster Physical Disks --`r`n")
            $PhysicalDisk = Get-PhysicalDisk | Out-String           
            [void]$rs_ClusterLog.Append("$PhysicalDisk`r`n") 
        }
        catch {
            $function_name = $MyInvocation.MyCommand 
            $error_msg = $PSItem.Exception.Message 
            Write-LogError "$function_name - Error while accessing Physical Disk:  $error_msg"
        }

        try 
        {
            [void]$rs_ClusterLog.Append("-- Cluster Groups (Roles) --`r`n")
            $clustergroup = Get-Clustergroup | Out-String
            [void]$rs_ClusterLog.Append("$clustergroup`r`n") 
        }
        catch
        {
            $function_name = $MyInvocation.MyCommand 
            $error_msg = $PSItem.Exception.Message 
            Write-LogError "$function_name - Error while accessing cluster group:  $error_msg"
        }
        
        try 
        {
            [void]$rs_ClusterLog.Append("-- Cluster Resources --`r`n")
            $clusterresource = Get-ClusterResource | Out-String
            [void]$rs_ClusterLog.Append("$clusterresource`r`n")

        }
        catch 
        {
            $function_name = $MyInvocation.MyCommand 
            $error_msg = $PSItem.Exception.Message 
            Write-LogError "$function_name - Error while accessing cluster resource:  $error_msg"
        }

        try 
        {
            [void]$rs_ClusterLog.Append("-- Cluster Net Firewall Profiles --`r`n")
            $NetFirewallProfile = Get-NetFirewallProfile | Out-String
            [void]$rs_ClusterLog.Append("$NetFirewallProfile`r`n") 
        }
        catch 
        {
            $function_name = $MyInvocation.MyCommand 
            $error_msg = $PSItem.Exception.Message 
            Write-LogError "$function_name - Error while accessing Net Firewall Profile:  $error_msg"
        }

        try 
        {
            [void]$rs_ClusterLog.Append("-- cluster clusternetwork --`r`n")
            $clusternetwork = Get-clusternetwork| Format-List * | Out-String
            [void]$rs_ClusterLog.Append("$clusternetwork`r`n") 
        }
        catch
        {
            $function_name = $MyInvocation.MyCommand 
            $error_msg = $PSItem.Exception.Message 
            Write-LogError "$function_name - Error while accessing cluster network:  $error_msg"
        }

       try 
        {
            [void]$rs_ClusterLog.Append("-- Cluster Info--`r`n")
            $clusterfl = Get-Cluster | Format-List *  | Out-String
            [void]$rs_ClusterLog.Append("$clusterfl`r`n") 
        }
        catch 
        {
            $function_name = $MyInvocation.MyCommand 
            $error_msg = $PSItem.Exception.Message 
            Write-LogError "$function_name - Error while accessing cluster configured value:  $error_msg"
        }

        try 
        {
            [void]$rs_ClusterLog.Append("-- Cluster Access--`r`n")
            $clusteraccess = get-clusteraccess | Out-String
            [void]$rs_ClusterLog.Append("$clusteraccess`r`n") 
        }
        catch
        {
            $function_name = $MyInvocation.MyCommand 
            $error_msg = $PSItem.Exception.Message 
            Write-LogError "$function_name - Error while accessing cluster access settings:  $error_msg"
        }

        try 
        {
            [void]$rs_ClusterLog.Append("-- cluster Node Details --`r`n")
            $clusternodefl = get-clusternode | Format-List * | Out-String
            [void]$rs_ClusterLog.Append("$clusternodefl`r`n") 
        }
        catch
        {
            $function_name = $MyInvocation.MyCommand 
            $error_msg = $PSItem.Exception.Message 
            Write-LogError "$function_name - Error while accessing cluster node configured value:  $error_msg"
        }

        Add-Content -Path ($output_file) -Value ($rs_ClusterLog.ToString())
    }
}

function GetSQLErrorLogsDumpsSysHealth()
{
    
    Write-LogDebug "Inside" $MyInvocation.MyCommand

    [console]::TreatControlCAsInput = $true

    $collector_name = "SQLErrorLogs_AgentLogs_SystemHealth_MemDumps_FciXel"
    Write-LogInformation "Executing Collector: $collector_name"

    try{

            $server = $global:sql_instance_conn_str

            
            $partial_error_output_file_name = Create-PartialErrorOutputFilename($server)
            Write-LogDebug "The partial_error_output_file_name is $partial_error_output_file_name" -DebugLogLevel 3
            $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $false


            if ($server -notlike '*\*')
            {
                $vInstance = "MSSQLSERVER"
            } 
            elseif ($server -like '*\*')
            {
                $vInstance = Strip-InstanceName($server) 
            }

            [string]$DestinationFolder = $global:output_folder 

            #in case CTRL+C is pressed
            HandleCtrlC
            
            # get XEL files from last three weeks
            $time_threshold = (Get-Date).AddDays(-21)

            $vRegInst = (Get-ItemProperty -Path HKLM:"SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL").$vInstance
            $vRegPath = "SOFTWARE\Microsoft\Microsoft SQL Server\" + $vRegInst + "\MSSQLServer\Parameters" 
            $vLogPath = (Get-ItemProperty -Path HKLM:$vRegPath).SQLArg1 -replace '-e'
            $vLogPath = $vLogPath -replace 'ERRORLOG'

            Write-LogDebug "The \LOG folder discovered for instance is: $vLogPath" -DebugLogLevel 4

            Write-LogDebug "Getting ERRORLOG .xel files" -DebugLogLevel 3
            Get-ChildItem -Path $vLogPath -Filter "ERRORLOG*" | Copy-Item -Destination $DestinationFolder 2>> $error_file | Out-Null

            Write-LogDebug "Getting *_SQLDIAG .xel files" -DebugLogLevel 3
            Get-ChildItem -Path $vLogPath -Filter "SQLAGENT*" | Copy-Item -Destination $DestinationFolder 2>> $error_file | Out-Null

            Write-LogDebug "Getting System_Health .xel files" -DebugLogLevel 3
            Get-ChildItem -Path $vLogPath -Filter "system_health*.xel" | Copy-Item -Destination $DestinationFolder 2>> $error_file | Out-Null
            
            Write-LogDebug "Getting SQL Dump files" -DebugLogLevel 3
            Get-ChildItem -Path "$vLogPath\SQLDump*.mdmp", "$vLogPath\SQLDump*.log" | Where-Object {$_.LastWriteTime -gt $time_threshold} | Copy-Item -Destination $DestinationFolder 2>> $error_file | Out-Null

            if (IsClustered)
            {
                Write-LogDebug "Getting MSSQLSERVER_SQLDIAG .xel files" -DebugLogLevel 3
                Get-ChildItem -Path $vLogPath -Filter "*_SQLDIAG*.xel" | Copy-Item -Destination $DestinationFolder 2>> $error_file | Out-Null
            }
        } catch {
            Write-LogError "Error Collecting SQL Server Error Log, SystemHealth and Dump Files"
            Write-LogError $_
        }
}
function GetPolybaseLogs()
{
    
    Write-LogDebug "Inside" $MyInvocation.MyCommand

    [console]::TreatControlCAsInput = $true

    $collector_name = "PolybaseLogs"
    Write-LogInformation "Executing Collector: $collector_name"

    try{
            $server = $global:sql_instance_conn_str

            $partial_error_output_file_name = Create-PartialErrorOutputFilename($server)
            Write-LogDebug "The partial_error_output_file_name is $partial_error_output_file_name" -DebugLogLevel 3
            $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $false


            if ($server -notlike '*\*')
            {
                $vInstance = "MSSQLSERVER"
            } 
            if ($server -like '*\*')
            {
                $vInstance = Strip-InstanceName($server) 
            }
            [string]$DestinationFolder = $global:output_folder 

            #in case CTRL+C is pressed
            HandleCtrlC

            $vRegInst = (Get-ItemProperty -Path HKLM:"SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL").$vInstance
            $vRegPath = "SOFTWARE\Microsoft\Microsoft SQL Server\" + $vRegInst + "\MSSQLServer\Parameters" 
            $vLogPath = (Get-ItemProperty -Path HKLM:$vRegPath).SQLArg1 -replace '-e'
            $vLogPath = $vLogPath -replace 'ERRORLOG'
            # polybase path
            $polybase_path = $vLogPath + '\Polybase\'            
            $ValidPath = Test-Path -Path $polybase_path
            $exclude_ext = @('*.hprof','*.bak')  #exclude file with these extensions when copying.
            If ($ValidPath -ne $False)
            {
                $DestinationFolder_polybase = $DestinationFolder + '\Polybase\'
                Copy-Item $polybase_path $DestinationFolder
                Get-ChildItem $polybase_path -recurse -Exclude $exclude_ext  | where-object {$_.length -lt 1073741824} | Copy-Item -Destination $DestinationFolder_polybase 2>> $error_file | Out-Null
            }

        } catch {
            Write-LogError "Error Collecting Polybase Log Files"
            Write-LogError $_
        }
}

function Getstorport()
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand
    [console]::TreatControlCAsInput = $true

    $collector_name = "StorPort"
    Write-LogInformation "Executing Collector: $collector_name"
    $server = $global:sql_instance_conn_str

    try
    {
        $partial_output_file_name = Create-PartialOutputFilename ($server)
        $partial_error_output_file_name = Create-PartialErrorOutputFilename($server)

        Write-LogDebug "The partial_error_output_file_name is $partial_error_output_file_name" -DebugLogLevel 3
        Write-LogDebug "The partial_output_file_name is $partial_output_file_name" -DebugLogLevel 3

      
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $false
        $output_file = Build-FinalOutputFile -output_file_name $partial_output_file_name -collector_name $collector_name -needExtraQuotes $true -fileExt ".etl"

        $executable = "cmd.exe"
        $argument_list = "/C logman create trace  ""storport"" -ow -o $output_file -p ""Microsoft-Windows-StorPort"" 0xffffffffffffffff 0xff -nb 16 16 -bs 1024 -mode Circular -f bincirc -max 4096 -ets"

        StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden -RedirectStandardOutput $error_file
    }
    catch 
    {
        $mycommand = $MyInvocation.MyCommand
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand failed with error:  $error_msg"
        return
    }
}

function GetHighIOPerfStats () 
{

    Write-LogDebug "Inside" $MyInvocation.MyCommand

    [console]::TreatControlCAsInput = $true

    $server = $global:sql_instance_conn_str

    try {
        $partial_output_file_name = Create-PartialOutputFilename ($server)
        $partial_error_output_file_name = Create-PartialErrorOutputFilename($server)
    
        Write-LogDebug "The partial_error_output_file_name is $partial_error_output_file_name" -DebugLogLevel 3
        Write-LogDebug "The partial_output_file_name is $partial_output_file_name" -DebugLogLevel 3

        #in case CTRL+C is pressed
        HandleCtrlC

        #SQL Server High IO Perf Stats
        $collector_name = "High_IO_Perfstats"
        $input_script = Build-InputScript $global:present_directory $collector_name
        $output_file = Build-FinalOutputFile -output_file_name $partial_output_file_name -collector_name $collector_name -needExtraQuotes $true
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name  -needExtraQuotes $false
        $executable = "sqlcmd.exe"
        $argument_list = "-S" + $server + " -E -Hsqllogscout -w8000 -o" + $output_file + " -i" + $input_script
        Write-LogInformation "Executing Collector: $collector_name"
        
        StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden -RedirectStandardError $error_file
        
    }
    catch {
        $mycommand = $MyInvocation.MyCommand
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand failed with error:  $error_msg"
        return 
    }

}

function GetSQLAssessmentAPI() 
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand

    [console]::TreatControlCAsInput = $true

    $server = $global:sql_instance_conn_str

    try 
    {

        $partial_output_file_name = Create-PartialOutputFilename ($server)
        $partial_error_output_file_name = Create-PartialErrorOutputFilename($server)
    
        Write-LogDebug "The partial_error_output_file_name is $partial_error_output_file_name" -DebugLogLevel 3
        Write-LogDebug "The partial_output_file_name is $partial_output_file_name" -DebugLogLevel 3

        #in case CTRL+C is pressed
        HandleCtrlC


        $collector_name = "SQLAssessmentAPI"
        Write-LogInformation "Executing Collector: $collector_name"
        $output_file = Build-FinalOutputFile -output_file_name $partial_output_file_name -collector_name $collector_name -needExtraQuotes $false

        if (Get-Module -ListAvailable -Name sqlserver)
        {
            if ((Get-Module -ListAvailable -Name sqlserver).exportedCommands.Values | Where-Object name -EQ "Invoke-SqlAssessment")
            {
                Write-LogDebug "Invoke-SqlAssessment() function present" -DebugLogLevel 3
                Get-SqlInstance -ServerInstance $server | Invoke-SqlAssessment -FlattenOutput | Out-File $output_file
            } 
            else 
            {
                Write-LogDebug "Invoke-SqlAssessment() function NOT present" -DebugLogLevel 3
            }

        }
        else
        {
                Write-LogWarning "SQLServer PS module not installed. Will not collect $collector_name"
        }
    
    }

    catch 
    {
        $mycommand = $MyInvocation.MyCommand
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand failed with error:  $error_msg"
        return
    }
}

function GetUserRights () 
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand

    $server = $global:sql_instance_conn_str

    $userRights = @(
        [PSCustomObject]@{Constant="SeTrustedCredManAccessPrivilege"; Description="Access Credential Manager as a trusted caller"}
        ,[PSCustomObject]@{Constant="SeNetworkLogonRight"; Description="Access this computer from the network"}
        ,[PSCustomObject]@{Constant="SeTcbPrivilege"; Description="Act as part of the operating system"}
        ,[PSCustomObject]@{Constant="SeMachineAccountPrivilege"; Description="Add workstations to domain"}
        ,[PSCustomObject]@{Constant="SeIncreaseQuotaPrivilege"; Description="Adjust memory quotas for a process"}
        ,[PSCustomObject]@{Constant="SeInteractiveLogonRight"; Description="Allow log on locally"}
        ,[PSCustomObject]@{Constant="SeRemoteInteractiveLogonRight"; Description="Allow log on through Remote Desktop Services"}
        ,[PSCustomObject]@{Constant="SeBackupPrivilege"; Description="Back up files and directories"}
        ,[PSCustomObject]@{Constant="SeChangeNotifyPrivilege"; Description="Bypass traverse checking"}
        ,[PSCustomObject]@{Constant="SeSystemtimePrivilege"; Description="Change the system time"}
        ,[PSCustomObject]@{Constant="SeTimeZonePrivilege"; Description="Change the time zone"}
        ,[PSCustomObject]@{Constant="SeCreatePagefilePrivilege"; Description="Create a pagefile"}
        ,[PSCustomObject]@{Constant="SeCreateTokenPrivilege"; Description="Create a token object"}
        ,[PSCustomObject]@{Constant="SeCreateGlobalPrivilege"; Description="Create global objects"}
        ,[PSCustomObject]@{Constant="SeCreatePermanentPrivilege"; Description="Create permanent shared objects"}
        ,[PSCustomObject]@{Constant="SeCreateSymbolicLinkPrivilege"; Description="Create symbolic links"}
        ,[PSCustomObject]@{Constant="SeDebugPrivilege"; Description="Debug programs"}
        ,[PSCustomObject]@{Constant="SeDenyNetworkLogonRight"; Description="Deny access to this computer from the network"}
        ,[PSCustomObject]@{Constant="SeDenyBatchLogonRight"; Description="Deny log on as a batch job"}
        ,[PSCustomObject]@{Constant="SeDenyServiceLogonRight"; Description="Deny log on as a service"}
        ,[PSCustomObject]@{Constant="SeDenyInteractiveLogonRight"; Description="Deny log on locally"}
        ,[PSCustomObject]@{Constant="SeDenyRemoteInteractiveLogonRight"; Description="Deny log on through Remote Desktop Services"}
        ,[PSCustomObject]@{Constant="SeEnableDelegationPrivilege"; Description="Enable computer and user accounts to be trusted for delegation"}
        ,[PSCustomObject]@{Constant="SeRemoteShutdownPrivilege"; Description="Force shutdown from a remote system"}
        ,[PSCustomObject]@{Constant="SeAuditPrivilege"; Description="Generate security audits"}
        ,[PSCustomObject]@{Constant="SeImpersonatePrivilege"; Description="Impersonate a client after authentication"}
        ,[PSCustomObject]@{Constant="SeIncreaseWorkingSetPrivilege"; Description="Increase a process working set"}
        ,[PSCustomObject]@{Constant="SeIncreaseBasePriorityPrivilege"; Description="Increase scheduling priority"}
        ,[PSCustomObject]@{Constant="SeLoadDriverPrivilege"; Description="Load and unload device drivers"}
        ,[PSCustomObject]@{Constant="SeLockMemoryPrivilege"; Description="Lock pages in memory"}
        ,[PSCustomObject]@{Constant="SeBatchLogonRight"; Description="Log on as a batch job"}
        ,[PSCustomObject]@{Constant="SeServiceLogonRight"; Description="Log on as a service"}
        ,[PSCustomObject]@{Constant="SeSecurityPrivilege"; Description="Manage auditing and security log"}
        ,[PSCustomObject]@{Constant="SeRelabelPrivilege"; Description="Modify an object label"}
        ,[PSCustomObject]@{Constant="SeSystemEnvironmentPrivilege"; Description="Modify firmware environment values"}
        ,[PSCustomObject]@{Constant="SeDelegateSessionUserImpersonatePrivilege"; Description="Obtain an impersonation token for another user in the same session"}
        ,[PSCustomObject]@{Constant="SeManageVolumePrivilege"; Description="Perform volume maintenance tasks"}
        ,[PSCustomObject]@{Constant="SeProfileSingleProcessPrivilege"; Description="Profile single process"}
        ,[PSCustomObject]@{Constant="SeSystemProfilePrivilege"; Description="Profile system performance"}
        ,[PSCustomObject]@{Constant="SeUndockPrivilege"; Description="Remove computer from docking station"}
        ,[PSCustomObject]@{Constant="SeAssignPrimaryTokenPrivilege"; Description="Replace a process level token"}
        ,[PSCustomObject]@{Constant="SeRestorePrivilege"; Description="Restore files and directories"}
        ,[PSCustomObject]@{Constant="SeShutdownPrivilege"; Description="Shut down the system"}
        ,[PSCustomObject]@{Constant="SeSyncAgentPrivilege"; Description="Synchronize directory service data"}
        ,[PSCustomObject]@{Constant="SeTakeOwnershipPrivilege"; Description="Take ownership of files or other objects"}
        ,[PSCustomObject]@{Constant="SeUnsolicitedInputPrivilege"; Description="Read unsolicited input from a terminal device"}
    )

    try {

        $collectorData = New-Object System.Text.StringBuilder
        [void]$collectorData.AppendLine("Defined User Rights")
        [void]$collectorData.AppendLine("===================")
        [void]$collectorData.AppendLine()

        $partial_output_file_name = Create-PartialOutputFilename ($server)
        $partial_error_output_file_name = Create-PartialErrorOutputFilename($server)
    
        Write-LogDebug "The partial_error_output_file_name is $partial_error_output_file_name" -DebugLogLevel 3
        Write-LogDebug "The partial_output_file_name is $partial_output_file_name" -DebugLogLevel 3

        #Linked Server configuration
        $collector_name = "UserRights"
        #$input_script = Build-InputScript $global:present_directory $collector_name
        $output_file = Build-FinalOutputFile -output_file_name $partial_output_file_name -collector_name $collector_name -needExtraQuotes $false
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $false
        $executable = "$Env:windir\system32\secedit.exe"
        $argument_list = "/export /areas USER_RIGHTS /cfg `"$output_file.tmp`" /quiet"

        Write-LogDebug "The output_file is $output_file" -DebugLogLevel 5
        Write-LogDebug "The error_file is $error_file" -DebugLogLevel 5
        Write-LogDebug "The executable is $executable" -DebugLogLevel 5
        Write-LogDebug "The argument_list is $argument_list" -DebugLogLevel 5

        Write-LogInformation "Executing Collector: $collector_name"
        StartNewProcess -FilePath  $executable -ArgumentList $argument_list -WindowStyle Hidden -RedirectStandardError $error_file -Wait $true

        #$allRights = (Get-Content -Path "$output_file.tmp" | Select-String '^(Se\S+) = (\S+)')
        $allRights = Get-Content -Path "$output_file.tmp"
        Remove-Item -Path "$output_file.tmp" #delete the temporary file created by SECEDIT.EXE

        foreach($right in $userRights){

            Write-LogDebug "Processing " $right.Constant -DebugLogLevel 5
            
            $line = $allRights | Where-Object {$_.StartsWith($right.Constant)}

            [void]$collectorData.AppendLine($right.Description)
            [void]$collectorData.AppendLine("=" * $right.Description.Length)

            if($null -eq $line){
                
                [void]$collectorData.AppendLine("0 account(s) with the " + $right.Constant + " user right:")
                
            } else {

                $users = $line.Split(" = ")[3].Split(",")
                [void]$collectorData.AppendLine([string]$users.Count + " account(s) with the " + $right.Constant + " user right:")
                
                $resolvedUserNames = New-Object -TypeName System.Collections.ArrayList

                foreach ($user in $users) {
                    
                    if($user[0] -eq "*"){
                        
                        $SID = New-Object -TypeName System.Security.Principal.SecurityIdentifier -ArgumentList (($user.Substring(1)))

                        try { #some account lookup may fail hence then nested try-catch
                            $account = $SID.Translate([Security.Principal.NTAccount]).Value    
                        } catch {
                            $account = $user.Substring(1) + " <== SID Lookup failed with: " + $_.Exception.InnerException.Message
                        }
                        
                        [void]$resolvedUserNames.Add($account)

                    } else {
                        
                        $NTAccount = New-Object -TypeName System.Security.Principal.NTAccount -ArgumentList ($user)

                        try {
                            
                            #try to get SID from account, then translate SID back to account
                            #done to mimic SDP behavior adding hostname to local accounts
                            $SID = New-Object -TypeName System.Security.Principal.SecurityIdentifier -ArgumentList (($NTAccount.Translate([Security.Principal.SecurityIdentifier]).Value))
                            $account = $SID.Translate([Security.Principal.NTAccount]).Value
                            [void]$resolvedUserNames.Add($account)

                        } catch {

                            #if the above fails we just add user name as fail-safe
                            [void]$resolvedUserNames.Add($user)

                        }

                    }

                }

                [void]$resolvedUserNames.Sort()
                [void]$collectorData.AppendLine($resolvedUserNames -Join "`r`n")
                [void]$collectorData.AppendLine("All accounts enumerated")

            }

            [void]$collectorData.AppendLine()
            [void]$collectorData.AppendLine()

        }

        Add-Content -Path $output_file -Value $collectorData.ToString()
        
    }
    catch {
        $mycommand = $MyInvocation.MyCommand 
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand failed with error:  $error_msg"
        return
    }

}

function validateUserInput([string[]]$AllInput)
{
    $ExpectedValidInput =  $AllInput[0]
    $userinput =  $AllInput[1]
    $HelpMessage = $AllInput[2]

    $ValidId = $false

    while(($ValidId -eq $false) )
    {
        try
        {    
            $userinput = $userinput.ToUpper()
            if ($ExpectedValidInput.Contains($userinput))
            {
                $userinput = [convert]::ToInt32($userinput)
                $ValidId = $true
                $ret = $userinput
                return $ret 
            }
            else
            {
                $userinput = Read-Host "$HelpMessage"
                $userinput = $userinput.ToUpper()
            }
        }

        catch [FormatException]
        {
            try
            {    
                $userinput = [convert]::ToString(($userinput))
                $userinput = $userinput.ToUpper()

                try
                {
                    $userinput =  $userinput.Trim()
                    $ExpectedValidInput =  $AllInput[0] # re-initalyze the vairable as in second attempt it becomes empty
                    If ($userinput.Length -gt 0 -and $userinput -match '[a-zA-Z]' -and $ExpectedValidInput.Contains($userinput))
                    {
                        $userinput = $userinput.ToUpper()
                        $ValidId = $true
                        $ret = $userinput
                        return $ret 
                    }
                    else
                    {
                        $userinput = Read-Host "$HelpMessage"
                        $ValidId = $false
                        continue
                    }
                }
                catch
                {
                    $ValidId = $false
                    continue 
                }
            }

            catch [FormatException]
                {
                    $ValidId = $false
                    continue 
                }
            continue 
        }
    }    
}

function IsCollectingXevents()
{
    if ( ($true -eq (IsScenarioEnabled -scenarioBit $global:generalperfBit)) `
    -or ($true -eq (IsScenarioEnabled -scenarioBit $global:detailedperfBit)) `
    -or ($true -eq (IsScenarioEnabled -scenarioBit $global:alwaysonBit)) `
    -or ($true -eq (IsScenarioEnabled -scenarioBit $global:BackupRestoreBit))
    )
    {
        return $true
    }
    else 
    {
        return $false
    }

}

function Confirm-WritePermsStartupAccount ()
{
    Write-LogDebug "inside" $MyInvocation.MyCommand

    [console]::TreatControlCAsInput = $true


    if ($global:sql_instance_conn_str -eq $NO_INSTANCE_NAME)
    {
        Write-LogWarning "No SQL Server instance found. Write permissions check for XEvent is not necessary"
        return $true
    }

    # if interactive prompt is disabled, skip this check
    if ($InteractivePrompts -eq "Quiet")
    {
        Write-LogDebug "Running in QUIET mode" -DebugLogLevel 4
        return $true  #proceed with execution
    }

    $host_name = hostname

    $instance_name = $global:sql_instance_conn_str.Substring($global:sql_instance_conn_str.IndexOf("\") + 1)


    if ($instance_name -ne $host_name)
    {
        $sqlservicename = "MSSQL"+"$"+$instance_name
    }
    else
    {
        $sqlservicename = "MSSQLServer"
    }

    #if we are not running an XEvent collector, exit this function as we don't need to raise warning. Return $true to proceed with execution
    if ($false -eq (IsCollectingXevents ))
    {
        return $true
    }


    $startup_account = Get-wmiobject win32_service -Filter "name='$sqlservicename' " | Select-Object  startname
    $startup_account_name = $startup_account.startname

    HandleCtrlC

    Write-LogWarning "At least one of the selected '$global:ScenarioChoice' scenarios collects Xevent traces" 
    Write-LogWarning "The service account '$startup_account_name' for SQL Server instance '$global:sql_instance_conn_str' must have write/modify permissions on the '$global:output_folder' folder"
    Write-LogWarning "The easiest way to validate write permissions on the folder is to test-run SQL LogScout for 1-2 minutes and ensure an *.XEL file exists that you can open and read in SSMS"
    
    $ValidInput = "Y","N"
    $confirmAccess = Read-Host "Continue?> (y/n)" -CustomLogMessage "Access verification Console input:"
    $HelpMessage = "Please enter a valid input (Y or N)"

    $AllInput = @()
    $AllInput += , $ValidInput
    $AllInput += , $confirmAccess
    $AllInput += , $HelpMessage

    $confirmAccess = validateUserInput($AllInput)

    if ($confirmAccess -eq "Y")
    { 
        #user chose to proceed
        return $true
    } 
    else 
    { 
        #user chose to abort
        return $false
    }
}


function DetailedPerfCollectorWarning ()
{
    Write-LogDebug "inside" $MyInvocation.MyCommand
    
    #if we are not running an detailed XEvent collector (scenario 2), exit this function as we don't need to raise warning

    Write-LogWarning "The 'DetailedPerf' scenario collects statement-level, detailed Xevent traces. This can impact the performance of SQL Server"

    if ($InteractivePrompts -eq "Quiet") 
    {
        Write-LogDebug "Running in QUIET mode" -DebugLogLevel 4
        Start-Sleep 5
        return $true
    }
    
    $ValidInput = "Y","N"
    $confirmAccess = Read-Host "Are you sure you would like to Continue?> (y/n)" -CustomLogMessage "Detailed Perf Warning Console input:"
    $HelpMessage = "Please enter a valid input (Y or N)"

    $AllInput = @()
    $AllInput += , $ValidInput
    $AllInput += , $confirmAccess
    $AllInput += , $HelpMessage

    $confirmAccess = validateUserInput($AllInput)

    Write-LogDebug "ConfirmAccess = $confirmAccess" -DebugLogLevel 3

    if ($confirmAccess -eq 'Y')
    { 
        #user chose to proceed
        return $true
    } 
    else 
    { 
        #user chose to abort
        return $false
    }
}



function Invoke-CommonCollectors()
{
    [console]::TreatControlCAsInput = $true
    Write-LogDebug "Inside" $MyInvocation.MyCommand
    Write-LogInformation "Collecting logs for '$BASIC_NAME' scenario" -ForegroundColor Green

  
    GetTaskList 
    GetFilterDrivers
    GetSysteminfoSummary

    if ($global:sql_instance_conn_str -eq $NO_INSTANCE_NAME)
    {
        Write-LogWarning "No SQL Server instance specified, thus skipping execution of SQL Server-based collectors"
    }
    else 
    {
        GetMisciagInfo
        HandleCtrlC
        GetSQLErrorLogsDumpsSysHealth
        Start-Sleep -Seconds 2
        GetPolybaseLogs
        HandleCtrlC
        GetSQLVSSWriterLog
        HandleCtrlC
        GetSQLAssessmentAPI
    }
    
    GetUserRights
    GetRunningDrivers
    

    HandleCtrlC
    Start-Sleep -Seconds 1

    
    GetPowerPlan
    GetWindowsHotfixes
    
    
    HandleCtrlC
    Start-Sleep -Seconds 2
    GetEventLogs

    if (IsClustered)
    {
        GetClusterInformation
    } 

} 

function Invoke-GeneralPerfScenario()
{
    [console]::TreatControlCAsInput = $true
    Write-LogDebug "Inside" $MyInvocation.MyCommand
    Write-LogInformation "Collecting logs for '$GENERALPERF_NAME' scenario" -ForegroundColor Green
    
    
    GetPerfmonCounters
    
    if ($global:sql_instance_conn_str -eq $NO_INSTANCE_NAME)
    {
        Write-LogWarning "No SQL Server instance specified, thus skipping execution of SQL Server-based collectors"
    }
    else 
    {

        HandleCtrlC
        Start-Sleep -Seconds 1
        GetXeventsGeneralPerf
        GetRunningProfilerXeventTraces 

        HandleCtrlC
        Start-Sleep -Seconds 2
        GetHighCPUPerfStats
        GetPerfStats 

        HandleCtrlC
        Start-Sleep -Seconds 2
        GetPerfStatsSnapshot 
        GetQDSInfo 

        HandleCtrlC
        Start-Sleep -Seconds 2
        GetTempdbSpaceLatchingStats 
        GetLinkedServerInfo 
        GetServiceBrokerInfo
    } 
}

function Invoke-DetailedPerfScenario()
{
    [console]::TreatControlCAsInput = $true
    Write-LogDebug "Inside" $MyInvocation.MyCommand
    Write-LogInformation "Collecting logs for '$DETAILEDPERF_NAME' scenario" -ForegroundColor Green

    
    GetPerfmonCounters
    
    if ($global:sql_instance_conn_str -eq $NO_INSTANCE_NAME)
    {
        Write-LogWarning "No SQL Server instance specified, thus skipping execution of SQL Server-based collectors"
    }
    else 
    {
        HandleCtrlC
        Start-Sleep -Seconds 1
        GetXeventsDetailedPerf
        GetRunningProfilerXeventTraces 

        HandleCtrlC
        Start-Sleep -Seconds 2
        GetHighCPUPerfStats 
        GetPerfStats 
        
        HandleCtrlC
        Start-Sleep -Seconds 2
        GetPerfStatsSnapshot 
        GetQDSInfo 

        HandleCtrlC
        Start-Sleep -Seconds 2
        GetTempdbSpaceLatchingStats
        GetLinkedServerInfo 
        GetServiceBrokerInfo
    } 
}

function Invoke-LightPerfScenario ()
{
    [console]::TreatControlCAsInput = $true
    Write-LogDebug "Inside" $MyInvocation.MyCommand
    Write-LogInformation "Collecting logs for '$LIGHTPERF_NAME' scenario" -ForegroundColor Green
    
    
    GetPerfmonCounters
    
    if ($global:sql_instance_conn_str -eq $NO_INSTANCE_NAME)
    {
        Write-LogWarning "No SQL Server instance specified, thus skipping execution of SQL Server-based collectors"
    }
    else 
    {

        HandleCtrlC
        Start-Sleep -Seconds 1
        GetRunningProfilerXeventTraces 

        HandleCtrlC
        Start-Sleep -Seconds 2
        GetHighCPUPerfStats
        GetPerfStats 

        HandleCtrlC
        Start-Sleep -Seconds 2
        GetPerfStatsSnapshot 
        GetQDSInfo 

        HandleCtrlC
        Start-Sleep -Seconds 2
        GetTempdbSpaceLatchingStats 
        GetLinkedServerInfo 
        GetServiceBrokerInfo
    } 
}
function Invoke-AlwaysOnScenario()
{
    [console]::TreatControlCAsInput = $true
    Write-LogDebug "Inside" $MyInvocation.MyCommand
    Write-LogInformation "Collecting logs for '$ALWAYSON_NAME' scenario" -ForegroundColor Green
    

    if ($global:sql_instance_conn_str -eq $NO_INSTANCE_NAME)
    {
        Write-LogWarning "No SQL Server instance specified, thus skipping execution of SQL Server-based collectors"
    }
    else 
    {
        HandleCtrlC
        GetAlwaysOnDiag
        GetXeventsAlwaysOnMovement
        GetPerfmonCounters
        GetAlwaysOnHealthXel
    }
}

function Invoke-ReplicationScenario()
{
    [console]::TreatControlCAsInput = $true
    Write-LogDebug "Inside" $MyInvocation.MyCommand
    Write-LogInformation "Collecting logs for '$REPLICATION_NAME' scenario" -ForegroundColor Green
        
    if ($global:sql_instance_conn_str -eq $NO_INSTANCE_NAME)
    {
        Write-LogWarning "No SQL Server instance specified, thus skipping execution of SQL Server-based collectors"
    }
    else 
    {
        HandleCtrlC
        Start-Sleep -Seconds 2
        GetReplMetadata 
        GetChangeDataCaptureInfo 
        GetChangeTracking 
    }
}

function Invoke-DumpMemoryScenario
{  
    [console]::TreatControlCAsInput = $true
    Write-LogDebug "Inside" $MyInvocation.MyCommand
    Write-LogInformation "Collecting logs for '$DUMPMEMORY_NAME' scenario" -ForegroundColor Green

    #invoke memory dump facility
    GetMemoryDumps

}


function Invoke-NetworkScenario()
{
    [console]::TreatControlCAsInput = $true
    Write-LogDebug "Inside" $MyInvocation.MyCommand
    Write-LogInformation "Collecting logs for '$NETWORKTRACE_NAME' scenario" -ForegroundColor Green

    GetNetworkTrace 

}





function Invoke-WPRScenario()
{
    [console]::TreatControlCAsInput = $true
    Write-LogDebug "Inside" $MyInvocation.MyCommand
    Write-LogInformation "Collecting logs for '$WPR_NAME' scenario" -ForegroundColor Green

    Write-LogWarning "WPR is a resource-intensive data collection process! It will run for 15 seconds only. Use under Microsoft guidance."
    
    $ValidInput = "Y","N"
    $WPR_YesNo = Read-Host "Do you want to proceed - Yes ('Y') or No ('N') >" -CustomLogMessage "WPR_YesNo Console input:"
    $HelpMessage = "Please enter a valid input (Y or N)"

    $AllInput = @()
    $AllInput += , $ValidInput
    $AllInput += , $WPR_YesNo
    $AllInput += , $HelpMessage
  
    $WPR_YesNo = validateUserInput($AllInput)
    $WPR_YesNo = $WPR_YesNo.ToUpper()

    if ($WPR_YesNo -eq "N") 
    {
        Write-LogInformation "You aborted the WRP data collection process"
        exit
    }
        
    #invoke the functionality
    GetWPRTrace 
}

function Invoke-MemoryScenario 
{
    [console]::TreatControlCAsInput = $true
    Write-LogDebug "Inside" $MyInvocation.MyCommand
    Write-LogInformation "Collecting logs for '$MEMORY_NAME' scenario" -ForegroundColor Green


    
    if ($global:sql_instance_conn_str -eq $NO_INSTANCE_NAME)
    {
        Write-LogWarning "No SQL Server instance specified, thus skipping execution of SQL Server-based collectors"
    }
    else 
    {
        HandleCtrlC
        Start-Sleep -Seconds 2
        GetMemoryLogs 
        GetPerfmonCounters
    }
}

function Invoke-SetupScenario 
{
    [console]::TreatControlCAsInput = $true
    Write-LogDebug "Inside" $MyInvocation.MyCommand
    Write-LogInformation "Collecting logs for '$SETUP_NAME' scenario" -ForegroundColor Green
    
    HandleCtrlC
    GetSQLSetupLogs
}

function Invoke-BackupRestoreScenario()
{
    [console]::TreatControlCAsInput = $true
    Write-LogDebug "Inside" $MyInvocation.MyCommand
    Write-LogInformation "Collecting logs for '$BACKUPRESTORE_NAME' scenario" -ForegroundColor Green

    GetXeventBackupRestore

    HandleCtrlC
    
    GetBackupRestoreTraceFlags

    # adding Perfmon counter collection to this scenario
    GetPerfmonCounters

    HandleCtrlC

    GetSQLVSSWriterLog

    GetVSSAdminLogs
}


function Invoke-IOScenario()
{
    [console]::TreatControlCAsInput = $true
    Write-LogDebug "Inside" $MyInvocation.MyCommand
    Write-LogInformation "Collecting logs for '$IO_NAME' scenario" -ForegroundColor Green

    Getstorport
    GetHighIOPerfStats
    HandleCtrlC
    
    # adding Perfmon counter collection to this scenario
    GetPerfmonCounters

    HandleCtrlC

}


function Invoke-OnShutDown()
{
    [console]::TreatControlCAsInput = $true
    Write-LogDebug "Inside" $MyInvocation.MyCommand

    # collect Basic collectors on shutdown
    if (IsScenarioEnabled -scenarioBit $global:basicBit -logged $true)
    {
        Invoke-CommonCollectors 
    }

    HandleCtrlC

    # PerfstatsSnapshot needs to be collected on shutdown so people can perform comparative analysis
    
    if ( ($true -eq (IsScenarioEnabled -scenarioBit $global:generalperfBit -logged $true)) `
    -or ($true -eq (IsScenarioEnabled -scenarioBit $global:detailedperfBit -logged $true)) )
    {
        GetPerfStatsSnapshot -TimeOfCapture "Shutdown"
    }

    HandleCtrlC

    # CDC and CT needs to be collected on shutdown so people can perform comparative analysis
    if (IsScenarioEnabled -scenarioBit $global:replBit -logged $true)
    {
        GetChangeDataCaptureInfo -TimeOfCapture "Shutdown"
        GetChangeTracking -TimeOfCapture "Shutdown"
    }
}

function StartStopTimeForDiagnostics ([string] $timeParam, [string] $startOrStop="")
{
    [console]::TreatControlCAsInput = $true

    Write-LogDebug "Inside" $MyInvocation.MyCommand

    try
    {
        if ($timeParam -eq "0000")
        {
            Write-LogDebug "No start/end time specified for diagnostics" -DebugLogLevel 2
            return
        }
        
        $datetime = $timeParam #format "2020-10-27 19:26:00"
        
        $formatted_date_time = [DateTime]::Parse($datetime, [cultureinfo]::InvariantCulture);
        
        Write-LogDebug "The formatted time is: $formatted_date_time" -DebugLogLevel 3
        Write-LogDebug ("The current time is:" + (Get-Date) ) -DebugLogLevel 3
    
        #wait until time is reached
        if ($formatted_date_time -gt (Get-Date))
        {
            Write-LogWarning "Waiting until the specified $startOrStop time '$timeParam' is reached...(CTRL+C to stop - wait for response)"
        }
        else
        {
            Write-LogInformation "The specified $startOrStop time '$timeParam' is in the past. Continuing execution."     
        }
        

        [int] $increment = 0
        [int] $sleepInterval = 2

        while ((Get-Date) -lt (Get-Date $formatted_date_time)) 
        {
            Start-Sleep -Seconds $sleepInterval

            if ($Host.UI.RawUI.KeyAvailable -and (3 -eq [int]$Host.UI.RawUI.ReadKey("AllowCtrlC,IncludeKeyUp,IncludeKeyDown,NoEcho").Character))
            {
               Write-LogWarning "*******************"
               Write-LogWarning "You pressed CTRL-C. Stopped waiting..."
               Write-LogWarning "*******************"
               break
            }

            $increment += $sleepInterval
            
            if ($increment % 120 -eq 0)
            {
                $startDate = (Get-Date)
                $endDate =(Get-Date $formatted_date_time)
                $delta = (New-TimeSpan -Start $startDate -End $endDate).TotalMinutes
                Write-LogWarning "$delta minutes remain"
            }
        }


    }
    catch 
    {
        $function_name = $MyInvocation.MyCommand
        $error_msg = $PSItem.Exception.Message 
        Write-Host "'$function_name' function failed with error:  $error_msg"
        return
    }

}

function ArbitrateSelectedScenarios ([bool] $Skip = $false)
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand

    if ($true -eq $Skip)
    {
        return
    }

    #set up Basic bit to ON for several scenarios

    if ( ($false -eq (IsScenarioEnabled -scenarioBit $global:generalperfBit)) `
    -or ($false -eq (IsScenarioEnabled -scenarioBit $global:detailedperfBit)) `
    -or ($false -eq (IsScenarioEnabled -scenarioBit $global:replBit)) `
    -or ($false -eq (IsScenarioEnabled -scenarioBit $global:memoryBit)) `
    -or ($false -eq (IsScenarioEnabled -scenarioBit $global:setupBit)) `
    -or ($false -eq (IsScenarioEnabled -scenarioBit $global:BackupRestoreBit)) `
    -or ($false -eq (IsScenarioEnabled -scenarioBit $global:IOBit)) `
    -or ($false -eq (IsScenarioEnabled -scenarioBit $global:LightPerfBit))
    )
    {
        EnableScenario -pScenarioBit $global:basicBit
    }
    
    #if generalperf and detailedperf are both enabled , disable general perf and keep detailed (which is a superset)
    if (($true -eq (IsScenarioEnabled -scenarioBit $global:generalperfBit )) `
    -and ($true -eq (IsScenarioEnabled -scenarioBit $global:detailedperfBit  )) )
    {
        DisableScenario -pScenarioBit $global:generalperfBit
        Write-LogWarning "Disabling '$GENERALPERF_NAME' scenario since '$DETAILEDPERF_NAME' is already enabled"
    }

    #if lightperf and detailedperf are both enabled , disable general perf and keep detailed (which is a superset)
    if (
        ($true -eq (IsScenarioEnabled -scenarioBit $global:LightPerfBit )) `
        -and ( ($true -eq (IsScenarioEnabled -scenarioBit $global:detailedperfBit ) )  -or ($true -eq (IsScenarioEnabled -scenarioBit $global:generalperfBit ) ))
    )
    {
        DisableScenario -pScenarioBit $global:LightPerfBit
        Write-LogWarning "Disabling '$LIGHTPERF_NAME' scenario since '$DETAILEDPERF_NAME' or '$GENERALPERF_NAME' is already enabled"
    }


    #limit WPR to run only with Basic
    if ($true -eq (IsScenarioEnabled -scenarioBit $global:wprBit )) 
    {
        #check if Basic is enabled
        $basic_enabled = IsScenarioEnabled -scenarioBit $global:basicBit

        #reset scenario bit to 0 to turn off all collection
        Write-LogWarning "The '$WPR_NAME' scenario is only allowed to run together with Basic scenario. All other scenarios will be disabled" 
        DisableAllScenarios
        Start-Sleep 5
        
        #enable WPR
        EnableScenario -pScenarioBit $global:wprBit
        
        #if Basic was enabled earlier, turn it back on after all was reset
        if ($true -eq $basic_enabled)
        {
            EnableScenario -pScenarioBit $global:basicBit
        }
        return
    }

}

function Select-Scenario()
{
    [console]::TreatControlCAsInput = $true

    Write-LogDebug "Inside" $MyInvocation.MyCommand

    #check if a timer parameter set is passed and sleep until specified time
    StartStopTimeForDiagnostics -timeParam $DiagStartTime -startOrStop "start" 



    Write-LogInformation ""
    Write-LogInformation "Initiating diagnostics collection... " -ForegroundColor Green

    #[string[]]$ScenarioArray = "Basic (no performance data)","General Performance (recommended for most cases)","Detailed Performance (statement level and query plans)","Replication","AlwaysON", "Network Trace","Memory", "Generate Memory dumps","Windows Performance Recorder (WPR)", "Setup", "Backup and Restore","IO"
    $scenarioIntRange = 0..($ScenarioArray.Length -1)  #dynamically count the values in array and create a range

    [int[]]$scenIntArray =@()

    #check if the first element of scenarioChoice array contains a prameter or is empty - if so, proceed to menu
    if (($Scenario[0] -eq "MenuChoice") -or ($Scenario[0] -eq [String]::Empty))
    {
        Write-LogInformation "Please select one of the following scenarios:`n"
        Write-LogInformation ""
        Write-LogInformation "ID`t Scenario"
        Write-LogInformation "--`t ---------------"

        for($i=0; $i -lt $ScenarioArray.Count;$i++)
        {
            Write-LogInformation $i "`t" $ScenarioArray[$i]
        }

        $isInt = $false
        $ScenarioIdInt = 777
        $WantDetailedPerf = $false

        

        
        while(($isInt -eq $false) -or ($ValidId -eq $false) -or ($WantDetailedPerf -eq $false))
        {
            Write-LogInformation ""
            Write-LogWarning "Type one or more Scenario IDs (separated by '+') for which you want to collect diagnostic data. Then press Enter" 

            $ScenIdStr = Read-Host "Scenario ID(s) e.g. 0+3+6>" -CustomLogMessage "Scenario Console input:"
            [string[]]$scenStrArray = $ScenIdStr.Split('+')
            
            Write-LogDebug "You have selected the following scenarios (str): $scenStrArray" -DebugLogLevel 3

            
            
            foreach($int_string in $scenStrArray) 
            {
                try 
                {
                    #convert the strings to integers and add to int array
                    $int_number = [int]::parse($int_string)
                    $scenIntArray+=$int_number

                    $isInt = $true
                    if($int_string -notin ($scenarioIntRange))
                    {
                        $ValidId = $false
                        $scenIntArray =@()
                        Write-LogError "The ID entered '",$ScenIdStr,"' is not in the list "
                    }
                    else 
                    {
                        $ValidId = $true    
                    }
                }
                catch 
                {
                    Write-LogError "The value entered for ID '",$int_string,"' is not an integer"
                    $scenIntArray =@()
                    $isInt = $false
                }
            }

            
            #warn users when they select the Detailed perf scenario about perf impact. No warning if all others
            if ($int_number -eq $DetailedPerfScenId) 
            {
                # if true, proceed, else, disable scenario and try again
                $WantDetailedPerf = DetailedPerfCollectorWarning

                if ($false -eq $WantDetailedPerf)
                {
                    #once user declines, need to clear the selected bit
                    DisableScenario -pScenarioBit $global:detailedperfBit
                    Write-LogWarning "You selected not to proceed with Detailed Perf scenario. Please choose again"    
                }
            }
            else 
            {
                $WantDetailedPerf = $true    
            }
            
        } #end of WHILE to select scenario

            #remove duplicate entries
            $scenIntArray = $scenIntArray | Select-Object -Unique 

            Write-LogDebug "You have selected the following scearnios (int): $scenIntArray" -DebugLogLevel 3
            
            foreach ($ScenarioIdInt in $scenIntArray) 
            {
                switch ($ScenarioIdInt) 
                {
                    $BasicScenId 
                    { 
                        EnableScenario -pScenarioBit $global:basicBit
                    }
                    $GeneralPerfScenId 
                    {
                        EnableScenario -pScenarioBit $global:generalperfBit
                        
                    }
                    $DetailedPerfScenId 
                    { 
                        EnableScenario -pScenarioBit $global:detailedperfBit

                    }
                    $ReplicationScenId
                    { 
                        EnableScenario -pScenarioBit $global:replBit
                        
                    }
                    $AlwaysOnScenId
                    { 
                        EnableScenario -pScenarioBit $global:alwaysonBit
                    }
                    $NetworkTraceScenId
                    { 
                        EnableScenario -pScenarioBit $global:networktraceBit
                    }
                    $MemoryScenId
                    { 
                        EnableScenario -pScenarioBit $global:memoryBit

                    }
                    $DumpMemoryScenId
                    { 
                        EnableScenario -pScenarioBit $global:dumpMemoryBit
                    }
                    $WprScenId
                    { 
                        EnableScenario -pScenarioBit $global:wprBit
                    }
                    $SetupScenId
                    { 
                        EnableScenario -pScenarioBit $global:setupBit

                    }
                    $BackupRestoreScenId
                    { 
                        EnableScenario -pScenarioBit $global:BackupRestoreBit

                    }
                    $IOScenId
                    { 
                        EnableScenario -pScenarioBit $global:IOBit

                    }
                    $LightPerfScenId
                    {
                        EnableScenario -pScenarioBit $global:LightPerfBit
                    }
                    Default {
                            Write-LogError "No valid scenario was picked. Not sure why we are here"
                            return $false
                    }
                } # end of Switch
            } #end of foreach    

    } #end of if for using a Scenario menu

    #handle the command-line parameter case
    else 
    {
        $ScenarioArray = $Scenario.Split('+')
        Write-LogDebug "Command-line scenarios selected: $Scenario. Parsed: $ScenarioArray" -DebugLogLevel 3

        #parse startup parameter $Scenario for any values
        foreach ($scenario_name_item in $ScenarioArray) 
        {
            Write-LogDebug "Individual scenario from Scenario param: $scenario_name_item" -DebugLogLevel 5

            # convert the name to a scenario bit
            $bit = ScenarioNameToBit -pScenarioName $scenario_name_item
            EnableScenario -pScenarioBit $bit

            # send a warning for Detailed Perf
            if ($bit -eq $global:detailedperfBit) 
            {
                # if true, proceed, else, exit
                if($false -eq (DetailedPerfCollectorWarning))
                {
                    exit
                }
            }

            
        }
        
    }

    #resolove /arbitrate any scenario inconsistencies, conflicts, illogical choices
    ArbitrateSelectedScenarios 


    #set additional properties to certain scenarios
    Set-AutomaticStop 
    Set-InstanceIndependentCollection 
    Set-PerfmonScenarioEnabled

    Write-LogDebug "Scenario Bit value = $global:scenario_bitvalue" -DebugLogLevel 2
    Write-LogInformation "The scenarios selected are: '$global:ScenarioChoice'"

    return $true
}


function Set-AutomaticStop () 
{
    # this function is invoked when the user does not need to wait for any long-term collectors (like Xevents, Perfmon, Netmon). 
    # Just gather everything and shut down

    Write-LogDebug "Inside" $MyInvocation.MyCommand



    if ((
            ($true -eq (IsScenarioEnabled -scenarioBit $global:basicBit)) `
            -or ($true -eq (IsScenarioEnabled -scenarioBit $global:dumpMemoryBit )) `
            -or ($true -eq (IsScenarioEnabled -scenarioBit $global:wprBit )) `
            -or ($true -eq (IsScenarioEnabled -scenarioBit $global:setupBit )) `
        )  -and
        (
            ($false -eq (IsScenarioEnabled -scenarioBit $global:generalperfBit )) `
            -and ($false -eq (IsScenarioEnabled -scenarioBit $global:detailedperfBit )) `
            -and ($false -eq (IsScenarioEnabled -scenarioBit $global:replBit )) `
            -and ($false -eq (IsScenarioEnabled -scenarioBit $global:alwaysonBit )) `
            -and ($false -eq (IsScenarioEnabled -scenarioBit $global:networktraceBit )) `
            -and ($false -eq (IsScenarioEnabled -scenarioBit $global:memoryBit )) `
            -and ($false -eq (IsScenarioEnabled -scenarioBit $global:BackupRestoreBit )) `
            -and ($false -eq (IsScenarioEnabled -scenarioBit $global:IOBit )) `
            -and ($false -eq (IsScenarioEnabled -scenarioBit $global:LightPerfBit ))
        ) )
    {
        Write-LogInformation "The selected '$global:ScenarioChoice ' collector(s) will stop automatically after logs are gathered" -ForegroundColor Green
        $global:stop_automatically = $true
    }

    
}

function Set-InstanceIndependentCollection () 
{
    # this function is invoked when the data collected does not target a specific SQL instance (e.g. WPR, Netmon, Setup). 

    Write-LogDebug "Inside" $MyInvocation.MyCommand


    if ((
            ($true -eq (IsScenarioEnabled -scenarioBit $global:wprBit )) `
            -or ($true -eq (IsScenarioEnabled -scenarioBit $global:networktraceBit )) `
            -or ($true -eq (IsScenarioEnabled -scenarioBit $global:IOBit ))
            
        )  -and
        (
            ($false -eq (IsScenarioEnabled -scenarioBit $global:generalperfBit )) `
            -and ($false -eq (IsScenarioEnabled -scenarioBit $global:detailedperfBit )) `
            -and ($false -eq (IsScenarioEnabled -scenarioBit $global:alwaysonBit )) `
            -and ($false -eq (IsScenarioEnabled -scenarioBit $global:memoryBit )) `
            -and ($false -eq (IsScenarioEnabled -scenarioBit $global:basicBit )) `
            -and ($false -eq (IsScenarioEnabled -scenarioBit $global:replBit )) `
            -and ($false -eq (IsScenarioEnabled -scenarioBit $global:dumpMemoryBit )) `
            -and ($false -eq (IsScenarioEnabled -scenarioBit $global:setupBit )) `
            -and ($false -eq (IsScenarioEnabled -scenarioBit $global:BackupRestoreBit )) `
        ) )
    {
        Write-LogInformation "The selected '$global:ScenarioChoice' scenario(s) gather logs independent of a SQL instance"
        $global:instance_independent_collection = $true    
    }


   
}


function Set-PerfmonScenarioEnabled()
{
    [console]::TreatControlCAsInput = $true

    Write-LogDebug "Inside" $MyInvocation.MyCommand

    try 
    {
        if ( ($true -eq (IsScenarioEnabled -scenarioBit $global:generalperfBit )) `
        -or ($true -eq (IsScenarioEnabled -scenarioBit $global:detailedperfBit )) `
        -or ($true -eq (IsScenarioEnabled -scenarioBit $global:alwaysonBit )) `
        -or ($true -eq (IsScenarioEnabled -scenarioBit $global:memoryBit )) `
        -or ($true -eq (IsScenarioEnabled -scenarioBit $global:BackupRestoreBit )) `
        -or ($true -eq (IsScenarioEnabled -scenarioBit $global:IOBit )) `
        -or ($true -eq (IsScenarioEnabled -scenarioBit $global:LightPerfBit )) 
        )
        {
            $global:perfmon_scenario_enabled = $true
        }
    }
    catch 
    {
        $function_name = $MyInvocation.MyCommand
        $error_msg = $PSItem.Exception.Message 
        Write-Host "'$function_name' function failed with error:  $error_msg"
        return
    }
    
}



function Start-DiagCollectors ()
{
    [console]::TreatControlCAsInput = $true

    Write-LogDebug "Inside" $MyInvocation.MyCommand

    Write-LogDebug "The ScenarioChoice array contains the following entries: '$global:ScenarioChoice' " -DebugLogLevel 3

    # launch the scenario collectors that are enabled
    # common collectors (basic) will be called on shutdown
    if (IsScenarioEnabled -scenarioBit $global:basicBit -logged $true)
    {
        Write-LogInformation "Basic collectors will execute on shutdown"
    }
    if (IsScenarioEnabled -scenarioBit $global:LightPerfBit -logged $true)
    {
        Invoke-LightPerfScenario
    }
    if (IsScenarioEnabled -scenarioBit $global:generalperfBit -logged $true)
    {
        Invoke-GeneralPerfScenario
    }
    if (IsScenarioEnabled -scenarioBit $global:detailedperfBit -logged $true)
    {
        Invoke-DetailedPerfScenario
    }
    if (IsScenarioEnabled -scenarioBit $global:alwaysonBit -logged $true)
    {
        Invoke-AlwaysOnScenario
    }
    if (IsScenarioEnabled -scenarioBit $global:replBit -logged $true)
    {
        Invoke-ReplicationScenario
    }
    if (IsScenarioEnabled -scenarioBit $global:networktraceBit -logged $true)
    {
        Invoke-NetworkScenario
    }
    if (IsScenarioEnabled -scenarioBit $global:memoryBit -logged $true)
    {
        Invoke-MemoryScenario
    }
    if (IsScenarioEnabled -scenarioBit $global:dumpMemoryBit -logged $true)
    {
        Invoke-DumpMemoryScenario
    }
    if (IsScenarioEnabled -scenarioBit $global:wprBit -logged $true)
    {
        Invoke-WPRScenario
    }
    if (IsScenarioEnabled -scenarioBit $global:setupBit -logged $true)
    {
        Invoke-SetupScenario
    }
    if (IsScenarioEnabled -scenarioBit $global:BackupRestoreBit -logged $true)
    {
        Invoke-BackupRestoreScenario
    } 
    if (IsScenarioEnabled -scenarioBit $global:IOBit -logged $true)
    {
        Invoke-IOScenario
    }    
    if ($false -eq (IsScenarioEnabled -scenarioBit $global:basicBit))
    {
        Write-LogInformation "Diagnostic collection started." -ForegroundColor Green #DO NOT CHANGE - Message is backward compatible
        Write-LogInformation ""
    }
}

function Stop-DiagCollectors() 
{
    Write-LogDebug "inside" $MyInvocation.MyCommand

    $server = $global:sql_instance_conn_str

    $ValidStop = $false

    #for Basic scenario we don't need to wait as there are only static logs
    if (($DiagStopTime -ne "0000") -and ($Scenario -ne $BASIC_NAME))
    {
        #likely a timer parameter is set to stop at a specified time
        StartStopTimeForDiagnostics -timeParam $DiagStopTime -startOrStop "stop"

        #bypass the manual "STOP" interactive user command and cause system to stop
        $global:stop_automatically = $true
    }
    try
    {

        if ($false -eq $global:stop_automatically)
        { #wait for user to type "STOP"
            while ($ValidStop -eq $false) 
            {
                Write-LogInformation "Please type 'STOP' to terminate the diagnostics collection when you finished capturing the issue" -ForegroundColor Green
                $StopStr = Read-Host ">" -CustomLogMessage "StopCollection Console input:"
                    
                #validate this PID is in the list discovered 
                if (($StopStr -eq "STOP") -or ($StopStr -eq "stop") ) 
                {
                    $ValidStop = $true
                    Write-LogInformation "Shutting down the collector" -ForegroundColor Green #DO NOT CHANGE - Message is backward compatible
                    break;
                }
                else 
                {
                    $ValidStop = $false
                }
            }
        }  
        else 
        {
            Write-LogInformation "Shutting down automatically. No user interaction to stop collectors" -ForegroundColor Green
            Write-LogInformation "Shutting down the collectors"  #DO NOT CHANGE - Message is backward compatible
        }        
        #create an output directory. -Force will not overwrite it, it will reuse the folder
        #$global:present_directory = Convert-Path -Path "."

        $partial_output_file_name = Create-PartialOutputFilename -server $server
        $partial_error_output_file_name = Create-PartialErrorOutputFilename -server $server


        #STOP the XEvent sessions
        if ( (($true -eq (IsScenarioEnabled -scenarioBit $global:generalperfBit )) `
            -or ($true -eq (IsScenarioEnabled -scenarioBit $global:detailedperfBit )) `
            -or ($true -eq (IsScenarioEnabled -scenarioBit $global:BackupRestoreBit)) )
            ) 
        { 
            #avoid errors if there was not Xevent collector started 
            Stop-Xevent -partial_output_file_name $partial_output_file_name -partial_error_output_file_name $partial_error_output_file_name
        }

        if ( $true -eq (IsScenarioEnabled -scenarioBit $global:alwaysonBit ) ) 
        { 
            #avoid errors if there was not Xevent collector started 
            Stop-AlwaysOn-Xevents -partial_output_file_name $partial_output_file_name -partial_error_output_file_name $partial_error_output_file_name
        }

        

        #Disable backup restore trace flag
        if ( $true -eq (IsScenarioEnabled -scenarioBit $global:BackupRestoreBit ) ) 
        { 
            Disable-BackupRestoreTraceFlag -partial_output_file_name $partial_output_file_name -partial_error_output_file_name $partial_error_output_file_name
        }

        #STOP Perfmon
        if ( ($true -eq (IsScenarioEnabled -scenarioBit $global:generalperfBit )) `
            -or ($true -eq (IsScenarioEnabled -scenarioBit $global:detailedperfBit )) `
            -or ($true -eq (IsScenarioEnabled -scenarioBit $global:memoryBit )) `
            -or ($true -eq (IsScenarioEnabled -scenarioBit $global:alwaysonBit )) `
            )
        {
            Stop-Perfmon -partial_output_file_name $partial_output_file_name -partial_error_output_file_name $partial_error_output_file_name
           
        }

        #wait for other work to finish
        Start-Sleep -Seconds 3

        #send the output file to \internal
        Kill-ActiveLogscoutSessions -partial_output_file_name $partial_output_file_name -partial_error_output_file_name $partial_error_output_file_name

        Start-Sleep -Seconds 1


        #STOP Network trace
        if ($true -eq (IsScenarioEnabled -scenarioBit $global:networktraceBit))
        {
            Stop-NetworkTrace -partial_output_file_name $partial_output_file_name -partial_error_output_file_name $partial_error_output_file_name
        }

        
        #stop WPR trace
        if ($true -eq (IsScenarioEnabled -scenarioBit $global:wprBit ))
        {
            Stop-WPRTrace -partial_error_output_file_name $partial_error_output_file_name
        }
        #stop storport trace
        if ($true -eq (IsScenarioEnabled -scenarioBit $global:IOBit ))
        {
            Stop-StorPortTrace -partial_error_output_file_name $partial_error_output_file_name
        }
        # shutdown collectors
        Invoke-OnShutDown

        Write-LogInformation "Waiting 3 seconds to ensure files are written to and closed by any program including anti-virus..." -ForegroundColor Green
        Start-Sleep -Seconds 3

        #Set back the setting of  SqlWriterConfig.ini file 
        if ($true -eq (IsScenarioEnabled -scenarioBit $global:BackupRestoreBit -scenarioName "BackupRestore"))
        {
            $file = 'C:\Program Files\Microsoft SQL Server\90\Shared\SqlWriterConfig.ini'
            (Get-Content $file).Replace("TraceLevel=VERBOSE","TraceLevel=DEFAULT") | Set-Content $file
            (Get-Content $file).Replace("TraceFileSizeMb=10","TraceFileSizeMb=1") | Set-Content $file
            Restart-Service SQLWriter -force
        }


    }
    catch {
        $function_name = $MyInvocation.MyCommand
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "$function_name Function failed with error:  $error_msg"
        return
    }

}


#***********************************stop collector function start********************************


function Stop-Xevent([string]$partial_output_file_name, [string]$partial_error_output_file_name)
{
    #avoid errors if there was not Xevent collector started
    Write-LogDebug "inside" $MyInvocation.MyCommand
    try
    { 
        $collector_name = "xevents_stop"
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $true  
        $alter_event_session_stop = "ALTER EVENT SESSION [$global:xevent_session] ON SERVER STATE = STOP; DROP EVENT SESSION [$global:xevent_session] ON SERVER;" 
        $executable = "sqlcmd.exe"
        $argument_list = "-S" + $server + " -E -Hsqllogscout_stop -w8000 -o" + $error_file + " -Q`"" + $alter_event_session_stop + "`""
        Write-LogInformation "Executing shutdown command: $collector_name"
        StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden
    }
    catch {
    $function_name = $MyInvocation.MyCommand
    $error_msg = $PSItem.Exception.Message 
    Write-LogError "$function_name Function failed with error:  $error_msg"
    return  
    }
}

function Stop-AlwaysOn-Xevents([string]$partial_output_file_name, [string]$partial_error_output_file_name)
{
    #avoid errors if there was not Xevent collector started 
    Write-LogDebug "inside" $MyInvocation.MyCommand
    try
    {
        $collector_name = "xevents_alwayson_data_movement_stop"
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $true  
        $alter_event_session_ag_stop = "ALTER EVENT SESSION [$global:xevent_alwayson_session] ON SERVER STATE = STOP; DROP EVENT SESSION [$global:xevent_alwayson_session] ON SERVER;" 
        $executable = "sqlcmd.exe"
        $argument_list = "-S" + $server + " -E -Hsqllogscout_stop -w8000 -o" + $error_file + " -Q`"" + $alter_event_session_ag_stop + "`""
        Write-LogInformation "Executing shutdown command: $collector_name"
        StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden
     }
    catch {
    $function_name = $MyInvocation.MyCommand
    $error_msg = $PSItem.Exception.Message 
    Write-LogError "$function_name Function failed with error:  $error_msg"
    return  
    }
}

function Disable-BackupRestoreTraceFlag([string]$partial_output_file_name, [string]$partial_error_output_file_name)
{
    Write-LogDebug "inside" $MyInvocation.MyCommand
    try
    {
        $collector_name = "Disable Backup Restore Trace Flag"
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $true  
        $Disabled_Trace_Flag = "DBCC TRACEOFF(3004,3212,3605,-1)" 
        $argument_list = "-S" + $server + " -E -Hsqllogscout_stop -w8000 -o" + $error_file + " -Q`"" + $Disabled_Trace_Flag + "`""
        #Write-LogInformation "Executing Disabling traceflag command: $collector_name"
        Write-LogInformation "Executing shutdown command: $collector_name"
        Write-LogDebug "Disabling trace flags for Backup/Restore: $Disabled_Trace_Flag " -DebugLogLevel 2
        StartNewProcess -FilePath "sqlcmd.exe" -ArgumentList $argument_list -WindowStyle Hidden
    }
    catch {
    $function_name = $MyInvocation.MyCommand
    $error_msg = $PSItem.Exception.Message 
    Write-LogError "$function_name Function failed with error:  $error_msg"
    return 
    }
}

function Stop-Perfmon([string]$partial_output_file_name, [string]$partial_error_output_file_name)
{
    Write-LogDebug "inside" $MyInvocation.MyCommand
    try
    {
        $collector_name = "PerfmonStop"
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $false 
        $argument_list = "/C logman stop logscoutperfmon & logman delete logscoutperfmon"
        $executable = "cmd.exe"
        Write-LogInformation "Executing shutdown command: $collector_name"
        StartNewProcess -FilePath $executable -ArgumentList $argument_list -RedirectStandardError $error_file -WindowStyle Hidden
    }
    catch {
    $function_name = $MyInvocation.MyCommand
    $error_msg = $PSItem.Exception.Message 
    Write-LogError "$function_name Function failed with error:  $error_msg"
    return   
    }
}


function Kill-ActiveLogscoutSessions([string]$partial_output_file_name, [string]$partial_error_output_file_name)
{
    Write-LogDebug "inside" $MyInvocation.MyCommand
    try
    {
        $collector_name = "KillActiveLogscoutSessions"
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $true
        $query = "declare curSession 
                CURSOR for select 'kill ' + cast( session_id as varchar(max)) from sys.dm_exec_sessions where host_name = 'sqllogscout' and program_name='SQLCMD' and session_id <> @@spid
                open curSession
                declare @sql varchar(max)
                fetch next from curSession into @sql
                while @@FETCH_STATUS = 0
                begin
                    exec (@sql)
                    fetch next from curSession into @sql
                end
                close curSession;
                deallocate curSession;"  
        $argument_list = "-S" + $server + " -E -Hsqllogscout_stop -w8000 -o" + $error_file + " -Q`"" + $query + "`" "
        $executable = "sqlcmd.exe"
        Write-LogInformation "Executing shutdown command: $collector_name"
        StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden
    }
    catch {
    $function_name = $MyInvocation.MyCommand
    $error_msg = $PSItem.Exception.Message 
    Write-LogError "$function_name Function failed with error:  $error_msg"
    return  
    }
}

function Stop-NetworkTrace([string]$partial_output_file_name, [string]$partial_error_output_file_name)
{
    Write-LogDebug "inside" $MyInvocation.MyCommand
    try
    {
        $collector_name = "NettraceStop"
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $false 

        $argument_list = "/C title Stopping Network trace... & echo This process may take a few minutes. Do not close this window... & StopNetworkTrace.bat"
        $executable = "cmd.exe"

        Write-LogInformation "Executing shutdown command: $collector_name"

        $p = Start-Process -FilePath $executable -ArgumentList $argument_list -RedirectStandardError $error_file -WindowStyle Normal -PassThru
        $pn = $p.ProcessName
        $sh = $p.SafeHandle
        if($false -eq $p.HasExited)   
        {
            [void]$global:processes.Add($p)
        }

        [int]$cntr = 0

        while ($false -eq $p.HasExited) 
        {
            [void] $p.WaitForExit(20000)
            if ($cntr -gt 0) {
                #Write-LogWarning "Please wait for network trace to stop..."
                Write-LogWarning "Shutting down network tracing may take a few minutes. Please wait..."
            }
            $cntr++
        }

    }
    catch {
    $function_name = $MyInvocation.MyCommand
    $error_msg = $PSItem.Exception.Message 
    Write-LogError "$function_name Function failed with error:  $error_msg"
    return   
    }
}

function Stop-WPRTrace([string]$partial_error_output_file_name)
{
    Write-LogDebug "inside" $MyInvocation.MyCommand
    try
    {
        $collector_name = $global:wpr_collector_name
        $partial_output_file_name_wpr = Create-PartialOutputFilename -server $server
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $false
        $output_file = Build-FinalOutputFile -output_file_name $partial_output_file_name_wpr -collector_name $collector_name -needExtraQuotes $true -fileExt ".etl"
        $executable = "cmd.exe"
        $argument_list = $argument_list = "/C wpr.exe -stop " + $output_file
        Write-LogInformation "Executing shutdown command: $collector_name"
        Write-LogDebug $executable $argument_list
        # StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden -RedirectStandardOutput $error_file
        $p = Start-Process -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden -RedirectStandardOutput $error_file -PassThru
        $pn = $p.ProcessName
        $sh = $p.SafeHandle
        if($false -eq $p.HasExited)   
        {
            [void]$global:processes.Add($p)
        }

        $cntr = 0 #reset the counter
        while ($false -eq $p.HasExited) 
        {
            [void] $p.WaitForExit(5000)
        
            if ($cntr -gt 0) {
                Write-LogWarning "Please wait for WPR trace to stop..."
            }
            $cntr++
        }
    }
    catch {
    $function_name = $MyInvocation.MyCommand
    $error_msg = $PSItem.Exception.Message 
    Write-LogError "$function_name Function failed with error:  $error_msg"
    return  
    }
}

function Stop-StorPortTrace([string]$partial_error_output_file_name)
{
    Write-LogDebug "inside" $MyInvocation.MyCommand
    try
    {
        $collector_name = "StorPort_Stop"
        $error_file = Build-FinalErrorFile -partial_error_output_file_name $partial_error_output_file_name -collector_name $collector_name -needExtraQuotes $false 
        $argument_list = "/C logman stop ""storport"" -ets"
        $executable = "cmd.exe"
        Write-LogInformation "Executing shutdown command: $collector_name"
        StartNewProcess -FilePath $executable -ArgumentList $argument_list -RedirectStandardError $error_file -WindowStyle Hidden
    }
    catch {
    $function_name = $MyInvocation.MyCommand
    $error_msg = $PSItem.Exception.Message 
    Write-LogError "$function_name Function failed with error:  $error_msg"
    return   
    }
}

#**********************************Stop collector function end***********************************


function Invoke-DiagnosticCleanUpAndExit()
{

  Write-LogDebug "inside" $MyInvocation.MyCommand

  Write-LogWarning "Launching cleanup and exit routine... please wait"

  $server = $global:sql_instance_conn_str

  #quick cleanup to ensure no collectors are running. 
  #Kill existing sessions
  #send the output file to \internal
  $query = "
    declare curSession
    CURSOR for select 'kill ' + cast( session_id as varchar(max)) from sys.dm_exec_sessions where host_name = 'sqllogscout' and program_name='SQLCMD' and session_id <> @@spid
    open curSession
    declare @sql varchar(max)
    fetch next from curSession into @sql
    while @@FETCH_STATUS = 0
    begin
        exec (@sql)
        fetch next from curSession into @sql
    end
    close curSession;
    deallocate curSession;
    "  
  if ($server -ne $NO_INSTANCE_NAME)
  {
      $executable = "sqlcmd.exe"
      $argument_list ="-S" + $server +  " -E -Hsqllogscout_cleanup -w8000 -Q`""+ $query + "`" "
      StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden
        
  }
  
  
   #STOP the XEvent sessions

  if ($server -ne $NO_INSTANCE_NAME)
  {  
    $alter_event_session_stop = "IF HAS_PERMS_BY_NAME(NULL, NULL, 'ALTER ANY EVENT SESSION') = 1 BEGIN ALTER EVENT SESSION [$global:xevent_session] ON SERVER STATE = STOP; DROP EVENT SESSION [$global:xevent_session] ON SERVER; END" 
    $executable = "sqlcmd.exe"
    $argument_list = "-S" + $server + " -E -Hsqllogscout_cleanup -w8000 -Q`"" + $alter_event_session_stop + "`""
    StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden
        

    #avoid errors if there was not Xevent collector started 
    $alter_event_session_ag_stop = "IF HAS_PERMS_BY_NAME(NULL, NULL, 'ALTER ANY EVENT SESSION') = 1 BEGIN ALTER EVENT SESSION [$global:xevent_alwayson_session] ON SERVER STATE = STOP; DROP EVENT SESSION [$global:xevent_alwayson_session] ON SERVER; END" 
    $executable = "sqlcmd.exe"
    $argument_list = "-S" + $server + " -E -Hsqllogscout_stop -w8000 -Q`"" + $alter_event_session_ag_stop + "`""
    StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden
    
  }

  #STOP Perfmon
  $executable = "cmd.exe"
  $argument_list ="/C logman stop logscoutperfmon & logman delete logscoutperfmon"
  StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden



  #cleanup network trace
  if ($true -eq (IsScenarioEnabled -scenarioBit $global:networktraceBit ))
  {
    $executable = "cmd.exe"
    $argument_list ="/C title Cleanup Network trace... & echo This process may take a few minutes. Do not close this window... & StopNetworkTrace.bat"
    $p = Start-Process -FilePath $executable -ArgumentList $argument_list -WindowStyle Normal -PassThru
    Write-LogWarning "Cleaning up network tracing may take a few minutes. Please wait..."

    $pn = $p.ProcessName
    $sh = $p.SafeHandle
    if($false -eq $p.HasExited)   
    {
        [void]$global:processes.Add($p)
    }

    [int]$cntr = 0

    while ($false -eq $p.HasExited) 
    {
        [void] $p.WaitForExit(20000)
        if ($cntr -gt 0) {
            #Write-LogWarning "Please wait for network trace to stop..."
            Write-LogWarning "Shutting down network tracing may take a few minutes. Please do not close this window ..."
        }
        $cntr++
    }

  }

  #stop the WPR process if running any on the system
  if ($true -eq (IsScenarioEnabled -scenarioBit $global:wprBit ))
  {
    $executable = "cmd.exe"
    $argument_list = $argument_list = "/C wpr.exe -cancel " 
    # StartNewProcess -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden
    Write-LogDebug $executable $argument_list
    $p = Start-Process -FilePath $executable -ArgumentList $argument_list -WindowStyle Hidden -PassThru
    $pn = $p.ProcessName
    $sh = $p.SafeHandle
    if($false -eq $p.HasExited)   
    {
        [void]$global:processes.Add($p)
    }

    [int]$cntr = 0 
    while ($false -eq $p.HasExited) 
    {
        [void] $p.WaitForExit(5000)

        if ($cntr -gt 0)
        {
            Write-LogWarning "Continuing to wait for WPR trace to cancel..."
        }
        $cntr++
    } 
  } #if wrp enabled

  if (($server -ne $NO_INSTANCE_NAME) -and ($true -eq (IsScenarioEnabled -scenarioBit $global:BackupRestoreBit )) )
  {
    #clean up backup/restore tace flags
    $Disabled_Trace_Flag = "DBCC TRACEOFF(3004,3212,3605,-1)" 
    $argument_list = "-S" + $server + " -E -Hsqllogscout_stop -w8000 -Q`"" + $Disabled_Trace_Flag + "`""
    StartNewProcess -FilePath "sqlcmd.exe" -ArgumentList $argument_list -WindowStyle Hidden
        
  } 

    Write-LogDebug "Checking that all processes terminated..."

    #allowing some time for above processes to clean-up
    Start-Sleep 5

    [string]$processname = [String]::Empty
    [string]$processid = [String]::Empty
    [string]$process_startime = [String]::Empty

    foreach ($p in $global:processes) 
    {
        # get the properties of the processes we stored in the array into string variables so we can show them
        if ($true -ne [String]::IsNullOrWhiteSpace($p.ProcessName) )
        {
            $processname = $p.ProcessName
        }
        else 
        {
            $processname = "NoProcessName"
        }
        if ($null -ne $p.Id )
        {
            $processid = $p.Id.ToString()
        }
        else 
        {
            $processid = "0"
        }
        if ($null -ne $p.StartTime)
        {
            $process_startime = $p.StartTime.ToString('yyyyMMddHHmmssfff')
        }
        else 
        {
            $process_startime = "NoStartTime"
        }

        Write-LogDebug "Process contained in Processes array is '$processname', $processid, $process_startime" -DebugLogLevel 5

        if ($p.HasExited -eq $false) 
        {
            $cur_proc = Get-Process -Id $p.Id

            $cur_proc_id = $cur_proc.Id.ToString()
            $cur_proc_starttime = $cur_proc.StartTime.ToString('yyyyMMddHHmmssfff')
            $cur_proc_name = $cur_proc.ProcessName

            Write-LogDebug "Original process which hasn't exited and is matched by Id is: $cur_proc_id, $cur_proc_name, $cur_proc_starttime" -DebugLogLevel 5

            if (($cur_proc.Id -eq $p.Id) -and ($cur_proc.StartTime -eq $p.StartTime) -and ($cur_proc.ProcessName -eq $p.ProcessName) )
            {
                Write-LogInformation ("Process ID " + ([string]$p.Id) + " has not exited yet.")
                Write-LogInformation ("Process CommandLine for Process ID " + ([string]$p.Id) + " is: " + $OSCommandLine)
                Write-LogDebug ("Process CPU Usage Total / User / Kernel: " + [string]$p.TotalProcessorTime + "     " + [string]$p.UserProcessorTime + "     " + [string]$p.PrivilegedProcessorTime) -DebugLogLevel 3
                Write-LogDebug ("Process Start Time: " + [string]$p.StartTime) -DebugLogLevel 3
                Write-LogDebug ("Process CPU Usage %: " + [string](($p.TotalProcessorTime.TotalMilliseconds / ((Get-Date) - $p.StartTime).TotalMilliseconds) * 100)) -DebugLogLevel 3
                Write-LogDebug ("Process Peak WorkingSet (MB): " + [string]$p.PeakWorkingSet64 / ([Math]::Pow(1024, 2))) -DebugLogLevel 3
                Write-LogWarning ("Stopping Process ID " + ([string]$p.Id))
                Stop-Process $p
            }
        }
        else {
            Write-LogDebug "Process '$processname', $processid, $process_startime has exited." -DebugLogLevel 5
        }
    }
  
  Write-LogInformation "Thank you for using SQL LogScout!" -ForegroundColor Yellow
  exit
}



#======================================== END OF Diagnostics Collection SECTION

#======================================== START OF Bitmask Enabling, Diabling and Checking of Scenarios

function ScenarioBitToName ([int] $pScenarioBit)
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand

    [string] $scenName = [String]::Empty

    switch ($pScenarioBit) 
    {
        $global:basicBit { $scenName = $BASIC_NAME}
        $global:generalperfBit { $scenName = $GENERALPERF_NAME}
        $global:detailedperfBit { $scenName = $DETAILEDPERF_NAME}
        $global:replBit { $scenName = $REPLICATION_NAME}
        $global:alwaysonBit { $scenName = $ALWAYSON_NAME}
        $global:networktraceBit { $scenName = $NETWORKTRACE_NAME}
        $global:memoryBit { $scenName = $MEMORY_NAME}
        $global:dumpMemoryBit { $scenName = $DUMPMEMORY_NAME}
        $global:wprBit { $scenName = $WPR_NAME}
        $global:setupBit { $scenName = $SETUP_NAME}
        $global:BackupRestoreBit { $scenName = $BACKUPRESTORE_NAME}
        $global:IOBit { $scenName = $IO_NAME}
        $global:LightPerfBit { $scenName = $LIGHTPERF_NAME}
        Default {}
    }

   Write-LogDebug "Scenario bit $pScenarioBit translates to $scenName" -DebugLogLevel 5

    return $scenName
}


function ScenarioNameToBit ([string] $pScenarioName)
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand

    [int] $scenBit = 0

    switch ($pScenarioName) 
    {
        $BASIC_NAME { $scenBit = $global:basicBit}
        $GENERALPERF_NAME { $scenBit = $global:generalperfBit}
        $DETAILEDPERF_NAME { $scenBit = $global:detailedperfBit}
        $REPLICATION_NAME { $scenBit = $global:replBit}
        $ALWAYSON_NAME { $scenBit = $global:alwaysonBit}
        $NETWORKTRACE_NAME { $scenBit = $global:networktraceBit}
        $MEMORY_NAME { $scenBit = $global:memoryBit}
        $DUMPMEMORY_NAME { $scenBit = $global:dumpMemoryBit}
        $WPR_NAME { $scenBit = $global:wprBit}
        $SETUP_NAME { $scenBit = $global:setupBit}
        $BACKUPRESTORE_NAME { $scenBit = $global:BackupRestoreBit}
        $IO_NAME { $scenBit = $global:IOBit}
        $LIGHTPERF_NAME { $scenBit = $global:LightPerfBit}
        Default {}
    }

    Write-LogDebug "Scenario name $pScenarioName translates to bit $scenBit" -DebugLogLevel 5

    return $scenBit
}

function EnableScenario([int]$pScenarioBit)
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand

    [string] $scenName = ScenarioBitToName -pScenarioBit $pScenarioBit

    Write-LogDebug "Enabling scenario bit $pScenarioBit, '$scenName' scenario" -DebugLogLevel 3

    #de-duplicate entries
    if (!$global:ScenarioChoice.Contains($scenName))
    {
        #populate the ScenarioChoice array
        [void] $global:ScenarioChoice.Add($scenName)

    }

    $global:scenario_bitvalue = $global:scenario_bitvalue -bor $pScenarioBit
}

function DisableScenario([int]$pScenarioBit)
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand

    Write-LogDebug "Disabling scenario bit $pScenarioBit" -DebugLogLevel 3
    
    [string] $scenName = ScenarioBitToName -pScenarioBit $pScenarioBit
    
    $global:ScenarioChoice.Remove($scenName)
    $global:scenario_bitvalue = $global:scenario_bitvalue -bxor $pScenarioBit
}

function DisableAllScenarios()
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand

    Write-LogDebug "Setting Scenarios bit to 0" -DebugLogLevel 3

    #reset both scenario structures
    $global:ScenarioChoice.Clear()
    $global:scenario_bitvalue = 0
}

function IsScenarioEnabled([int]$scenarioBit, [bool] $logged = $false)
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand

    #perform the check 
    $bm_enabled = $global:scenario_bitvalue -band $scenarioBit

    if ($true -eq $logged)
    {
        [string] $scenName = ScenarioBitToName -pScenarioBit $scenarioBit
        Write-LogDebug "The bitmask result for $scenName scenario = $bm_enabled" -DebugLogLevel 4
    }

    #if enabled, return true, else false
    if ($bm_enabled -gt 0)
    {
        if ($true -eq $logged)
        {
            Write-LogDebug "$scenName scenario is enabled" -DebugLogLevel 2
        }
        
        return $true
    }
    else
    {
        if ($true -eq $logged)
        {
            Write-LogDebug "$scenName scenario is disabled" -DebugLogLevel 2
        }
        return $false
    }

}


#======================================== END OF Bitmask Enabling, Diabling and Checking of Scenarios


#======================================== START OF NETNAME + INSTANCE SECTION

function Get-ClusterVNN ($instance_name)
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand
    $vnn = ""

    if (($instance_name -ne "") -and ($null -ne $instance_name))
    {
        $sql_fci_object = Get-ClusterResource | Where-Object {($_.ResourceType -eq "SQL Server")} | get-clusterparameter | Where-Object {($_.Name -eq "InstanceName") -and ($_.Value -eq $instance_name)}
        $vnn_obj = Get-ClusterResource  | Where-Object {($_.ResourceType -eq "SQL Server") -and ($_.OwnerGroup -eq $sql_fci_object.ClusterObject.OwnerGroup.Name)} | get-clusterparameter -Name VirtualServerName | Select-Object Value
        $vnn = $vnn_obj.Value
    }
    else
    {
        Write-LogError "Instance name is empty and it shouldn't be at this point"            
    }
    
    Write-LogDebug "The VNN Matched to Instance = '$instance_name' is  '$vnn' " -DebugLogLevel 2

    return $vnn
}

function Build-ClusterVnnPlusInstance([string]$instance)
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand
	
        
    [string]$VirtNetworkNamePlusInstance = ""

    if (($instance -eq "") -or ($null -eq $instance)) 
    {
        Write-LogError "Instance name is empty and it shouldn't be at this point"
    }
    else
    {
        #take the array instance-only names and look it up against the cluster resources and get the VNN that matches that instance. Then populate the NetName array

                $vnn = Get-ClusterVNN ($instance)

                Write-LogDebug  "VirtualName+Instance:   " ($vnn + "\" + $instance) -DebugLogLevel 2

                $VirtNetworkNamePlusInstance = ($vnn + "\" + $instance)

                Write-LogDebug "Combined NetName+Instance: '$VirtNetworkNamePlusInstance'" -DebugLogLevel 2
    }

    return $VirtNetworkNamePlusInstance    
}

function Build-HostnamePlusInstance([string]$instance)
{
    Write-LogDebug "inside" $MyInvocation.MyCommand
		
    [string]$NetworkNamePlustInstance = ""
    
    if (($instance -eq "") -or ($null -eq $instance)) 
    {
        Write-LogError "Instance name is empty and it shouldn't be at this point"
    }
    else
    {
        #take the array instance-only names and look it up against the cluster resources and get the VNN that matches that instance. Then populate the NetName array
        $host_name = hostname

        Write-LogDebug "HostNames+Instance:   " ($host_name + "\" + $instance) -DebugLogLevel 4

        if ($instance -eq "MSSQLSERVER")
        {
            $NetworkNamePlustInstance = $host_name
        }
        else
        {
            $NetworkNamePlustInstance = ($host_name + "\" + $instance)
        }

        Write-LogDebug "Combined HostName+Instance: " $NetworkNamePlustInstance -DebugLogLevel 3
    }

    return $NetworkNamePlustInstance
}


#check if cluster - based on cluster service status and cluster registry key
function IsClustered()
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand

    $ret = $false
    $error_msg = ""
        
    $clusServiceisRunning = $false
    $clusRegKeyExists = $false
    $ClusterServiceKey="HKLM:\Cluster"

    # Check if cluster service is running
    try 
    { 
        if ((Get-Service |  Where-Object  {$_.Displayname -match "Cluster Service"}).Status -eq "Running") 
        {
            $clusServiceisRunning =  $true
            Write-LogDebug "Cluster services status is running: $clusServiceisRunning  " -DebugLogLevel 2   
        }
        
        if (Test-Path $ClusterServiceKey) 
        { 
            $clusRegKeyExists  = $true
            Write-LogDebug "Cluster key $ClusterServiceKey Exists: $clusRegKeyExists  " -DebugLogLevel 2
        }

        if (($clusRegKeyExists -eq $true) -and ($clusServiceisRunning -eq $true ))
        {
            Write-LogDebug 'This is a Windows Cluster for sure!' -DebugLogLevel 2
            Write-LogInformation 'This is a Windows Cluster'
            return $true
        }
        else 
        {
            Write-LogDebug 'This is Not a Windows Cluster!' -DebugLogLevel 2
            $ret = $false
            return $ret
        }
    }
    catch 
    {
        $mycommand = $MyInvocation.MyCommand
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand failed with error:  $error_msg"
        return
    }

    return $ret
}

function IsFailoverClusteredInstance([string]$instanceName)
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand

    if (Get-ClusterResource  | Where-Object {($_.ResourceType -eq "SQL Server")} | get-clusterparameter | Where-Object {($_.Name -eq "InstanceName") -and ($_.Value -eq $instanceName)} )
    {
        Write-LogDebug "The instance '$instanceName' is a SQL FCI " -DebugLogLevel 2
        return $true
    }
    else 
    {
        Write-LogDebug "The instance '$instanceName' is NOT a SQL FCI " -DebugLogLevel 2
        return $false    
    }
}

function Get-InstanceNamesOnly()
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand
    
    [string[]]$instnaceArray = @()
    $selectedSqlInstance = ""


    #find the actively running SQL Server services
    $SqlTaskList = Tasklist /SVC /FI "imagename eq sqlservr*" /FO CSV | ConvertFrom-Csv

    
    if ($SqlTaskList.Count -eq 0)
    {

        Write-LogInformation "There are currently no running instances of SQL Server. Would you like to proceed with OS-only log collection" -ForegroundColor Green
        
        if ($InteractivePrompts -eq "Noisy")
        {
            $ValidInput = "Y","N"
            $ynStr = Read-Host "Proceed with logs collection (Y/N)?>" -CustomLogMessage "no_sql_instance_logs input: "
            $HelpMessage = "Please enter a valid input ($ValidInput)"

            #$AllInput = $ValidInput,$WPR_YesNo,$HelpMessage 
            $AllInput = @()
            $AllInput += , $ValidInput
            $AllInput += , $ynStr
            $AllInput += , $HelpMessage
        
            [string] $confirm = validateUserInput($AllInput)
        }
        elseif ($InteractivePrompts -eq "Quiet") 
        {
            Write-LogDebug "QUIET mode enabled" -DebugLogLevel 4
            $confirm = "Y"
        }

        Write-LogDebug "The choice made is '$confirm'"

        if ($confirm -eq "Y")
        {
            $instnaceArray+=$global:sql_instance_conn_str
        }
        elseif ($confirm -eq "N")
        {
            Write-LogInformation "Aborting collection..."
            exit
        }
        
    }

    else 
    {
        Write-LogDebug "The running instances are: " $SqlTaskList -DebugLogLevel 3
        Write-LogDebug "" -DebugLogLevel 3
        $SqlTaskList | Select-Object  PID, "Image name", Services | ForEach-Object {Write-LogDebug $_ -DebugLogLevel 5}
        Write-LogDebug ""
    
        foreach ($sqlinstance in $SqlTaskList.Services)
        {
            #in the case of a default instance, just use MSSQLSERVER which is the instance name

            if ($sqlinstance.IndexOf("$") -lt 1)
            {
                $selectedSqlInstance  = $sqlinstance
            }

            #for named instance, strip the part after the "$"
            else
            {
                $selectedSqlInstance  = $sqlinstance.Substring($sqlinstance.IndexOf("$") + 1)
            }

            
            #add each instance name to the array
            $instnaceArray+=$selectedSqlInstance 
        }

    }


    return $instnaceArray
}

function Get-NetNameMatchingInstance()
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand

    [string[]]$NetworkNamePlustInstanceArray = @()
    $isClustered = $false
	[string[]]$instanceArrayLocal = @()


    #get the list of instance names
    $instanceArrayLocal = Get-InstanceNamesOnly

    #special cases - if no SQL instance on the machine, just hard-code a value
    if ($global:sql_instance_conn_str -eq $instanceArrayLocal.Get(0) )
    {
        $NetworkNamePlustInstanceArray+=$instanceArrayLocal.Get(0)
        Write-LogDebug "No running SQL Server instances on the box so hard coding a value and collecting OS-data" -DebugLogLevel 1
    }
    elseif ($instanceArrayLocal -and ($null -ne $instanceArrayLocal))
    {
        Write-LogDebug "InstanceArrayLocal contains:" $instanceArrayLocal -DebugLogLevel 2

        #build NetName + Instance 

        $isClustered = IsClustered #($instanceArrayLocal)

        #if this is on a clustered system, then need to check for FCI or AG resources
        if ($isClustered -eq $true)
        {
        
            #loop through each instance name and check if FCI or not. If FCI, use ClusterVnnPlusInstance, else use HostnamePlusInstance
            #append each name to the output array $NetworkNamePlustInstanceArray
            for($i=0; $i -lt $instanceArrayLocal.Count; $i++)
            {
                if (IsFailoverClusteredInstance($instanceArrayLocal[$i]))
                    {
                        $NetworkNamePlustInstanceArray += Build-ClusterVnnPlusInstance ($instanceArrayLocal[$i])  
                    }
                else
                {
                    $NetworkNamePlustInstanceArray += Build-HostnamePlusInstance($instanceArrayLocal[$i])
                }

            }
        }
        #all local resources so just build array with local instances
        else
        {
            for($i=0; $i -lt $instanceArrayLocal.Count; $i++)
            {
                    $NetworkNamePlustInstanceArray += Build-HostnamePlusInstance($instanceArrayLocal[$i])
            }

        }




    }

    else
    {
        Write-LogError "InstanceArrayLocal array is blank or null - no instances populated for some reason"
    }

    

    return $NetworkNamePlustInstanceArray

}


#Display them to user and let him pick one
function Pick-SQLServer-for-Diagnostics()
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand
    
    $SqlIdInt = 777
    $isInt = $false
    $ValidId = $false
    [string[]]$NetNamePlusinstanceArray = @()
    [string]$PickedNetPlusInstance = ""

    if ($global:instance_independent_collection -eq $true)
    {
        Write-LogDebug "An instance-independent collection is requested. Skipping instance discovery." -DebugLogLevel 1
        return
    }

    #if SQL LogScout did not accept any values for parameter $ServerName 
    if (($true -eq [string]::IsNullOrWhiteSpace($ServerName)) -and $ServerName.Length -le 1 )
    {
        Write-LogDebug "Server Instance param is blank. Switching to auto-discovery of instances" -DebugLogLevel 2

        $NetNamePlusinstanceArray = Get-NetNameMatchingInstance

        if ($NetNamePlusinstanceArray.get(0) -eq $global:sql_instance_conn_str) 
        {
            $hard_coded_instance  = $NetNamePlusinstanceArray.Get(0)
            Write-LogDebug "No running SQL Server instances, thus returning the default '$hard_coded_instance' and collecting OS-data only" -DebugLogLevel 1
            return 
        }
        elseif ($NetNamePlusinstanceArray -and ($null -ne $NetNamePlusinstanceArray))
        {
            Write-LogDebug "NetNamePlusinstanceArray contains: " $NetNamePlusinstanceArray -DebugLogLevel 4

            #prompt the user to pick from the list

            
            if ($NetNamePlusinstanceArray.Count -ge 1)
            {
                
                $instanceIDArray = 0..($NetNamePlusinstanceArray.Length -1)

                #print out the instance names

                Write-LogInformation "Discovered the following SQL Server instance(s)`n"
                Write-LogInformation ""
                Write-LogInformation "ID	SQL Instance Name"
                Write-LogInformation "--	----------------"

                # sort the array by instance name
                $NetNamePlusinstanceArray = $NetNamePlusinstanceArray | Sort-Object

                for($i=0; $i -lt $NetNamePlusinstanceArray.Count;$i++)
                {
                    Write-LogInformation $i "	" $NetNamePlusinstanceArray[$i]
                }

                while(($isInt -eq $false) -or ($ValidId -eq $false))
                {
                    Write-LogInformation ""
                    Write-LogWarning "Enter the ID of the SQL instance for which you want to collect diagnostic data. Then press Enter" 
                    #Write-LogWarning "Then press Enter" 

                    $SqlIdStr = Read-Host "Enter the ID from list above>" -CustomLogMessage "SQL Instance Console input:"
                    
                    try{
                            $SqlIdInt = [convert]::ToInt32($SqlIdStr)
                            $isInt = $true
                        }

                    catch [FormatException]
                        {
                            Write-LogError "The value entered for ID '",$SqlIdStr,"' is not an integer"
                            continue
                        }
        
                    #validate this ID is in the list discovered 
                    if ($SqlIdInt -in ($instanceIDArray))
                    {
                        $ValidId = $true
                        break;
                    }
                    else 
                    {
                        $ValidId = $false
                        Write-LogError "The numeric instance ID entered '$SqlIdInt' is not in the list"
                    }


                }   #end of while


            }#end of IF



        }

        
        else
        {
            Write-LogError "NetNamePlusinstanceArray array is blank or null. Exiting..."
            exit
        }

        $str = "You selected instance '" + $NetNamePlusinstanceArray[$SqlIdInt] +"' to collect diagnostic data. "
        Write-LogInformation $str -ForegroundColor Green

        #set the global variable so it can be easily used by multiple collectors
        $global:sql_instance_conn_str = $NetNamePlusinstanceArray[$SqlIdInt] 

        #return $NetNamePlusinstanceArray[$SqlIdInt] 

    }

    else 
    {
        Write-LogDebug "Server Instance param is '$ServerName'. Using this value for data collection" -DebugLogLevel 2
        $global:sql_instance_conn_str = $ServerName
    }
}


function Set-NoInstanceToHostName()
{
    Write-LogDebug "inside" $MyInvocation.MyCommand
    try 
    {
        if ($global:sql_instance_conn_str -eq $NO_INSTANCE_NAME)
        {
            $global:sql_instance_conn_str = $global:host_name
        }
    }
    catch 
    {
        $mycommand = $MyInvocation.MyCommand 
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Function $mycommand failed with error:  $error_msg"
        return
    }
    
}
#======================================== END OF NETNAME + INSTANCE SECTION

#======================================== START OF PERFMON COUNTER FILES SECTION


function Strip-InstanceName([string]$NetnamePlusInstance)
{
    Write-LogDebug "inside" $MyInvocation.MyCommand

    $selectedSqlInstance  = $NetnamePlusInstance.Substring($NetnamePlusInstance.IndexOf("\") + 1)
    return $selectedSqlInstance 
}


function Build-PerfmonString ([string]$NetNamePlusInstance)
{
    Write-LogDebug "inside" $MyInvocation.MyCommand

    #if default instance, this function will return the hostname
    $host_name = hostname

    $instance_name = Strip-InstanceName($NetNamePlusInstance)

    #if default instance use "SQLServer", else "MSSQL$InstanceName
    if ($instance_name -eq $host_name)
    {
        $perfmon_str = "SQLServer"
    }
    else
    {
        $perfmon_str = "MSSQL$"+$instance_name

    }

    Write-LogDebug "Perfmon string is: $perfmon_str" -DebugLogLevel 2

    return $perfmon_str
}


function Update-PerfmonConfigFile([string]$NetNamePlusInstance)
{
    Write-LogDebug "inside" $MyInvocation.MyCommand

    #fetch the location of the copied counter file in the \internal folder. Could write a function in the future if done more than once
    $internal_directory = $global:internal_output_folder
    $perfmonCounterFile = $internal_directory+$global:perfmon_active_counter_file

    Write-LogDebug "New Perfmon counter file location is: " $perfmonCounterFile -DebugLogLevel 2

    $original_string = 'MSSQL$*:'
    $new_string = Build-PerfmonString ($NetNamePlusInstance) 
    $new_string += ":"
    
    Write-LogDebug "Replacement string is: " $new_string -DebugLogLevel 2

    try
    {
            if (Test-Path -Path $perfmonCounterFile)
            {
                #This does the magic. Loads the file in memory, and replaces the original string with the new built string
                ((Get-Content -path $perfmonCounterFile -Raw ) -replace  [regex]::Escape($original_string), $new_string) | Set-Content -Path $perfmonCounterFile 
            }
            else 
            {
                Write-LogError "The file $perfmonCounterFile does not exist."
            }
    }
    catch 
    {   
        $error_msg = $PSItem.Exception.Message 
        Write-LogError "Copy-Item or Remove-Item cmdlet failed with the following error:  $error_msg"    
    }
}

function Copy-OriginalLogmanConfig()
{
    #this function makes a copy of the original Perfmon counters LogmanConfig.txt file in the \output\internal directory
    #the file will be used from there
    

    Write-LogDebug "inside" $MyInvocation.MyCommand
    
    $internal_path = $global:internal_output_folder
    $present_directory = $global:present_directory
    $perfmon_file = $global:perfmon_active_counter_file

    $perfmonCounterFile = $present_directory+"\"+$perfmon_file     #"LogmanConfig.txt"
    $destinationPerfmonCounterFile = $internal_path + $perfmon_file   #\output\internal\LogmanConfig.txt
    

    try
    {
        if(Test-Path -Path $internal_path)
        {
            #copy the file to internal path so it can be used from there
            Copy-Item -Path $perfmonCounterFile -Destination $destinationPerfmonCounterFile -ErrorAction Stop
            Write-LogInformation "$perfmon_file copied to " $destinationPerfmonCounterFile
            
            #file has been copied
            return $true
        }
        else 
        {
            Write-LogError "The file $perfmonCounterFile is not present."
            return $false
        }
        
        
    }

    catch
    {
        $error_msg = $PSItem.Exception.Message 
        if ($error_msg -Match "because it does not exist")
        {
            Write-LogError "The $perfmon_file file does not exist."
        }
        else
        {
            Write-LogError "Copy-Item  cmdlet failed with the following error: " $error_msg 
            
        }

        return $false
    }
}



function PrepareCountersFile()
{
    Write-LogDebug "Inside" $MyInvocation.MyCommand

    #if we are not calling a Perfmon scenario, return and don't proceed
    if ($global:perfmon_scenario_enabled -eq $false)
    {
        Write-LogWarning "No Perfmon-collection scenario is selected. Perfmon counters file will not be created"
        return
    }

    if (($global:sql_instance_conn_str -ne "") -and ($null -ne $global:sql_instance_conn_str) )
    {
        [string] $SQLServerName = $global:sql_instance_conn_str
    }
    else 
    {
        Write-LogError "SQL instance name is empty.Exiting..."    
        exit
    }

    if (Copy-OriginalLogmanConfig)
    {
        Write-LogDebug "Perfmon Counters file was copied. It is safe to update it in new location" -DebugLogLevel 2
        Update-PerfmonConfigFile($SQLServerName)
    }
    #restoration of original file is in the Stop-DiagCollectors
}


#======================================== END OF PERFMON COUNTER FILES SECTION



function Check-ElevatedAccess
{
    Write-LogDebug "inside " $MyInvocation.MyCommand

    #check for administrator rights
  
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
    {
         Write-Warning "Elevated privilege (run as Admininstrator) is required to run SQL_LogScout! Exiting..."
         exit
    }
    

}

function Confirm-SQLPermissions
{
<#
    .SYNOPSIS
        Returns true if user has VIEW SERVER STATE permission in SQL Server, otherwise warns about lack of permissions and request confirmation, returns true if user confirms otherwise returns false.

    .DESCRIPTION
        Returns true if user has VIEW SERVER STATE permission in SQL Server, otherwise warns about lack of permissions and request confirmation, returns true if user confirms otherwise returns false.
    
    .PARAMETER SQLUser
        Optional. SQL Server User Name for SQL Authentication

    .PARAMETER SQLPassword
        Optional. SQL Server Password for SQL Authentication

    .EXAMPLE
        Confirm-SQLPermissions -SQLInstance "SERVER"
        Confirm-SQLPermissions -SQLInstance "SRV\INST" -SQLUser "sqllogin" -Password "sqlpwd"
#>
[CmdletBinding()]
param ( 
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$SQLUser,
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$SQLPwd
    )

    Write-LogDebug "inside " $MyInvocation.MyCommand

    if (($global:sql_instance_conn_str -eq $NO_INSTANCE_NAME) -or ($true -eq $global:instance_independent_collection ) )
    {
        Write-LogWarning "No SQL Server instance found or Instance-independent collection. SQL Permissions-checking is not necessary"
        return $true
    }
    elseif ($global:sql_instance_conn_str -ne "")
    {
        $SQLInstance = $global:sql_instance_conn_str
    }
    else {
        Write-LogError "SQL Server instance name is empty. Exiting..."
        exit
    }
    
    $SQLInstanceUpperCase = $SQLInstance.ToUpper()
    Write-LogDebug "Received parameter SQLInstance: `"$SQLInstance`"" -DebugLogLevel 2
    Write-LogDebug "Received parameter SQLUser: `"$SQLUser`"" -DebugLogLevel 2
    Write-LogDebug "Received parameter SQLPassword (true/false): " (-not ($null -eq $SQLPassword)) #we don't print the password, just inform if we received it or not

    #query bellow does substring of SERVERPROPERTY('ProductVersion') instead of using SERVERPROPERTY('ProductMajorVersion') for backward compatibility with SQL Server 2012 & 2014
    $SqlQuery = "select SUSER_SNAME() login_name, HAS_PERMS_BY_NAME(null, null, 'view server state') has_view_server_state, HAS_PERMS_BY_NAME(NULL, NULL, 'ALTER ANY EVENT SESSION') has_alter_any_event_session, LEFT(CAST(SERVERPROPERTY(N'ProductVersion') AS NVARCHAR(128)), (CHARINDEX(N'.', CAST(SERVERPROPERTY(N'ProductVersion') AS NVARCHAR(128)))-1)) sql_major_version"
    $ConnString = "Server=$SQLInstance;Database=master;"

    #if either SQLUser or SQLPassword are null we setup Integrated Authentication
    #otherwise if we received both we setup SQL Authentication
    if (($null -eq $SQLUser) -or ($null -eq $SQLPassword))
    {
        $ConnString += "Integrated Security=True;"
    } else
    {
        $ConnString += "User Id=$SQLUser;Password=$SQLPassword"
    }

    Write-LogDebug "Creating SqlClient objects and setting parameters" -DebugLogLevel 2
    $SqlConnection = New-Object System.Data.SqlClient.SqlConnection
    $SqlConnection.ConnectionString = $ConnString
    $SqlCmd = New-Object System.Data.SqlClient.SqlCommand
    $SqlCmd.CommandText = $SqlQuery
    $SqlCmd.Connection = $SqlConnection
    $SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
    $SqlAdapter.SelectCommand = $SqlCmd
    $DataSet = New-Object System.Data.DataSet

    Write-LogDebug "About to call SqlDataAdapter.Fill()" -DebugLogLevel 2
    try {
        $SqlAdapter.Fill($DataSet) | Out-Null #fill method returns rowcount, Out-Null prevents the number from being printed in console    
    }
    catch {
        Write-LogError "Could not connect to SQL Server instance '$SQLInstance' to validate permissions."
        
        $mycommand = $MyInvocation.MyCommand
        $error_msg = $PSItem.Exception.InnerException.Message 
        Write-LogError "$mycommand Function failed with error:  $error_msg"
        
        # we can't connect to SQL, probably whole capture will fail, so we just abort here
        return $false
    }
    
    Write-LogDebug "Closing SqlConnection" -DebugLogLevel 2
    $SqlConnection.Close()

    $global:sql_major_version = $DataSet.Tables[0].Rows[0].sql_major_version
    Write-LogDebug "SQL Major Version: " $global:sql_major_version -DebugLogLevel 3

    $account = $DataSet.Tables[0].Rows[0].login_name

    if ((1 -eq $DataSet.Tables[0].Rows[0].has_view_server_state) -and (1 -eq $DataSet.Tables[0].Rows[0].has_alter_any_event_session))
    {
        Write-LogDebug "has_view_server_state returned 1" -DebugLogLevel 2
        Write-LogInformation "Confirmed that $account has VIEW SERVER STATE on SQL Server Instance '$SQLInstanceUpperCase'"
        Write-LogInformation "Confirmed that $account has ALTER ANY EVENT SESSION on SQL Server Instance '$SQLInstanceUpperCase'"
        return $true #user has view server state
    } else {

        Write-LogDebug "either has_view_server_state or has_alter_any_event_session returned different than one, user does not have view server state" -DebugLogLevel 2
        #user does not have view server state

        Write-LogWarning "User account $account does not posses the required privileges in SQL Server instance '$SQLInstanceUpperCase'"
        Write-LogWarning "Proceeding with capture will result in SQLDiag not producing the necessary information."
        Write-LogWarning "To grant minimum privilege for a successful data capture, connect to SQL Server instance '$SQLInstanceUpperCase' using administrative account and execute the following:"
        Write-LogWarning ""

        if (1 -ne $DataSet.Tables[0].Rows[0].has_view_server_state) {
            Write-LogWarning "GRANT VIEW SERVER STATE TO [$account]"
        }

        if (1 -ne $DataSet.Tables[0].Rows[0].has_alter_any_event_session) {
            Write-LogWarning "GRANT ALTER ANY EVENT SESSION TO [$account]"
        }

        Write-LogWarning ""
        Write-LogWarning "One or more conditions that will affect the quality of data capture were detected."

        [string]$confirm = $null
        while (-not(($confirm -eq "Y") -or ($confirm -eq "N") -or ($null -eq $confirm)))
        {
            Write-LogWarning "Would you like to proceed capture without required permissions? (Y/N)"
            $confirm = Read-Host ">" -CustomLogMessage "SQL Permission Console input:"

            $confirm = $confirm.ToString().ToUpper()
            if (-not(($confirm -eq "Y") -or ($confirm -eq "N") -or ($null -eq $confirm)))
            {
                Write-LogError ""
                Write-LogError "Please chose [Y] to proceed capture without required permissions."
                Write-LogError "Please chose [N] to abort capture."
                Write-LogError ""
            }
        }

        if ($confirm -eq "Y"){ #user chose to continue
            return $true
        } else { #user chose to abort
            return $false
        }
    }

}
function HandleCtrlC ()
{
    if ($Host.UI.RawUI.KeyAvailable -and (3 -eq [int]$Host.UI.RawUI.ReadKey("AllowCtrlC,IncludeKeyUp,IncludeKeyDown,NoEcho").Character))
    {
       Write-LogWarning "*******************"
       Write-LogWarning "You pressed CTRL-C. Stopping diagnostic collection..."
       Write-LogWarning "*******************"
       Invoke-DiagnosticCleanUpAndExit
       break
    }

    #if no CTRL+C just return and move on
    return
    
}

function HandleCtrlCFinal ()
{
    while ($true)
    {

        if ($Host.UI.RawUI.KeyAvailable -and (3 -eq [int]$Host.UI.RawUI.ReadKey("AllowCtrlC,IncludeKeyUp,IncludeKeyDown,NoEcho").Character))
        {
            Write-LogWarning "<*******************>"
            Write-LogWarning "You pressed CTRL-C. Stopping diagnostic collection..."
            Write-LogWarning "<*******************>"
            Invoke-DiagnosticCleanUpAndExit
        }
		
		else
		{
			Invoke-DiagnosticCleanUpAndExit
			break;
		}
    }
}



function GetPerformanceDataAndLogs 
{
   try 
   {
        Write-LogDebug "inside" $MyInvocation.MyCommand
        
        [bool] $Continue = $false

        #prompt for diagnostic scenario
        $Continue = Select-Scenario
        if ($false -eq $Continue)
        {
            Write-LogInformation "No diagnostic logs will be collected because no scenario is selected. Exiting..."
            return
        }


        #pick a sql instnace
        Pick-SQLServer-for-Diagnostics

        #check SQL permission and continue only if user has permissions or user confirms to continue without permissions
        $Continue = Confirm-SQLPermissions 
        if ($false -eq $Continue)
        {
            Write-LogInformation "No diagnostic logs will be collected due to insufficient SQL permissions. Exiting..."
            return
        }

        # validate SQL startup account write permissions to \output folder
        $Continue = Confirm-WritePermsStartupAccount
        if ($false -eq $Continue)
        {
            Write-LogInformation "No diagnostic logs will be collected. Exiting..."
            return
        }

        #prepare a pefmon counters file with specific instance info
        PrepareCountersFile

        #start collecting data
        Start-DiagCollectors
        
        #stop data collection
        Stop-DiagCollectors
        
   }
   catch 
   {
        $mycommand = $MyInvocation.MyCommand
        $error_msg = $PSItem.Exception.Message 
        $call_stack = $PSItem.Exception.InnerException 
        Write-LogError "Function '$mycommand' failed with error:  $error_msg"
        Write-LogError "Function '$mycommand' :  $call_stack"
   }
   
}

function PrintHelp ([string]$ValidArguments ="", [int]$index=777, [bool]$brief_help = $true)
{
   if ($brief_help -eq $true)
   {

       $debugLevelHlpStr = "`n[-DebugLevel <int>] " 
       $scenarioHlpStr = "`n[-Scenario <string[]>] "
       $serverInstHlpStr = "`n[-ServerInstanceConStr <string>] " 
       $customOutputPathHlpStr = "`n[-CustomOutputPath <string>] "
       $delExistingOrCreateNewHlpStr = "`n[-DeleteExistingOrCreateNew <string>] "
       $DiagStartTimeHlpStr = "`n[-DiagStartTime <string>] "
       $DiagStopTimeHlpStr = "`n[-DiagStopTime <string>] "
       $InteractivePromptsHlpStr = "`n[-InteractivePrompts <string>] " 
       
        

       switch ($index) 
       {
           0 { $debugLevelHlpStr = $debugLevelHlpStr + "<" + $ValidArguments +">"}
           1 { $scenarioHlpStr = $scenarioHlpStr + "<" + $ValidArguments +">"}
           2 { $serverInstHlpStr = $serverInstHlpStr + "<" + $ValidArguments +">"}
           3 { $customOutputPathHlpStr = $customOutputPathHlpStr + "<" + $ValidArguments +">"}
           4 { $delExistingOrCreateNewHlpStr = $delExistingOrCreateNewHlpStr + "<" + $ValidArguments +">"}
           5 { $DiagStartTimeHlpStr= $DiagStartTimeHlpStr + "<" + $ValidArguments +">"}
           6 { $DiagStopTimeHlpStr = $DiagStopTimeHlpStr + "<" + $ValidArguments +">"}
           7 { $InteractivePromptsHlpStr = $InteractivePromptsHlpStr + "<" + $ValidArguments +">"}
       }

   

       $HelpString = "`nSQL_LogScout `n" `
       + $debugLevelHlpStr  `
       + $scenarioHlpStr `
       + $serverInstHlpStr `
       + $customOutputPathHlpStr `
       + $delExistingOrCreateNewHlpStr `
       + $DiagStartTimeHlpStr`
       + $DiagStopTimeHlpStr `
       + $InteractivePromptsHlpStr + "`n" `


       Microsoft.PowerShell.Utility\Write-Host $HelpString
    }
    else {
    

        Microsoft.PowerShell.Utility\Write-Host "

        sql_logscout.cmd [-DebugLevel <int>] [-Scenario <string[]>] [-ServerInstanceConStr <string>] [-CustomOutputPath <string>] [-DeleteExistingOrCreateNew <string>] [-DiagStartTime <string>] [-DiagStopTime <string>] [-InteractivePrompts <string>] [<CommonParameters>]
        
        DESCRIPTION
            SQL LogScout allows you to collect diagnostic logs from your SQL Server 
            system to help you and Microsoft technical support engineers (CSS) to 
            resolve SQL Server technical incidents faster. 
            
        ONLINE HELP:    
            You can find help for SQLLogScout help PowerShell online  
            at https://github.com/microsoft/sql_logscout 

        EXAMPLES:
            A. Execute SQL LogScout (most common execution)
            This is the most common method to execute SQL LogScout which allows you to pick your choices from a menu of options " -ForegroundColor Green

        Microsoft.PowerShell.Utility\Write-Host " "
        Microsoft.PowerShell.Utility\Write-Host "               SQL_LogScout.cmd"

        Microsoft.PowerShell.Utility\Write-Host "
            B. Execute SQL LogScout using a specific scenario and debug level. This command starts the diagnostic collection with 
            no debug logging and specifies the GeneralPerf scenario." -ForegroundColor Green

        Microsoft.PowerShell.Utility\Write-Host " "
        Microsoft.PowerShell.Utility\Write-Host "               SQL_LogScout.cmd 0 GeneralPerf" 
            
        Microsoft.PowerShell.Utility\Write-Host "
            C. Execute SQL LogScout by specifying folder creation option
            Execute SQL LogScout using the DetailedPerf Scenario, DebugLevel 2, specifies the Server name, 
            use the present directory and folder option to delete the default \output folder if present" -ForegroundColor Green

        Microsoft.PowerShell.Utility\Write-Host " "
        Microsoft.PowerShell.Utility\Write-Host "               SQL_LogScout.cmd 2 DetailedPerf SQLInstanceName ""UsePresentDir""  ""DeleteDefaultFolder"" "
            
        Microsoft.PowerShell.Utility\Write-Host "
            D. Execute SQL LogScout with start and stop times
            
            The following example uses debuglevel 5, collects the AlwaysOn scenario against the ""DbSrv""  default instance, 
            prompts user to choose a custom path and a new custom subfolder, and sets the stop time to some time in the future, 
            while setting the start time in the past to ensure the collectors start without delay. " -ForegroundColor Green

        Microsoft.PowerShell.Utility\Write-Host " "
        Microsoft.PowerShell.Utility\Write-Host "               SQL_LogScout.cmd 5 AlwaysOn ""DbSrv"" ""PromptForCustomDir""  ""NewCustomFolder""  ""2000-01-01 19:26:00"" ""2020-10-29 13:55:00""  "


        Microsoft.PowerShell.Utility\Write-Host "
            Note: All parameters are required if you need to specify the last parameter. For example, if you need to specify stop time, 
            the 5 prior parameters have to be passed.

            E. Execute SQL LogScout with multiple scenarios and in Quiet mode

            The example uses debuglevel 5, collects data for GeneralPerf, AlwaysOn, and BackupRestore scenarios against the a default instance, 
            re-uses the default \output folder but creates it in the ""D:\Log"" custom path, and sets the stop time to some time in the future, 
            while setting the start time in the past to ensure the collectors start without delay. It also automatically accepts the prompts 
            by using Quiet mode and helps a full automation with no interaction." -ForegroundColor Green

            Microsoft.PowerShell.Utility\Write-Host " "
            Microsoft.PowerShell.Utility\Write-Host "               SQL_LogScout.cmd 5 GeneralPerf+AlwaysOn+BackupRestore ""DbSrv"" ""d:\log"" ""DeleteDefaultFolder"" ""01-01-2000"" ""04-01-2021 17:00"" Quiet "
            
        Microsoft.PowerShell.Utility\Write-Host "
            Note: Selecting Quiet mode implicitly selects ""Y"" to all the screens that requires your agreement to proceed."  -ForegroundColor Green
        
        Microsoft.PowerShell.Utility\Write-Host ""
    }

    #Exit the program at this point
    #exit
}

function ValidateParameters ()
{

    #validate the $DebugLevel parameter
    $DbgLevelArr = 0..5
    if ($DebugLevel -inotin $DbgLevelArr)
    {
        Write-LogError "Parameter 'DebugLevel' can only accept one of these values: $DbgLevelArr. Current value $DebugLevel is incorrect."
        PrintHelp -ValidArguments $DbgLevelArr -index 0
        return $false
    }

    #validate the Scenario parameter
    if ([String]::IsNullOrWhiteSpace($Scenario) -eq $false)
    {
        $ScenarioArrayParam = $Scenario.Split('+')
        [string[]] $localScenArray = @(("Basic","GeneralPerf", "DetailedPerf", "Replication", "AlwaysOn","NetworkTrace","Memory","DumpMemory","WPR", "Setup", "BackupRestore","IO", "LightPerf","MenuChoice"))
        try 
        {
            foreach ($scenItem in $ScenarioArrayParam)
            {
                if (($localScenArray -notcontains $scenItem))
                {
                    Write-LogError "Parameter 'Scenario' only accepts these values individually or combined, separated by '+' (e.g Basic+AlwaysOn):`n $localScenArray. Current value '$scenItem' is incorrect."
                    PrintHelp -ValidArguments $localScenArray -index 1
                    return $false
                }
            }
        }
        catch 
        {
            $mycommand = $MyInvocation.MyCommand
            $error_msg = $PSItem.Exception.Message 
            Write-LogError "Function '$mycommand' failed with error:  $error_msg"
        }

    }
        
    #validate CustomOutputPath parameter

    $CustomOutputParamArr = @("UsePresentDir", "PromptForCustomDir")
    if( ($CustomOutputPath -inotin $CustomOutputParamArr) -and ((Test-Path -Path $CustomOutputPath -PathType Container) -eq $false) )
    {
        Write-LogError "Parameter 'CustomOutputPath' accepts an existing folder path OR one of these values: $CustomOutputParamArr. Value '$CustomOutputPath' is incorrect."
        PrintHelp -ValidArguments $CustomOutputParamArr -index 3
        return $false
    }
    
    #validate DeleteExistingOrCreateNew parameter
    if ([String]::IsNullOrWhiteSpace($DeleteExistingOrCreateNew) -eq $false)
    {
        $DelExistingOrCreateNewParamArr = @("DeleteDefaultFolder","NewCustomFolder")
        if($DeleteExistingOrCreateNew -inotin $DelExistingOrCreateNewParamArr)
        {
            Write-LogError "Parameter 'DeleteExistingOrCreateNew' can only accept one of these values: $DelExistingOrCreateNewParamArr. Current value '$DeleteExistingOrCreateNew' is incorrect."
            PrintHelp -ValidArguments $DelExistingOrCreateNewParamArr -index 4
            return $false
        }
    }

    #validate DiagStartTime parameter
    if ($DiagStartTime -ne "0000")
    {
        [DateTime] $dtStartOut = New-Object DateTime
        if([DateTime]::TryParse($DiagStartTime, [System.Globalization.CultureInfo]::InvariantCulture, [System.Globalization.DateTimeStyles]::None, [ref]$dtStartOut) -eq $false)
        {
            Write-LogError "Parameter 'DiagStartTime' accepts DateTime values (e.g. `"2021-07-07 17:14:00`"). Current value '$DiagStartTime' is incorrect."
            PrintHelp -ValidArguments "yyyy-MM-dd hh:mm:ss" -index 5
            return $false
        }
    }
    

    #validate DiagStopTime parameter
    if ($DiagStopTime -ne "0000")
    {
        [DateTime] $dtStopOut = New-Object DateTime
        if([DateTime]::TryParse($DiagStopTime, [System.Globalization.CultureInfo]::InvariantCulture, [System.Globalization.DateTimeStyles]::None, [ref]$dtStopOut) -eq $false)
        {
            Write-LogError "Parameter 'DiagStopTime' accepts DateTime values (e.g. `"2021-07-07 17:14:00`"). Current value '$DiagStopTime' is incorrect."
            PrintHelp -ValidArguments "yyyy-MM-dd hh:mm:ss" -index 6
            return $false
        }
    }
    #validate InteractivePrompts parameter
    $InteractivePromptsParamArr = @("Quiet","Noisy")
    if($InteractivePrompts -inotin $InteractivePromptsParamArr)
    {
        Write-LogError "Parameter 'InteractivePrompts' can only accept one of these values: $InteractivePromptsParamArr. Current value '$InteractivePrompts' is incorrect."
        PrintHelp -ValidArguments $InteractivePromptsParamArr -index 7
        return $false
    }

    else 
    {
        return $true
    }
}


function Start-SQLLogScout 
{
    Write-LogDebug "inside " $MyInvocation.MyCommand
    Write-LogDebug "Scenario prameter passed is '$Scenario'" -DebugLogLevel 3

    try 
    {  
        Init-AppVersion
    
        #check for administrator rights
        Check-ElevatedAccess
    
        #initialize globals for present folder, output folder, internal\error folder
        InitCriticalDirectories
        

        #check if output folder is already present and if so prompt for deletion. Then create new if deleted, or reuse
        Reuse-or-RecreateOutputFolder
    
        #create a log of events
        Initialize-Log -LogFilePath $global:internal_output_folder -LogFileName "##SQLLOGSCOUT.LOG"
        
        #check file attributes against expected attributes
        $validFileAttributes = Confirm-FileAttributes
        if (-not($validFileAttributes)){
            Write-LogInformation "File attribute validation FAILED. Exiting..."
            return
        }
        
        #invoke the main collectors code
        GetPerformanceDataAndLogs
    
        Write-LogInformation "Ending data collection" #DO NOT CHANGE - Message is backward compatible
    }   
    catch{
        # Write-Error $_
        # Write-Error $_.ScriptStackTrace

        $mycommand = $MyInvocation.MyCommand
        $error_msg = $PSItem.Exception.Message 
        $call_stack = $PSItem.Exception.InnerException 
        Write-LogError "Function '$mycommand' failed with error:  $error_msg"
        Write-LogError "Function '$mycommand' :  $call_stack"
    }
    finally {
        HandleCtrlCFinal
        Write-LogInformation ""
    }
}
function CopyrightAndWarranty()
{
    Microsoft.PowerShell.Utility\Write-Host "Copyright (c) 2021 Microsoft Corporation. All rights reserved. `n
    THE SOFTWARE IS PROVIDED `"AS IS`", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE. `n`n"
}

function main () 
{
    
    #print copyright message
    CopyrightAndWarranty

    #validate parameters
    $ret = ValidateParameters

    #start program
    if ($ret -eq $true)
    {
        Start-SQLLogScout
    }

}




#to execute from command prompt use: 
#powershell -ExecutionPolicy Bypass -File sqllogscoutps.ps1

main

# SIG # Begin signature block
# MIIjoAYJKoZIhvcNAQcCoIIjkTCCI40CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAa4dLDmk5NREd/
# uisU/Gza0zYqLYHeWge2kWrhuFHyMaCCDYEwggX/MIID56ADAgECAhMzAAAB32vw
# LpKnSrTQAAAAAAHfMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjAxMjE1MjEzMTQ1WhcNMjExMjAyMjEzMTQ1WjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQC2uxlZEACjqfHkuFyoCwfL25ofI9DZWKt4wEj3JBQ48GPt1UsDv834CcoUUPMn
# s/6CtPoaQ4Thy/kbOOg/zJAnrJeiMQqRe2Lsdb/NSI2gXXX9lad1/yPUDOXo4GNw
# PjXq1JZi+HZV91bUr6ZjzePj1g+bepsqd/HC1XScj0fT3aAxLRykJSzExEBmU9eS
# yuOwUuq+CriudQtWGMdJU650v/KmzfM46Y6lo/MCnnpvz3zEL7PMdUdwqj/nYhGG
# 3UVILxX7tAdMbz7LN+6WOIpT1A41rwaoOVnv+8Ua94HwhjZmu1S73yeV7RZZNxoh
# EegJi9YYssXa7UZUUkCCA+KnAgMBAAGjggF+MIIBejAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQUOPbML8IdkNGtCfMmVPtvI6VZ8+Mw
# UAYDVR0RBEkwR6RFMEMxKTAnBgNVBAsTIE1pY3Jvc29mdCBPcGVyYXRpb25zIFB1
# ZXJ0byBSaWNvMRYwFAYDVQQFEw0yMzAwMTIrNDYzMDA5MB8GA1UdIwQYMBaAFEhu
# ZOVQBdOCqhc3NyK1bajKdQKVMFQGA1UdHwRNMEswSaBHoEWGQ2h0dHA6Ly93d3cu
# bWljcm9zb2Z0LmNvbS9wa2lvcHMvY3JsL01pY0NvZFNpZ1BDQTIwMTFfMjAxMS0w
# Ny0wOC5jcmwwYQYIKwYBBQUHAQEEVTBTMFEGCCsGAQUFBzAChkVodHRwOi8vd3d3
# Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NlcnRzL01pY0NvZFNpZ1BDQTIwMTFfMjAx
# MS0wNy0wOC5jcnQwDAYDVR0TAQH/BAIwADANBgkqhkiG9w0BAQsFAAOCAgEAnnqH
# tDyYUFaVAkvAK0eqq6nhoL95SZQu3RnpZ7tdQ89QR3++7A+4hrr7V4xxmkB5BObS
# 0YK+MALE02atjwWgPdpYQ68WdLGroJZHkbZdgERG+7tETFl3aKF4KpoSaGOskZXp
# TPnCaMo2PXoAMVMGpsQEQswimZq3IQ3nRQfBlJ0PoMMcN/+Pks8ZTL1BoPYsJpok
# t6cql59q6CypZYIwgyJ892HpttybHKg1ZtQLUlSXccRMlugPgEcNZJagPEgPYni4
# b11snjRAgf0dyQ0zI9aLXqTxWUU5pCIFiPT0b2wsxzRqCtyGqpkGM8P9GazO8eao
# mVItCYBcJSByBx/pS0cSYwBBHAZxJODUqxSXoSGDvmTfqUJXntnWkL4okok1FiCD
# Z4jpyXOQunb6egIXvkgQ7jb2uO26Ow0m8RwleDvhOMrnHsupiOPbozKroSa6paFt
# VSh89abUSooR8QdZciemmoFhcWkEwFg4spzvYNP4nIs193261WyTaRMZoceGun7G
# CT2Rl653uUj+F+g94c63AhzSq4khdL4HlFIP2ePv29smfUnHtGq6yYFDLnT0q/Y+
# Di3jwloF8EWkkHRtSuXlFUbTmwr/lDDgbpZiKhLS7CBTDj32I0L5i532+uHczw82
# oZDmYmYmIUSMbZOgS65h797rj5JJ6OkeEUJoAVwwggd6MIIFYqADAgECAgphDpDS
# AAAAAAADMA0GCSqGSIb3DQEBCwUAMIGIMQswCQYDVQQGEwJVUzETMBEGA1UECBMK
# V2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0
# IENvcnBvcmF0aW9uMTIwMAYDVQQDEylNaWNyb3NvZnQgUm9vdCBDZXJ0aWZpY2F0
# ZSBBdXRob3JpdHkgMjAxMTAeFw0xMTA3MDgyMDU5MDlaFw0yNjA3MDgyMTA5MDla
# MH4xCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdS
# ZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMT
# H01pY3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTEwggIiMA0GCSqGSIb3DQEB
# AQUAA4ICDwAwggIKAoICAQCr8PpyEBwurdhuqoIQTTS68rZYIZ9CGypr6VpQqrgG
# OBoESbp/wwwe3TdrxhLYC/A4wpkGsMg51QEUMULTiQ15ZId+lGAkbK+eSZzpaF7S
# 35tTsgosw6/ZqSuuegmv15ZZymAaBelmdugyUiYSL+erCFDPs0S3XdjELgN1q2jz
# y23zOlyhFvRGuuA4ZKxuZDV4pqBjDy3TQJP4494HDdVceaVJKecNvqATd76UPe/7
# 4ytaEB9NViiienLgEjq3SV7Y7e1DkYPZe7J7hhvZPrGMXeiJT4Qa8qEvWeSQOy2u
# M1jFtz7+MtOzAz2xsq+SOH7SnYAs9U5WkSE1JcM5bmR/U7qcD60ZI4TL9LoDho33
# X/DQUr+MlIe8wCF0JV8YKLbMJyg4JZg5SjbPfLGSrhwjp6lm7GEfauEoSZ1fiOIl
# XdMhSz5SxLVXPyQD8NF6Wy/VI+NwXQ9RRnez+ADhvKwCgl/bwBWzvRvUVUvnOaEP
# 6SNJvBi4RHxF5MHDcnrgcuck379GmcXvwhxX24ON7E1JMKerjt/sW5+v/N2wZuLB
# l4F77dbtS+dJKacTKKanfWeA5opieF+yL4TXV5xcv3coKPHtbcMojyyPQDdPweGF
# RInECUzF1KVDL3SV9274eCBYLBNdYJWaPk8zhNqwiBfenk70lrC8RqBsmNLg1oiM
# CwIDAQABo4IB7TCCAekwEAYJKwYBBAGCNxUBBAMCAQAwHQYDVR0OBBYEFEhuZOVQ
# BdOCqhc3NyK1bajKdQKVMBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIAQwBBMAsGA1Ud
# DwQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaAFHItOgIxkEO5FAVO
# 4eqnxzHRI4k0MFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9jcmwubWljcm9zb2Z0
# LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01pY1Jvb0NlckF1dDIwMTFfMjAxMV8wM18y
# Mi5jcmwwXgYIKwYBBQUHAQEEUjBQME4GCCsGAQUFBzAChkJodHRwOi8vd3d3Lm1p
# Y3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY1Jvb0NlckF1dDIwMTFfMjAxMV8wM18y
# Mi5jcnQwgZ8GA1UdIASBlzCBlDCBkQYJKwYBBAGCNy4DMIGDMD8GCCsGAQUFBwIB
# FjNodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2RvY3MvcHJpbWFyeWNw
# cy5odG0wQAYIKwYBBQUHAgIwNB4yIB0ATABlAGcAYQBsAF8AcABvAGwAaQBjAHkA
# XwBzAHQAYQB0AGUAbQBlAG4AdAAuIB0wDQYJKoZIhvcNAQELBQADggIBAGfyhqWY
# 4FR5Gi7T2HRnIpsLlhHhY5KZQpZ90nkMkMFlXy4sPvjDctFtg/6+P+gKyju/R6mj
# 82nbY78iNaWXXWWEkH2LRlBV2AySfNIaSxzzPEKLUtCw/WvjPgcuKZvmPRul1LUd
# d5Q54ulkyUQ9eHoj8xN9ppB0g430yyYCRirCihC7pKkFDJvtaPpoLpWgKj8qa1hJ
# Yx8JaW5amJbkg/TAj/NGK978O9C9Ne9uJa7lryft0N3zDq+ZKJeYTQ49C/IIidYf
# wzIY4vDFLc5bnrRJOQrGCsLGra7lstnbFYhRRVg4MnEnGn+x9Cf43iw6IGmYslmJ
# aG5vp7d0w0AFBqYBKig+gj8TTWYLwLNN9eGPfxxvFX1Fp3blQCplo8NdUmKGwx1j
# NpeG39rz+PIWoZon4c2ll9DuXWNB41sHnIc+BncG0QaxdR8UvmFhtfDcxhsEvt9B
# xw4o7t5lL+yX9qFcltgA1qFGvVnzl6UJS0gQmYAf0AApxbGbpT9Fdx41xtKiop96
# eiL6SJUfq/tHI4D1nvi/a7dLl+LrdXga7Oo3mXkYS//WsyNodeav+vyL6wuA6mk7
# r/ww7QRMjt/fdW1jkT3RnVZOT7+AVyKheBEyIXrvQQqxP/uozKRdwaGIm1dxVk5I
# RcBCyZt2WwqASGv9eZ/BvW1taslScxMNelDNMYIVdTCCFXECAQEwgZUwfjELMAkG
# A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQx
# HjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEoMCYGA1UEAxMfTWljcm9z
# b2Z0IENvZGUgU2lnbmluZyBQQ0EgMjAxMQITMwAAAd9r8C6Sp0q00AAAAAAB3zAN
# BglghkgBZQMEAgEFAKCByDAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgor
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgulm8qkvU
# 7ziqURrfRzZ3D62g15JhSRWA5ykgaGj186owXAYKKwYBBAGCNwIBDDFOMEygLIAq
# AFMAUQBMACAATABvAGcAUwBjAG8AdQB0ACAAQwBvAGQAZQBTAGkAZwBuoRyAGmh0
# dHBzOi8vYWthLm1zL3NxbGxvZ3Njb3V0MA0GCSqGSIb3DQEBAQUABIIBAGTTO2X/
# MVcdH1uD8ZmykFCjc8/lV2bvH3CTgDJTOcJcTet5ZrVBoQd4enFX/H6PxU9RqRSv
# 2U0bSimphy1x4pCw+BBww14srXWQxBOhSAL4hWO3eJrbiNPkg/C3r2LU57G4Po/6
# nUIZ4Niot4S00S+1alf1y5kXMoUzK+HpVj5XdP7mu/G5dEKSrdtCML/U/NEfbOFO
# qCaCN3JeTE5F/0DkN843yW15m6sCeVHTAgQ5kBfzyNN3nTKlccLDf+yj9R0ojfa3
# zhB0mFKgrltU2M7RviI859arH4mm7+u/thN9ov+VLF+KW9mQqnoKx7pq1ouhOXy8
# Hr8+bBjLuBUHQHKhghLlMIIS4QYKKwYBBAGCNwMDATGCEtEwghLNBgkqhkiG9w0B
# BwKgghK+MIISugIBAzEPMA0GCWCGSAFlAwQCAQUAMIIBUQYLKoZIhvcNAQkQAQSg
# ggFABIIBPDCCATgCAQEGCisGAQQBhFkKAwEwMTANBglghkgBZQMEAgEFAAQggvvS
# lZx5iKBDvdztL5aGt82ukUbiAL1FQk0ePQxQhJACBmEVvWPifxgTMjAyMTA5MTAy
# MTAxMzguMTI3WjAEgAIB9KCB0KSBzTCByjELMAkGA1UEBhMCVVMxEzARBgNVBAgT
# Cldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29m
# dCBDb3Jwb3JhdGlvbjElMCMGA1UECxMcTWljcm9zb2Z0IEFtZXJpY2EgT3BlcmF0
# aW9uczEmMCQGA1UECxMdVGhhbGVzIFRTUyBFU046M0U3QS1FMzU5LUEyNUQxJTAj
# BgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2Wggg48MIIE8TCCA9mg
# AwIBAgITMwAAAVIwS12JrOZwRwAAAAABUjANBgkqhkiG9w0BAQsFADB8MQswCQYD
# VQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEe
# MBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3Nv
# ZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDAeFw0yMDExMTIxODI2MDVaFw0yMjAyMTEx
# ODI2MDVaMIHKMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4G
# A1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUw
# IwYDVQQLExxNaWNyb3NvZnQgQW1lcmljYSBPcGVyYXRpb25zMSYwJAYDVQQLEx1U
# aGFsZXMgVFNTIEVTTjozRTdBLUUzNTktQTI1RDElMCMGA1UEAxMcTWljcm9zb2Z0
# IFRpbWUtU3RhbXAgU2VydmljZTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
# ggEBAK7MboSJmHS1oJJuzAyK6kxNidtugXOOPUO4Ntu9PRFcoEJWX+6YD5TLbXgO
# YeIWGR65F2UsHTJrlL26bloqvuUEGpnO+0qAY2AJFsNMb1i7qTMPM9PNBG6VUi+h
# ZXLSAhOcTKgnU7ebkg+mwsE1AJ1eyH7dNkXvckBy5vbVufGb/izF7jNN1t220Gup
# fz8kkXZUScA/4wG8XZRBKjpdQBpMoL8c8M8Jx78iw2gDHEsMjXAeEiWqNEGe3gcz
# kdwoetmu8f68eeKGKR2UTOHd+NAWjCTV8bs9WGY7rQ7m9V2oD4f3fXiEcQ1AjRxu
# j5KRKLxJIlIs2LGCPR5Z49OHulsCAwEAAaOCARswggEXMB0GA1UdDgQWBBSE3a7a
# rCPWXZzaH+RQsO4FEmx7FDAfBgNVHSMEGDAWgBTVYzpcijGQ80N7fEYbxTNoWoVt
# VTBWBgNVHR8ETzBNMEugSaBHhkVodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20vcGtp
# L2NybC9wcm9kdWN0cy9NaWNUaW1TdGFQQ0FfMjAxMC0wNy0wMS5jcmwwWgYIKwYB
# BQUHAQEETjBMMEoGCCsGAQUFBzAChj5odHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20v
# cGtpL2NlcnRzL01pY1RpbVN0YVBDQV8yMDEwLTA3LTAxLmNydDAMBgNVHRMBAf8E
# AjAAMBMGA1UdJQQMMAoGCCsGAQUFBwMIMA0GCSqGSIb3DQEBCwUAA4IBAQBVxSdx
# 8WpJrNBsMRd/d3XT+6mJZBTkd1NvAb2/1t5UgNobigQvIhw0Tp7oJs4EyU9T6yal
# hhycreO5w2oKHCq4ubF2LaI/LiJDq+MB0Gn35UVaWsGpSw1dnOMKmAwJmPpu7xer
# Q2d2XhbIFsjQmS7ry9Q0bjCwx0o/d3P7UzOT1JSZrePsfI0Dnn12j2eEqahkyfl2
# 1/TdC/GVoTAwBo+T3G5S/0E3xw28WelaTiYsRFBbq0DetcrSygQhIpNgbs6x7ugx
# dkNg9bF/2gWFgrNnD9LCeF0GiPZLl7JgTcC4X9lfNHeF2nf9cbNl450RF8XLWsLt
# kHCEMhqN4UyLncafMIIGcTCCBFmgAwIBAgIKYQmBKgAAAAAAAjANBgkqhkiG9w0B
# AQsFADCBiDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNV
# BAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEyMDAG
# A1UEAxMpTWljcm9zb2Z0IFJvb3QgQ2VydGlmaWNhdGUgQXV0aG9yaXR5IDIwMTAw
# HhcNMTAwNzAxMjEzNjU1WhcNMjUwNzAxMjE0NjU1WjB8MQswCQYDVQQGEwJVUzET
# MBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMV
# TWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1T
# dGFtcCBQQ0EgMjAxMDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKkd
# Dbx3EYo6IOz8E5f1+n9plGt0VBDVpQoAgoX77XxoSyxfxcPlYcJ2tz5mK1vwFVMn
# BDEfQRsalR3OCROOfGEwWbEwRA/xYIiEVEMM1024OAizQt2TrNZzMFcmgqNFDdDq
# 9UeBzb8kYDJYYEbyWEeGMoQedGFnkV+BVLHPk0ySwcSmXdFhE24oxhr5hoC732H8
# RsEnHSRnEnIaIYqvS2SJUGKxXf13Hz3wV3WsvYpCTUBR0Q+cBj5nf/VmwAOWRH7v
# 0Ev9buWayrGo8noqCjHw2k4GkbaICDXoeByw6ZnNPOcvRLqn9NxkvaQBwSAJk3jN
# /LzAyURdXhacAQVPIk0CAwEAAaOCAeYwggHiMBAGCSsGAQQBgjcVAQQDAgEAMB0G
# A1UdDgQWBBTVYzpcijGQ80N7fEYbxTNoWoVtVTAZBgkrBgEEAYI3FAIEDB4KAFMA
# dQBiAEMAQTALBgNVHQ8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAW
# gBTV9lbLj+iiXGJo0T2UkFvXzpoYxDBWBgNVHR8ETzBNMEugSaBHhkVodHRwOi8v
# Y3JsLm1pY3Jvc29mdC5jb20vcGtpL2NybC9wcm9kdWN0cy9NaWNSb29DZXJBdXRf
# MjAxMC0wNi0yMy5jcmwwWgYIKwYBBQUHAQEETjBMMEoGCCsGAQUFBzAChj5odHRw
# Oi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY1Jvb0NlckF1dF8yMDEw
# LTA2LTIzLmNydDCBoAYDVR0gAQH/BIGVMIGSMIGPBgkrBgEEAYI3LgMwgYEwPQYI
# KwYBBQUHAgEWMWh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9QS0kvZG9jcy9DUFMv
# ZGVmYXVsdC5odG0wQAYIKwYBBQUHAgIwNB4yIB0ATABlAGcAYQBsAF8AUABvAGwA
# aQBjAHkAXwBTAHQAYQB0AGUAbQBlAG4AdAAuIB0wDQYJKoZIhvcNAQELBQADggIB
# AAfmiFEN4sbgmD+BcQM9naOhIW+z66bM9TG+zwXiqf76V20ZMLPCxWbJat/15/B4
# vceoniXj+bzta1RXCCtRgkQS+7lTjMz0YBKKdsxAQEGb3FwX/1z5Xhc1mCRWS3Tv
# QhDIr79/xn/yN31aPxzymXlKkVIArzgPF/UveYFl2am1a+THzvbKegBvSzBEJCI8
# z+0DpZaPWSm8tv0E4XCfMkon/VWvL/625Y4zu2JfmttXQOnxzplmkIz/amJ/3cVK
# C5Em4jnsGUpxY517IW3DnKOiPPp/fZZqkHimbdLhnPkd/DjYlPTGpQqWhqS9nhqu
# BEKDuLWAmyI4ILUl5WTs9/S/fmNZJQ96LjlXdqJxqgaKD4kWumGnEcua2A5HmoDF
# 0M2n0O99g/DhO3EJ3110mCIIYdqwUB5vvfHhAN/nMQekkzr3ZUd46PioSKv33nJ+
# YWtvd6mBy6cJrDm77MbL2IK0cs0d9LiFAR6A+xuJKlQ5slvayA1VmXqHczsI5pgt
# 6o3gMy4SKfXAL1QnIffIrE7aKLixqduWsqdCosnPGUFN4Ib5KpqjEWYw07t0Mkvf
# Y3v1mYovG8chr1m1rtxEPJdQcdeh0sVV42neV8HR3jDA/czmTfsNv11P6Z0eGTgv
# vM9YBS7vDaBQNdrvCScc1bN+NR4Iuto229Nfj950iEkSoYICzjCCAjcCAQEwgfih
# gdCkgc0wgcoxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYD
# VQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJTAj
# BgNVBAsTHE1pY3Jvc29mdCBBbWVyaWNhIE9wZXJhdGlvbnMxJjAkBgNVBAsTHVRo
# YWxlcyBUU1MgRVNOOjNFN0EtRTM1OS1BMjVEMSUwIwYDVQQDExxNaWNyb3NvZnQg
# VGltZS1TdGFtcCBTZXJ2aWNloiMKAQEwBwYFKw4DAhoDFQC/bp5Ulq6ZyZNyF3qG
# prJAw0NeW6CBgzCBgKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5n
# dG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9y
# YXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMA0G
# CSqGSIb3DQEBBQUAAgUA5OXOIjAiGA8yMDIxMDkxMDIwMjkyMloYDzIwMjEwOTEx
# MjAyOTIyWjB3MD0GCisGAQQBhFkKBAExLzAtMAoCBQDk5c4iAgEAMAoCAQACAgbR
# AgH/MAcCAQACAhFAMAoCBQDk5x+iAgEAMDYGCisGAQQBhFkKBAIxKDAmMAwGCisG
# AQQBhFkKAwKgCjAIAgEAAgMHoSChCjAIAgEAAgMBhqAwDQYJKoZIhvcNAQEFBQAD
# gYEAtCpSTdcwvC2vsQ5ZBQShsN81gnHYypWAJgBqxd9w2PveMgonE2o536k3yA4K
# CMUr0QnUINKdKkKsP+FZLp/pB3g/5pc6/Knljgyr/LXmi1UyH+gXod73odjEpml0
# 8uT7uJm9hVViXW6gcCXJQhuvv1ZjPZRSf4x1BLOf5x1IeGcxggMNMIIDCQIBATCB
# kzB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQD
# Ex1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMAITMwAAAVIwS12JrOZwRwAA
# AAABUjANBglghkgBZQMEAgEFAKCCAUowGgYJKoZIhvcNAQkDMQ0GCyqGSIb3DQEJ
# EAEEMC8GCSqGSIb3DQEJBDEiBCCH0lOcO+21SmiirCxKm7aHTfsyOo06KDYVcda7
# FqMRhTCB+gYLKoZIhvcNAQkQAi8xgeowgecwgeQwgb0EIJPuXMejiyVQjF8Qanwt
# dA2KT95wrq+64ZYhyYGuuyemMIGYMIGApH4wfDELMAkGA1UEBhMCVVMxEzARBgNV
# BAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
# c29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAg
# UENBIDIwMTACEzMAAAFSMEtdiazmcEcAAAAAAVIwIgQgKppX9if3k4xBo8M/jzUZ
# cVbIJrm/StUcSEq4TIqvtE4wDQYJKoZIhvcNAQELBQAEggEAS7r/ZfFs3SLNZ4dp
# 5g9i872WfvgVLIOlBNKJjXe5jrZnPqXFpkSYW2PUGCuTlGoIF22vCEHBLFZpYQ+Z
# EWXkiNmDiP1CgDbeXFcnaGx42Ff2J2wEErU8fUMBwfXH+Y9cvv2NpEPEG5CMciIh
# MB48gdZqrGDLryPezlzXNCOjwjLdVTXss8wjZX+bub0250DPRVOyTNmWgF/v38zw
# zaEEtO0KcEI27CAupvyyX4ajDRh+MVgkhz05JriKqvvNj6GsnpTCKtkiB1lUBo0f
# g3l4fR9tEjv6zaNbj4912u2syv/mqYnexldzI0u4BCwSAQSW/w81u+djkAJY/JvL
# fx8nnQ==
# SIG # End signature block
