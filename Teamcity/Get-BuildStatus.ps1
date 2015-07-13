function Get-BuildStatus()
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('href')]
        [string] $Build,
        [pscredential] $Credential
    )

    Begin
    {
        $builds = @()
        $parentId = 0
        $anyRunning = $true
    }

    Process
    {
        $builds += $_
    }

    End
    {
        if($WhatIfPreference)
        {
            Write-Host "build status done"
            return
        }

        while($anyRunning) 
        {
            $states = $builds | % { 
                $queuedBuild = $_ | Get-TeamCityResource -Credential $Credential
                $state = $queuedBuild.state
                $isFinished = $queuedBuild.state -eq 'finished'
                $percentComplete = if($isFinished){ 100 } elseif($queuedBuild.percentageComplete){ $queuedBuild.percentageComplete } else { 0 }
                $statusText = if($queuedBuild.statusText) { $queuedBuild.statusText } else { "work in progress" }
                return [pscustomobject]@{ build = $queuedBuild; complete = $percentComplete; statusText = $statusText; state = $state; isFinished = $isFinished } }

            $states | % { 
                Write-Host "$($_.build.buildTypeId) is $($_.build.state) with status : $($_.statusText)"
                Write-Progress -PercentComplete $_.complete -Activity $_.build.buildTypeId -Id $_.build.id -CurrentOperation $_.statusText -Status $_.build.state }

            $anyRunning = $($states | Where-Object { !$_.isFinished })

            if(!$anyRunning)
            {
                $states | % { 
                    $changeTexts = $_.build | Get-Change | % { "change by $($_.username) [$($_.version)] : $($_.comment)" }
                    $changes = $changeTexts -join "`r`n"
                    
                    Write-Host "Build $($_.build.buildTypeId) is $($_.state) with status : $($_.build.status)($($_.statusText))`r`n$($changes)" }
            }

            else
            {
                Start-Sleep -Seconds 1
            }
        }
    }
}