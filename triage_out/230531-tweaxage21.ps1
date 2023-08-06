#requires -version 3.0

try { Microsoft.PowerShell.Core\Set-StrictMode -Off } catch { }

$script:MyModule = $MyInvocation.MyCommand.ScriptBlock.Module

$script:ClassName = 'ROOT\Microsoft\Windows\Defender\MSFT_MpScan'
$script:ClassVersion = '1.0'
$script:ModuleVersion = '1.0'
$script:ObjectModelWrapper = [Microsoft.PowerShell.Cmdletization.Cim.CimCmdletAdapter]

$script:PrivateData = [System.Collections.Generic.Dictionary[string,string]]::new()

Microsoft.PowerShell.Core\Export-ModuleMember -Function @()
        

function __cmdletization_BindCommonParameters
{
    param(
        $__cmdletization_objectModelWrapper,
        $myPSBoundParameters
    )       
                

        if ($myPSBoundParameters.ContainsKey('CimSession')) { 
            $__cmdletization_objectModelWrapper.PSObject.Properties['CimSession'].Value = $myPSBoundParameters['CimSession'] 
        }
                    

        if ($myPSBoundParameters.ContainsKey('ThrottleLimit')) { 
            $__cmdletization_objectModelWrapper.PSObject.Properties['ThrottleLimit'].Value = $myPSBoundParameters['ThrottleLimit'] 
        }
                    

        if ($myPSBoundParameters.ContainsKey('AsJob')) { 
            $__cmdletization_objectModelWrapper.PSObject.Properties['AsJob'].Value = $myPSBoundParameters['AsJob'] 
        }
                    

}
                

function Start-MpScan
{
    [CmdletBinding(PositionalBinding=$false)]
    
    
    param(
    
    [Parameter(ParameterSetName='Start0')]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    ${ScanPath},

    [Parameter(ParameterSetName='Start0')]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('FullScan','QuickScan','CustomScan')]
    [Microsoft.PowerShell.Cmdletization.GeneratedTypes.MpScan.ScanType]
    ${ScanType},

    [Parameter(ParameterSetName='Start0')]
    [Alias('Session')]
    [ValidateNotNullOrEmpty()]
    [Microsoft.Management.Infrastructure.CimSession[]]
    ${CimSession},

    [Parameter(ParameterSetName='Start0')]
    [int]
    ${ThrottleLimit},

    [Parameter(ParameterSetName='Start0')]
    [switch]
    ${AsJob})

    DynamicParam {
        try 
        {
            if (-not $__cmdletization_exceptionHasBeenThrown)
            {
                $__cmdletization_objectModelWrapper = $script:ObjectModelWrapper::new()
                $__cmdletization_objectModelWrapper.Initialize($PSCmdlet, $script:ClassName, $script:ClassVersion, $script:ModuleVersion, $script:PrivateData)

                if ($__cmdletization_objectModelWrapper -is [System.Management.Automation.IDynamicParameters])
                {
                    ([System.Management.Automation.IDynamicParameters]$__cmdletization_objectModelWrapper).GetDynamicParameters()
                }
            }
        }
        catch
        {
            $__cmdletization_exceptionHasBeenThrown = $true
            throw
        }
    }

    Begin {
        $__cmdletization_exceptionHasBeenThrown = $false
        try 
        {
            __cmdletization_BindCommonParameters $__cmdletization_objectModelWrapper $PSBoundParameters
            $__cmdletization_objectModelWrapper.BeginProcessing()
        }
        catch
        {
            $__cmdletization_exceptionHasBeenThrown = $true
            throw
        }
    }
        

    Process {
        try 
        {
            if (-not $__cmdletization_exceptionHasBeenThrown)
            {
      $__cmdletization_methodParameters = [System.Collections.Generic.List[Microsoft.PowerShell.Cmdletization.MethodParameter]]::new()

        [object]$__cmdletization_defaultValue = $null
        [object]$__cmdletization_defaultValueIsPresent = $false
        if ($PSBoundParameters.ContainsKey('ScanPath')) {
          [object]$__cmdletization_value = ${ScanPath}
          $__cmdletization_methodParameter = [Microsoft.PowerShell.Cmdletization.MethodParameter]@{Name = 'ScanPath'; ParameterType = 'System.String'; Bindings = 'In'; Value = $__cmdletization_value; IsValuePresent = $true}
        } else {
          $__cmdletization_methodParameter = [Microsoft.PowerShell.Cmdletization.MethodParameter]@{Name = 'ScanPath'; ParameterType = 'System.String'; Bindings = 'In'; Value = $__cmdletization_defaultValue; IsValuePresent = $__cmdletization_defaultValueIsPresent}
        }
        $__cmdletization_methodParameters.Add($__cmdletization_methodParameter)

        [object]$__cmdletization_defaultValue = $null
        [object]$__cmdletization_defaultValueIsPresent = $false
        if ($PSBoundParameters.ContainsKey('ScanType')) {
          [object]$__cmdletization_value = ${ScanType}
          $__cmdletization_methodParameter = [Microsoft.PowerShell.Cmdletization.MethodParameter]@{Name = 'ScanType'; ParameterType = 'Microsoft.PowerShell.Cmdletization.GeneratedTypes.MpScan.ScanType'; Bindings = 'In'; Value = $__cmdletization_value; IsValuePresent = $true}
        } else {
          $__cmdletization_methodParameter = [Microsoft.PowerShell.Cmdletization.MethodParameter]@{Name = 'ScanType'; ParameterType = 'Microsoft.PowerShell.Cmdletization.GeneratedTypes.MpScan.ScanType'; Bindings = 'In'; Value = $__cmdletization_defaultValue; IsValuePresent = $__cmdletization_defaultValueIsPresent}
        }
        $__cmdletization_methodParameters.Add($__cmdletization_methodParameter)

      $__cmdletization_returnValue = [Microsoft.PowerShell.Cmdletization.MethodParameter]@{ Name = 'ReturnValue'; ParameterType = 'System.Int32'; Bindings = 'Error'; Value = $null; IsValuePresent = $false }
      $__cmdletization_methodInvocationInfo = [Microsoft.PowerShell.Cmdletization.MethodInvocationInfo]::new('Start', $__cmdletization_methodParameters, $__cmdletization_returnValue)
      $__cmdletization_objectModelWrapper.ProcessRecord($__cmdletization_methodInvocationInfo)

            }
        }
        catch
        {
            $__cmdletization_exceptionHasBeenThrown = $true
            throw
        }
    }
        

    End {
        try
        {
            if (-not $__cmdletization_exceptionHasBeenThrown)
            {
                $__cmdletization_objectModelWrapper.EndProcessing()
            }
        }
        catch
        {
            throw
        }
    }

    # .EXTERNALHELP MSFT_MpScan.cdxml-Help.xml
}
Microsoft.PowerShell.Core\Export-ModuleMember -Function 'Start-MpScan' -Alias '*'