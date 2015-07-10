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

        $parameters = @()

        if($BuildType)
        {
            $parameters += "build=$Id"
            (Get-TeamCityResource -Credential $Credential -RelativePath $uri -Parameters $parameters).change | Get-Change
        }

        else
        {
            $uri += "id:$Id"
            (Get-TeamCityResource -Credential $Credential -RelativePath $uri -Parameters $parameters)
        }
    }
}