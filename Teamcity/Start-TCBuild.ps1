<#
    .SYNOPSIS
    Start a build from a build type.

    .DESCRIPTION
    Run build from a given build type (build configuration) from the pipeline

    .PARAMETER BuildType
    Mandatory, Also called buildTypeId or id.

    .PARAMETER Wait
    Switch parameter. When it is set, the cmdlet wait the end of the build (build finished). When build is running a progress bar display the TeamCity progress of build.
    The build status is displayed thanks to Get-TCBuildStatus cmdlet.

    .PARAMETER OutBuild
    By default, the start build cmdlet did not return any teamcity build object. This is may be the end of the pipeline. If not, this parameter can be set in order to pipe the output with another cmdlet.

    .EXAMPLE
    C:\PS> Get-TCBuildType Net_Framework | Start-TCBuild
#>
function Start-TCBuild
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('buildTypeId', 'id')]
        [string] $BuildType,
        
        [switch] $Wait,
        
        [switch] $OutBuild,

        [pscredential] $Credential
    )

    Begin
    {
        $uri = "buildQueue" | Get-TCUri
        $credential = Get-TCCredential -Credential $Credential

        $buildTypes += @()
    }

    Process
    {
        $buildTypes += $BuildType
    }

    End
    {
        $uniqueBuildTypes = $buildTypes | Sort-Object -Unique

        if($WhatIfPreference)
        {
            $waitMessage = if($Wait){ "(await mode)" } else { "(fire and forget mode)" }
            $uniqueBuildTypes | % { Write-Host "New $_ Build started $waitMessage" }
            return
        }
        
        $started = $uniqueBuildTypes | % { 
            $data = New-Object -TypeName psobject -Property @{ buildTypeId = $_ }
            Post-ToJson -Credential $credential -Data $data -Uri $uri -ErrorAction Stop
            Write-Host "$_ was successfully added to the queue" }

        if($Wait)
        {
            $started | Get-TCBuildStatus | Out-Null
        }

        if($OutBuild)
        {
            return $started
        }
    }
}