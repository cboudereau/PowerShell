function Get-Change()
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
            $changes = (Get-TeamCityResource -Credential $Credential -Href $uri -Parameters $parameters)
            if($changes.change){ $changes.change | Get-Change }
            else { @() }
        }

        else
        {
            $uri += "id:$Id"
            (Get-TeamCityResource -Credential $Credential -Href $uri -Parameters $parameters)
        }
    }
}