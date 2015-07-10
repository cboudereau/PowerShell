function Get-Change()
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string] $Id,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
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
            $changes = (Get-TeamCityResource -Credential $Credential -RelativePath $uri -Parameters $parameters)
            if($changes.change){ $changes.change | Get-Change }
            else { @() }
        }

        else
        {
            $uri += "id:$Id"
            (Get-TeamCityResource -Credential $Credential -RelativePath $uri -Parameters $parameters)
        }
    }
}