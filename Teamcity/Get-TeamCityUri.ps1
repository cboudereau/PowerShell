function Get-TeamCityUri()
{
    [CmdletBinding()]
    Param
    (
        [Parameter(
            Position=0, 
            Mandatory=$false, 
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)
        ]
        [string] $RelativePath = "",

        [Parameter(
            Position=1, 
            Mandatory=$false)
        ]
        [string] $BasePath = "httpAuth/app/rest/",


        [Parameter(Position=2, Mandatory=$false)]
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
            Write-Error "TeamCity Server is not set, you should use Set-Server to set the TeamCity server address"
        }
    }
}