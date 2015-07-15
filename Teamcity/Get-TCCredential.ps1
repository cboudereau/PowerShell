function Get-TCCredential
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory=$false, ValueFromPipeline)]
        [pscredential] $Credential
    )

    
    Process
    {
        if($Credential)
        {
            $global:TEAMCITY_REST = $Credential
            return $global:TEAMCITY_REST
        }

        if($global:TEAMCITY_REST)
        {
            return $global:TEAMCITY_REST
        }
        else
        {
            $global:TEAMCITY_REST = Get-Credential
            return $global:TEAMCITY_REST
        }
    }
}