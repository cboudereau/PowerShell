function Start-Build()
{
    [CmdletBinding()]
    Param
    (
        [Parameter(
                Position=0, 
                Mandatory=$true, 
                ValueFromPipeline=$true,
                ValueFromPipelineByPropertyName=$true)
            ]
        $BuildType
    )

    Process
    {
        $root = 'http://localhost:7777/httpAuth/app/rest/buildQueue'

        $id = $BuildType.id

        $data = "<build><buildType id='$id'/></build>"

        return Post-String -Uri $root -Data $data -ContentType 'application/xml'
    }
}