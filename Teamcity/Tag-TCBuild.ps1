<#
    .SYNOPSIS
    Tag a build.

    .DESCRIPTION
    Tag the build with the given Tag parameter

    .PARAMETER Build
    Mandatory, Build object in order to combine cmdlet with Pin-Build for example.

    .PARAMETER Tag
    The tag value

    .PARAMETER Delete
    Switch parameter. When delete is given all tag are removed from the given build

    .EXAMPLE
    C:\PS> Get-TCBuildType Net_Framework | Get-TCBuild SUCCESS -Last | Tag-TCBuild -Tag RC
#>
function Tag-TCBuild
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        $Build,

        [string] $Tag,
        
        [switch] $Delete
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