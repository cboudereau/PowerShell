﻿function Start-Build()
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Alias('buildTypeId', 'id')]
        [string] $BuildType,
        
        [switch] $Wait,
        
        [pscredential] $Credential
    )

    Begin
    {
        $uri = "buildQueue" | Get-TeamCityUri
        $credential = Get-TeamCityCredential -Credential $Credential

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
            $started | Get-BuildStatus
        }
    }
}