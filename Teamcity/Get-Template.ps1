function Get-Template()
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Alias('Templates')]
        $Template,

        [pscredential] $Credential
    )

    Process
    {
        $Template.buildType | % { Get-TeamCityResource -Credential $Credential -Href $_.href }
    }
}