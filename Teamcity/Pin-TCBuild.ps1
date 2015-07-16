<#
    .SYNOPSIS
    Pin a given build.

    .DESCRIPTION
    When a TeamCity build is pinned, this build is never removed. Instead, TeamCity display the amount of used data for pinned build in the data usage configurations

    .PARAMETER Build
    The build from the pipeline see example

    .PARAMETER Delete
    Switch, when it is set, remove the pin build.

    .EXAMPLE
    C:\PS> Get-TCBuildType Net_FSharp.Temporality_Build | Get-TCBuild SUCCESFUL -Last | Pin-Build
#>
function Pin-TCBuild
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        $Build,

        [switch] $Delete
    )

    Process
    {
        $id = $Build.id
        $buildTypeId = $Build.buildTypeId
        $number = $Build.number
        
        $uri = "builds/id:$id/pin/" | Get-TCUri
        $credential = Get-TCCredential

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