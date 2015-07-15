function Get-FromJson
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory)]
        [pscredential] $Credential,

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string] $Uri
    )

    Process
    {
        return Get-String -Accept 'application/json' -Credential $Credential -Uri $Uri | ConvertFrom-Json
    }
}