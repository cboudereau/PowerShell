function Pin-Build()
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [switch] $Delete,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        $Id,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        $BuildTypeId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        $Number
    )

    Process
    {
        $uri = "builds/id:$Id/pin/" | Get-TeamCityUri
        $credential = Get-TeamCityCredential

        $method = 'PUT'

        $output = "pinned"

        if($Delete)
        {
            $method = 'DELETE'
            $output = "unpinned"
        }

        Post-String -ContentType 'text/plain' -Credential $credential -Uri $uri -Method $method | Out-Null

        Write-Host "Build $BuildTypeId #$Number was successfully $output"

        return $Build
    }
}