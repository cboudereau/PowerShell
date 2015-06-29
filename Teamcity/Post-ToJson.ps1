function Post-ToJson()
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Position=0, Mandatory=$true)]
        [pscredential] $Credential,

        [Parameter(Position=1, Mandatory=$true)]
        $Data,

        [Parameter(Position=2, Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string] $Uri
    )

    Process
    {
        $json = $Data | ConvertTo-Json
        return $Uri | Post-String 'application/json' $Credential $json
    }
}