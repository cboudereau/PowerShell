function Get-TeamCityUri()
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(ValueFromPipeline)]
        [string] $RelativePath = "",

        [string] $BasePath = "httpAuth/app/rest/",

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
            $root = New-Object -TypeName System.Uri -ArgumentList @($env:TEAMCITY)
            $rootBasePath = New-Object -TypeName System.Uri -ArgumentList @($root, $BasePath)
            $path = "$RelativePath$query"
            $controller = New-Object -TypeName System.Uri -ArgumentList @($rootBasePath, $path)
            
            return $controller.AbsoluteUri
        }
        else
        {
            Write-Error "TeamCity Server is not set, you should use Set-TeamCityServer to set the TeamCity server address"
        }
    }
}