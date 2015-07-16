<#
    .SYNOPSIS
    Get change for a given build.

    .DESCRIPTION
    Build are started from TeamCity or by Start-TCBuild cmdlet, then all changes (commit, checkin) can be retrieve with this cmdlet

    .PARAMETER Id
    Mandatory, If there is a Build object into the pipeline containing 2 properties : Id and buildTypeId, this cmdlet returns all changes for a given build.
    If there is no buildTypeId, the Id correspond to a change id.

    .PARAMETER BuildType
    When a build is passed to the pipeline, this property is set. All changes for a given build is retrieved.

    .EXAMPLE
    C:\PS> Get-TCChange 25

    Get Only one change

    .EXAMPLE
    C:\PS> Get-TCBuildType Net_Framework | Get-TCBuild -Last | Get-TCChange
       
    Get all changes for the latest Net_Framework build

#>
function Get-TCChange
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $Id,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName)]
        [Alias('buildTypeId')]
        [string] $BuildType,

        [pscredential] $Credential
    )

    Process
    {
        
        $uri = "changes/"

        if($BuildType)
        {
            $parameters = @("build=$Id")
            $changes = (Get-TCResource -Credential $Credential -Href $uri -Parameters $parameters)
            if($changes.change){ $changes.change | Get-TCChange }
            else { @() }
        }

        else
        {
            $uri += "id:$Id"
            (Get-TCResource -Credential $Credential -Href $uri -Parameters $parameters)
        }
    }
}