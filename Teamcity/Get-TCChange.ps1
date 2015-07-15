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