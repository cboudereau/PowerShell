function Get-FromJson()
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Position=0, Mandatory)]
        [pscredential] $Credential,

        [Parameter(Position=1, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string] $Uri
    )

    Process
    {
        return Get-String -Accept 'application/json' -Credential $Credential -Uri $Uri | ConvertFrom-Json
    }
}