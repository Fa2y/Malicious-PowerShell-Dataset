foreach ($Update in $global:GetPendingUpdates ) {
    Write-Host "--------------------------------"
    $UpdateTitle = $Update.Title
    Write-Host "UpdateTitle:" $UpdateTitle
    $UpdateLastDeploymentChangeTime = $Update.LastDeploymentChangeTime
    Write-Host "UpdateLastDeploymentChangeTime:" $UpdateLastDeploymentChangeTime
    $LastDeploymentChangeTimeDiffFromToday = New-TimeSpan -Start $global:var_Now -End $UpdateLastDeploymentChangeTime
    [int]$Global:LastDeploymentChangeTimeDiffFromTodayIndays = $LastDeploymentChangeTimeDiffFromToday.Days
    Write-Host "LastDeploymentChangeTimeDiffFromTodayIndays:" $LastDeploymentChangeTimeDiffFromTodayIndays
    if ($Global:LastDeploymentChangeTimeDiffFromTodayIndays -lt $Global:LastDeploymentChangeTimeDiffThreshold) { 
        $global:AlertCounter ++
        $global:AlertMessage += "[$UpdateTitle]"
    }
}