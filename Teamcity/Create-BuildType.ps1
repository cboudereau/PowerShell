function Create-BuildType()
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Alias('id')]
        [string] $ParentId,
        
        [Parameter(Mandatory=$true)]
        [string] $Name,

        [pscredential] $Credential
    )

    Process
    {
        $parent = [pscustomobject]@{ id=$ParentId }
        $project = [pscustomobject]@{ name=$Name; parentProject=$parent }

        $uri = "projects" | Get-TeamCityUri
        $credential = Get-TeamCityCredential -Credential $Credential

        Post-ToJson -Uri $uri -Credential $Credential -Data $project
    }
}