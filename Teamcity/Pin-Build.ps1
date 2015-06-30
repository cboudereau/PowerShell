function Pin-Build()
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Position=0, Mandatory=$false)]
        [switch] $Delete,

        [Parameter(Position=1, Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        $Build
    )

    Process
    {
        $buildId = $Build.id

        $uri = "builds/id:$buildId/pin/" | Get-TeamCityUri
        $credential = Get-TeamCityCredential

        $method = 'PUT'

        $output = "pinned"

        if($Delete)
        {
            $method = 'DELETE'
            $output = "unpinned"
        }

        Post-String -ContentType 'text/plain' -Credential $credential -Uri $uri -Method $method

        $buildTypeId = $Build.buildTypeId
        $number = $Build.number
        Write-Host "Build $buildTypeId #$number was successfully $output"
    }
}