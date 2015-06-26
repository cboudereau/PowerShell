function Post-ToJson()
{
    [CmdletBinding()]
    Param
    (
        [string] $Uri,
        $Data
    )

    Process
    {
        $json = $Data | ConvertTo-Json
        return Post-String $Uri $json
    }
}