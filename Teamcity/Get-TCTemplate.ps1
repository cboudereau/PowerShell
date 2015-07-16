<#
    .SYNOPSIS
    Get Teamcity template for a given project

    .DESCRIPTION
    Return template object from teamcity project.

    .PARAMETER Id
    Mandatory, Correspond to a project. This cmdlet is used to autocomplete the New-TCFromTemplate parameter

    .EXAMPLE
    C:\PS> Get-TCTemplate Net
#>
function Get-TCTemplate
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
            return (Get-TCResource -Credential $Credential -Href "buildTypes?locator=templateFlag:true").buildType
        }
        
        $uri = "projects/id:$projectId/templates"
        $project = Get-TCProject -Project $ProjectId
        
        (Get-TCResource -Credential $Credential -Href $uri).buildType

        if($project.parentProjectId)
        {
            Get-TCTemplate -projectId $project.parentProjectId
        }
    }
}