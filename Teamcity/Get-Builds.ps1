function Get-Builds()
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Position=0, Mandatory=$false)]
        [ValidateSet('ALL','SUCCESS','FAILURE','ERROR')]
        [string] $Status,

        [Parameter(Position=1, Mandatory=$false)]
        [string[]] $Tags,
        
        [Parameter(Position=2, Mandatory=$false)]
        [switch] $Pinned,

        [Parameter(Position=3, Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        $BuildType
    )

    Process
    {
        $buildTypeId = $BuildType.id
        $request = "?locator=buildType:(id:$buildTypeId)"

        if($Status -and $Status -ne 'ALL')
        {
            $request += ",status:$Status"
        }
        
        if($Tags)
        {
            $tags = [string]::Join(',',$Tags)
            $request += ",tags:($tags)"

        }
        
        if($Pinned)
        {
            $request += ",pinned:$Pinned"
        }

        $selector = "builds/$request"
        $uri = $selector | Get-TeamCityUri

        $credential = Get-TeamCityCredential

        ($uri | Get-FromJson $credential).build
    }
}