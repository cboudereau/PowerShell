<#
    .SYNOPSIS
    Create a new build type (build configuration) under a given project. _Root project correspond to the Root TeamCity project

    .DESCRIPTION
    Create a new build configuration with the given name under the pipelined project.

    .PARAMETER ProjectId
    Mandatory, aliased Id is the project where is hosted the build configurations

    .EXAMPLE
    C:\PS> Get-TCProject Net | New-TCBuildType -Name Framework
#>
function New-TCBuildType
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [string] $ProjectId,
        
        [Parameter(Mandatory)]
        [string] $Name,

        [pscredential] $Credential
    )

    Process
    {
        $buildType = [pscustomobject]@{ name=$Name; projectId=$ProjectId }

        $uri = "buildTypes" | Get-TCUri
        $credential = Get-TCCredential -Credential $Credential

        Post-ToJson -Uri $uri -Credential $Credential -Data $buildType
    }
}