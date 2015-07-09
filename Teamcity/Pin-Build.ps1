function Pin-Build()
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param
    (
        [switch] $Delete,

        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        $Build
    )

    Process
    {
        $id = $Build.id
        $buildTypeId = $Build.buildTypeId
        $number = $Build.number

        $uri = "builds/id:$id/pin/" | Get-TeamCityUri
        $credential = Get-TeamCityCredential

        $method = 'PUT'

        $output = "pinned"

        if($Delete)
        {
            $method = 'DELETE'
            $output = "unpinned"
        }

        Post-String -ContentType 'text/plain' -Credential $credential -Uri $uri -Method $method | Out-Null

        Write-Host "Build $buildTypeId #$number was successfully $output"

        return $Build
    }
}