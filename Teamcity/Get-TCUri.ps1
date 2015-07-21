function Get-TCUri
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(ValueFromPipeline)]
        [string] $RelativePath = "",

        [string[]] $Parameters = @(),

        [string] $Server
    )

    
    Process
    {
        if($Parameters)
        {
            $query = "?"

            $Parameters | % { $query += "$_&" }
            
            $query = $query.Substring(0, $query.Length -1)
        }
        
        $root = 
            if($Server) { New-Object -TypeName System.Uri -ArgumentList @($Server) }
            elseif ($env:TEAMCITY) { New-Object -TypeName System.Uri -ArgumentList @($env:TEAMCITY) }
            else { 
                $server = Read-Host "supply teamcity server like http://localhost:7777/"
                Set-TCServer $server
                New-Object -TypeName System.Uri -ArgumentList @($server) }

        $path = [System.IO.Path]::Combine("httpAuth/app/rest/", $RelativePath)

        $uri = New-Object -TypeName System.Uri -ArgumentList @($root, "$path$query")
                        
        return $uri.AbsoluteUri
    }
}