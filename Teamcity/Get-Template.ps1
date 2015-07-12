function Get-Template()
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [string] $ProjectId,

        [pscredential] $Credential
    )

    Process
    {
        if(!$ProjectId)
        {
            return (Get-TeamCityResource -Credential $Credential -RelativePath "buildTypes?locator=templateFlag:true").buildType
        }
        
        $uri = "projects/id:$projectId/templates"
        $project = Get-TeamCityProject -Project $ProjectId
        
        (Get-TeamCityResource -Credential $Credential -RelativePath $uri).buildType

        if($project.parentProjectId)
        {
            Get-Template -projectId $project.parentProjectId
        }
    }
}