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

        [Parameter(Position=3, Mandatory=$false)]
        [string] $Number,

        [Parameter(Position=4, Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        $BuildType
    )

    Process
    {
        $number = if($Number) { ",number:$Number" } else { "" }
        $buildTypeId = $BuildType.id
        $request = "?locator=buildType:(id:$buildTypeId)$number"

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

        (Get-FromJson -Credential $credential -Uri $uri).build
    }
}