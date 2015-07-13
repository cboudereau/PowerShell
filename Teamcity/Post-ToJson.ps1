function Post-ToJson()
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory)]
        [pscredential] $Credential,

        [Parameter(Mandatory)]
        $Data,

        [ValidateSet('POST','PUT','DELETE')]
        [string] $Method = 'POST',

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string] $Uri
    )

    Process
    {
        $json = $Data | ConvertTo-Json
        
        return Post-String -ContentType 'application/json' -Credential $Credential -Text $json -Uri $Uri -Method $Method | ConvertFrom-Json
    }
}