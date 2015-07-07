function Start-Build()
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Alias('buildTypeId', 'id')]
        [string] $BuildType,
        [switch] $Wait,
        [pscredential] $Credential
    )

    Begin
    {
        $uri = "buildQueue" | Get-TeamCityUri
        $credential = Get-TeamCityCredential -Credential $Credential

        $buildTypes += @()
    }

    Process
    {
        $buildTypes += $BuildType
    }

    End
    {
        $started = @()
        $buildTypes | Sort-Object -Unique | % { 
            $data = New-Object -TypeName psobject -Property @{ buildTypeId = $_ }
            $started += Post-ToJson -Credential $credential -Data $data -Uri $uri -ErrorAction Stop }

        if($Wait)
        {
            $started | Get-BuildStatus
        }
    }
}