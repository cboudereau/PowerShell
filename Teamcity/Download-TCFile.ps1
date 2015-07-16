function Download-TCFile
{
    <#
       .SYNOPSIS
        Download artifact file for a given artifact path.

       .DESCRIPTION
        When a build is finished, it produce artifact files.
        Given a finished build, then this cmdlet download the artifact file at given uri.

       .PARAMETER Folder
       The target download folder

       .PARAMETER Uri
       The artifact file uri

       .EXAMPLE
       C:\PS> Download-TCFile http://localhost:7777/repository/download/Net_Framework/479:id/Castle.Core.dll
    #>
    
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