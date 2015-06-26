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
        [string] $Uri
    )

    Process
    {
        return $Uri | Get-String 'application/json' | ConvertFrom-Json
    }
}