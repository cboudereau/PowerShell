function Get-TCResource
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
        $credential = Get-TCCredential $Credential
        $uri = Get-TCUri -RelativePath $Href -Parameters $Parameters

        return Get-FromJson -Credential $credential -Uri $uri
    }
}