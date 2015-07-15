function Tag-TCBuild
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [string] $Tag,
        
        [switch] $Delete,

        [Parameter(Mandatory, ValueFromPipeline)]
        $Build
    )

    Process
    {
        $id = $Build.id
        $buildTypeId = $Build.buildTypeId
        $number = $Build.number

        
        $uri = "builds/id:$id/tags/" | Get-TCUri
        $credential = Get-TCCredential

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