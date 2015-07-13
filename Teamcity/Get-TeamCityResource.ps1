function Get-TeamCityResource()
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Href = "httpAuth/app/rest/",
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $RelativePath,
        
        [string[]] $Parameters,

        [pscredential] $Credential
    )

    Process
    {
        $credential = Get-TeamCityCredential $Credential
        $uri = Get-TeamCityUri -BasePath $Href -RelativePath $RelativePath -Parameters $Parameters

        return Get-FromJson -Credential $credential -Uri $uri
    }
}