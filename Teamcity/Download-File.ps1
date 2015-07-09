function Download-File()
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param
    (
        [Parameter(Position=0, Mandatory=$true)]
        [string] $Uri,

        [Parameter(Position=1, Mandatory=$true)]
        [pscredential] $Credential,

        [Parameter(Position=2, Mandatory=$false)]
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