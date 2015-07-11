function Create-BuildType()
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Alias('id')]
        [string] $ProjectId,
        
        [Parameter(Mandatory=$true)]
        [string] $Name,

        [pscredential] $Credential
    )

    Process
    {
        $buildType = [pscustomobject]@{ name=$Name; projectId=$ProjectId }

        $uri = "buildTypes" | Get-TeamCityUri
        $credential = Get-TeamCityCredential -Credential $Credential

        Post-ToJson -Uri $uri -Credential $Credential -Data $buildType
    }
}