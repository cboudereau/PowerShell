function Get-FromJson()
{
    [CmdletBinding()]
    Param
    (
        [Parameter(
                Position=0, 
                Mandatory=$true, 
                ValueFromPipeline=$true,
                ValueFromPipelineByPropertyName=$true)
            ]
        [string] $Uri,

        [Parameter(
                Position=1, 
                Mandatory=$true, 
                ValueFromPipeline=$true,
                ValueFromPipelineByPropertyName=$true)
            ]
        [pscredential] $Credential
    )

    Process
    {
        return $Uri | Get-String 'application/json' $Credential | ConvertFrom-Json
    }
}