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
        return $Uri | Get-String 'application/json' $Credential | ConvertFrom-Json
    }
}