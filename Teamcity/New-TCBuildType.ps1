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