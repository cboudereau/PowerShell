﻿function Set-Server()
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        $Uri = "http://localhost:7777/httpAuth/app/rest/"
    )

    Process
    {
        $env:TEAMCITY = $Uri

        Write-Host "Server is : $Uri" 
    }
}