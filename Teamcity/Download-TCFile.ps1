function Download-TCFile()
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory)]
        [string] $Uri,

        [Parameter(Mandatory)]
        [pscredential] $Credential,

        [string] $Folder = 'download'
    )

    Process
    {
        $webClient = New-Object System.Net.WebClient
        $webClient.Credentials = $Credential
        
        if(!(Test-Path $Folder))
        {
            New-Item -Path $Folder -Type directory | Out-Null
        }

        $url = New-Object -TypeName System.Uri -ArgumentList @($Uri)
        $fileName = [System.IO.Path]::GetFileName($url.LocalPath)

        $target = Join-Path $Folder $fileName

        $webClient.DownloadFile($Uri, $target)

        $filePath = Resolve-Path $target

        return $filePath
    }
}