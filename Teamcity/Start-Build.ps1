function Start-Build()
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        $BuildType,

        [Parameter(Mandatory=$false)]
        [pscredential] $Credential

    )

    Process
    {
        $uri = "buildQueue" | Get-TeamCityUri
        $credential = Get-TeamCityCredential $Credential
        $buildTypeId = $BuildType.id

        $data = New-Object -TypeName psobject -Property @{buildTypeId = $buildTypeId} | ConvertTo-Json

        $data | Post-String 'application/json' $credential $uri
        Write-Host "Build $buildTypeId was successfully added to queue"
    }
}