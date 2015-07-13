function Get-TeamCityResource()
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string] $Href,
        
        [string[]] $Parameters,

        [pscredential] $Credential
    )

    Process
    {
        $credential = Get-TeamCityCredential $Credential
        $uri = Get-TeamCityUri -RelativePath $Href -Parameters $Parameters

        return Get-FromJson -Credential $credential -Uri $uri
    }
}