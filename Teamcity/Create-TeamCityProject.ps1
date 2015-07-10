function Create-TeamCityProject()
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline)]
        [string] $Name,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Alias('id')]
        [string] $ParentId = "_Root",
        
        [pscredential] $Credential
    )

    Process
    {
        $parent = [pscustomobject]@{ id=$ParentId }
        $project = [pscustomobject]@{ name=$Name; parentProject=$parent }

        $uri = "projects" | Get-TeamCityUri
        $credential = Get-TeamCityCredential -Credential $Credential

        Post-ToJson -Uri $uri -Credential $Credential -Data $project -ErrorAction SilentlyContinue
    }
}