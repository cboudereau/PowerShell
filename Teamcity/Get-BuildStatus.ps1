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
        $builds += $Build
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
                $queuedBuild = Get-TeamCityResource -Credential $Credential -Href $_
                
                $state = $queuedBuild.state
                $percentComplete = if($state -eq 'finished'){ 100 } elseif($queuedBuild.percentageComplete){ $queuedBuild.percentageComplete } else { 0 }
                $statusText = if($queuedBuild.statusText) { $queuedBuild.statusText } else { "work in progress" }
                return [pscustomobject]@{ build = $queuedBuild; complete = $percentComplete; statusText = $statusText } }

            $states | % { Write-Progress -PercentComplete $_.complete -Activity $_.build.buildTypeId -Id $_.build.id -CurrentOperation $_.statusText -Status $_.build.state }

            $percent = ($states | % { $_.complete } | Measure-Object -Average).Average

            Start-Sleep -Seconds 1
        }
    }
}