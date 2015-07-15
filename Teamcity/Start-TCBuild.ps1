﻿function Start-TCBuild
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('buildTypeId', 'id')]
        [string] $BuildType,
        
        [switch] $Wait,
        
        [switch] $Top,

        [switch] $ShowBuild,

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
            $data = New-Object -TypeName psobject -Property @{ buildTypeId = $_; moveToTop=$Top }
            Post-ToJson -Credential $credential -Data $data -Uri $uri -ErrorAction Stop
            Write-Host "$_ was successfully added to the queue" }

        if($Wait)
        {
            $started | Get-TCBuildStatus | Out-Null
        }

        if($IsPiped)
        {
            return $started
        }
    }
}