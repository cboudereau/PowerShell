function Pin-Build()
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        $BuildType
    )

    Process
    {
        $uri = "buildQueue" | Get-TeamCityUri
        $credential = Get-TeamCityCredential
        $buildTypeId = $BuildType.id

        $data = New-Object -TypeName psobject -Property @{buildTypeId = $buildTypeId} | ConvertTo-Json

        $data | Post-String 'application/json' $credential $uri
        Write-Host "Build $buildTypeId was successfully added to queue"
    }
}