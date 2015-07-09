﻿function Post-String()
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param
    (
        [Parameter(Mandatory=$true)]
        [string] $ContentType,

        [Parameter(Mandatory=$true)]
        [pscredential] $Credential,

        [string] $Text,

        [ValidateSet('POST','PUT','DELETE')]
        [string] $Method = 'POST',

        [string] $Accept,

        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string] $Uri

    )

    Process
    {
        if($WhatIfPreference)
        {
            Write-Host "$Method $Text to $Uri"
            return
        }

        $webClient = New-Object System.Net.WebClient
        
        $webClient.Headers.add('Accept', $(if($Accept){ $Accept } else { $ContentType }))
        $webClient.Headers.add('Content-Type', $ContentType)
        $webClient.Credentials = $Credential

        return $webClient.UploadString($Uri, $Method, $Text)
    }
}