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
            $global:TEAMCITY_REST = Get-Credential -Message "Credential for teamcity rest user"
            return $global:TEAMCITY_REST
        }
    }
}