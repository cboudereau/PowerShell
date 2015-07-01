# PowerShell

PsCompletion : autocomplete argument thanks to @thinkbeforecoding

Teamcity module: Get build type, builds, Start and pin build and more

IMPORTANT :
First you have to set TeamCity server by calling Set-Server. By default the uri parameter is http://localhost:7777/httpAuth/app/rest/ for test purpose

In all cmdlet we use Net_Framework build type. In your test you have to replace it or just let the Get-BuildTypes finding all TeamCity buildType from the configured server

## Get-BuildTypes 
Return all TeamCity build types, you can specify the buildType. BuildType are autocomplete with getting first all build types from teamcity server to autocomplete parameter.
Note : if you use httpAuth instead of guest, the cmdlet prompt the credential if not set. All cmdlet reuse this credential in order to communicate with TeamCity REST Api.
Note : The build type id is autogenerated by TeamCity.

Example : 
  
  Get-BuildType -BuildType Net_Framework

All cmdlet begin with getting the build type and then start, pin, tag, ... make some operations for a given build : 

This example start the build type Net_Framework.
```powershell
  Get-BuildType -BuildType Net_Framework | Start-Build
```
## Get-Builds
Get all builds for a given buildType
Example : 
```powershell
  #Get all Succcessful builds
  Get-BuildType -BuildType Net_Framework | Get-Builds -Status SUCCESS
  
  #Get All Prod Tagged Successful builds
  Get-BuildType -BuildType Net_Framework | Get-Builds -Status SUCCESS -Tags @('Prod')
  
  #Get All pinned Successful builds
  Get-BuildType -BuildType Net_Framework | Get-Builds -Status SUCCESS -Pinned
  
  #Get a single build by build number
  Get-BuildType -BuildType Net_Framework | Get-Builds -Number 23
```
## Pin-Build
Pin a given build
Example : 
  
```powershell
  (Get-BuildType -BuildType Net_Framework | Get-Builds -Status SUCCESS -Tags @('Prod'))[0] | Pin-Build
```

Unpin build

Example : 
  
```powershell
  (Get-BuildType -BuildType Net_Framework | Get-Builds -Status SUCCESS -Tags @('Prod'))[0] | Pin-Build -Delete
```

## Tag-Build

Tag a given build

  Example : 
    
```powershell
    (Get-BuildType -BuildType Net_Framework | Get-Builds)[0] | Tag-Build -Tag 'Prod'
```
  
  This example Tag the last Net_Framework build
  
  You can add multiple tag by calling cmdlet for each tag

Delete All Tags
  
```powershell
  (Get-BuildType -BuildType Net_Framework | Get-Builds)[0] | Tag-Build -Delete
```
