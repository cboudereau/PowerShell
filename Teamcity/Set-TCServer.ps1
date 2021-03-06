﻿<#
    .SYNOPSIS
    Set the teamcity server root uri.

    .DESCRIPTION
    In order to avoid repetition on argument, this cmdlet set the teamcity server into a env variable called TEAMCITY

    .PARAMETER Uri
    The base Uri

    .EXAMPLE
    C:\PS> Set-TCServer http://localhost:7777/
#>
function Set-TCServer
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        $Uri = "http://localhost:7777/"
    )

    Process
    {
        $env:TEAMCITY = $Uri

        Write-Host "Server is : $Uri"

        $Uri
    }
}