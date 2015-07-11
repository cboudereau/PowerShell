function Get-Template()
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Alias('id')]
        $projectId,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        $parentProjectId,

        [pscredential] $Credential
    )

    Process
    {
        $uri = "projects/id:$projectId/templates"

        (Get-TeamCityResource -Credential $Credential -RelativePath $uri).buildType

        if($parentProjectId)
        {
            Get-TeamCityProject -Project $parentProjectId | Get-Template
        }
    }
}