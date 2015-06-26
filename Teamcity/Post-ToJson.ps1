function Post-ToJson()
{
    [CmdletBinding()]
    Param
    (
        [string] $Uri,
        $Data,
        [pscredential] $Credential
    )

    Process
    {
        $json = $Data | ConvertTo-Json
        return Post-String -Uri $Uri -Data $json -Credential $Credential
    }
}