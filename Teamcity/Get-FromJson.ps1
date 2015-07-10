function Get-FromJson()
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param
    (
        [Parameter(Position=0, Mandatory=$true)]
        [pscredential] $Credential,

        [Parameter(Position=1, Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string] $Uri
    )

    Process
    {
        return Get-String -Accept 'application/json' -Credential $Credential -Uri $Uri | ConvertFrom-Json
    }
}