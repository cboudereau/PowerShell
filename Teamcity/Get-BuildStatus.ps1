function Get-BuildStatus()
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Alias('href')]
        [string] $Build,
        [pscredential] $Credential
    )

    Begin
    {
        $builds = @()
        $parentId = 0
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

        while($percent -lt 100) 
        {
            $states = $builds | % { 
                $queuedBuild = $_ | Get-TeamCityResource -Credential $Credential
                $state = $queuedBuild.state
                $percentComplete = if($state -eq 'finished'){ 100 } elseif($queuedBuild.percentageComplete){ $queuedBuild.percentageComplete } else { 0 }
                $statusText = if($queuedBuild.statusText) { $queuedBuild.statusText } else { "work in progress" }
                return [pscustomobject]@{ build = $queuedBuild; complete = $percentComplete; statusText = $statusText; state = $state } }

            $states | % { Write-Progress -PercentComplete $_.complete -Activity $_.build.buildTypeId -Id $_.build.id -CurrentOperation $_.statusText -Status $_.build.state }

            $percent = ($states | % { $_.complete } | Measure-Object -Average).Average

            if($percent -eq 100)
            {
                $states | % { 
                    $changeTexts = $_.build | Get-Change | % { "change by $($_.username) [$($_.version)] : $($_.comment)" }
                    $changes = $changeTexts -join  "`r`n"
                    
                    Write-Host "Build $($_.build.buildTypeId) is $($_.state) with status '$($_.statusText)' `r`n$($changes)" }
            }

            else
            {
                Start-Sleep -Seconds 1
            }
        }
    }
}