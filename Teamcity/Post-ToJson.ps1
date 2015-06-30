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
        
        return Post-String -ContentType 'application/json' -Credential $Credential -Text $json -Uri $Uri
    }
}