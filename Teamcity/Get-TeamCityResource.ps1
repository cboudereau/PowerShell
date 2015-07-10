function Get-TeamCityResource()
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Href = "httpAuth/app/rest/",
        
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $RelativePath,
        
        [Parameter(Mandatory=$false)]
        [pscredential] $Credential
    )

    Process
    {
        $credential = Get-TeamCityCredential $Credential
        $uri = Get-TeamCityUri -BasePath $Href -RelativePath $RelativePath

        return Get-FromJson -Credential $credential -Uri $uri
    }
}