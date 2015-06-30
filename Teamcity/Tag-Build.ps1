function Tag-Build()
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Position=0, Mandatory=$false)]
        [string] $Tag,
        
        [Parameter(Position=1, Mandatory=$false)]
        [switch] $Delete,

        [Parameter(Position=2, Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        $Build
    )

    Process
    {
        $buildId = $Build.id
        $buildTypeId = $Build.buildTypeId
        $number = $Build.number

        $uri = "builds/id:$buildId/tags/" | Get-TeamCityUri
        $credential = Get-TeamCityCredential

        if($Delete)
        {
            Post-String -ContentType 'application/xml' -Credential $credential -Uri $uri -Method PUT -Text "<tags></tags>"
            Write-Host "Build tag $buildTypeId #$number was successfully removed"
        }
        else
        {
            Post-String -ContentType 'text/plain' -Credential $credential -Uri $uri -Method POST -Text $Tag

            Write-Host "Build $buildTypeId #$number was successfully tagged to $Tag"
        }
    }
}