function Post-ToJson()
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param
    (
        [Parameter(Mandatory=$true)]
        [pscredential] $Credential,

        [Parameter(Mandatory=$true)]
        $Data,

        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string] $Uri
    )

    Process
    {
        $json = $Data | ConvertTo-Json
        
        return Post-String -ContentType 'application/json' -Credential $Credential -Text $json -Uri $Uri | ConvertFrom-Json
    }
}