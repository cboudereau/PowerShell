function Tag-Build()
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param
    (
        [string] $Tag,
        
        [switch] $Delete,

        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        $Build
    )

    Process
    {
        $id = $Build.id
        $buildTypeId = $Build.buildTypeId
        $number = $Build.number

        
        $uri = "builds/id:$id/tags/" | Get-TeamCityUri
        $credential = Get-TeamCityCredential

        if($Delete)
        {
            Post-String -ContentType 'application/json' -Credential $credential -Uri $uri -Method PUT -Text "{}" | Out-Null
            Write-Host "Build tag $buildTypeId #$number was successfully removed"
        }
        
        else
        {
            Post-String -ContentType 'text/plain' -Credential $credential -Uri $uri -Method POST -Text $Tag | Out-Null
            Write-Host "Build $buildTypeId #$number was successfully tagged to $Tag"
        }

        return $Build
    }
}