function Get-TCUri
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(ValueFromPipeline)]
        [string] $RelativePath = "",

        [string[]] $Parameters = @()
    )

    
    Process
    {
        if($Parameters)
        {
            $query = "?"

            $Parameters | % { $query += "$_&" }
            
            $query = $query.Substring(0, $query.Length -1)
        }
        
        if($env:TEAMCITY)
        {
            $path = [System.IO.Path]::Combine("httpAuth/app/rest/", $RelativePath)
            $root = New-Object -TypeName System.Uri -ArgumentList @($env:TEAMCITY)

            $uri = New-Object -TypeName System.Uri -ArgumentList @($root, "$path$query")
                        
            return $uri.AbsoluteUri
        }
        else
        {
            Write-Error "TeamCity Server is not set, you should use Set-TCServer to set the TeamCity server address"
        }
    }
}