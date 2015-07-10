# PowerShell

## PsCompletion Module (autocomplete argument thanks to @thinkbeforecoding)

Teamcity module: Get build type, builds, Start and pin build and more

IMPORTANT :
First you have to set TeamCity server by calling Set-TeamCityServer. By default the uri parameter is http://localhost:7777/httpAuth/app/rest/ for test purpose

In all cmdlet we use Net_Framework build type. In your test you have to replace it or just let the Get-BuildTypes finding all TeamCity buildType from the configured server

## TeamCity Module

### Set-TeamCityServer
Set the TeamCity Server to avoid server uri repetition. By default, Uri is set to http://localhost:7777/
Note : if you use httpAuth instead of guest, others cmdlet prompt the credential if not set. All cmdlet reuse this credential in order to communicate with TeamCity REST Api.

```powershell
  Set-TeamCityServer -Uri http://<your-teamcity-server>
```

### Get-TeamCityProject
Get All or specified Project from the teamcity server. The Project parameter is autocompleted by getting the project list from the teamcity server.

Project parameter correspond to the Project ID in the edit mode project on TeamCity interface

```powershell
  Get-TeamCityProject -Project <YourProject>
```

```powershell
  Get-TeamCityProject -Project
```

### Get-BuildType 
Return all TeamCity build types, you can specify the buildType. BuildType is autocomplete with getting first all build types from teamcity server.
Note : The build type id is autogenerated by TeamCity.

```powershell
  #Get all build type from a project
  Get-TeamCityProject -Project Net | Get-BuildType

  #Start a Build
  Get-BuildType -BuildType Net_Framework | Start-Build

  #Get BuildType Net_Framework
  Get-BuildType -BuildType Net_Framework
```

### Get-Build
Get all builds for a given buildType

```powershell
  #Get all Succcessful builds
  Get-BuildType -BuildType Net_Framework | Get-Build -Status SUCCESS
  
  #Get All Prod Tagged Successful builds
  Get-BuildType -BuildType Net_Framework | Get-Build -Status SUCCESS -Tags @('Prod')
  
  #Get All pinned Successful builds
  Get-BuildType -BuildType Net_Framework | Get-Build -Status SUCCESS -Pinned
  
  #Get a single build by build number
  Get-BuildType -BuildType Net_Framework | Get-Build -Number 23
  
  #Get New Problems
  Get-TeamCityProject | Get-BuildType | Get-Build -Status FAILURE -SinceLastSuccessful
  
  #Then Start Build for new Problems :)
  Get-TeamCityProject | Get-BuildType | Get-Build -Status FAILURE -SinceLastSuccessful | Start-Build -Wait
  
```
### Pin-Build
Pin a given build
  
```powershell
  #Pin Build
  Get-BuildType -BuildType Net_HardMock_MainBuild | Get-Build -Status SUCCESS -Last | Pin-Build
  
  #Unpin build
  Get-BuildType -BuildType Net_HardMock_MainBuild | Get-Build -Status SUCCESS -Last | Pin-Build -Delete
```

### Tag-Build

Tag a given build

```powershell
  #Add a tag
  Get-BuildType -BuildType Net_HardMock_MainBuild | Get-Build -Status SUCCESS -Last | Tag-Build -Tag 'Prod'
  
  #Delete ALL Tags
  Get-BuildType -BuildType Net_HardMock_MainBuild | Get-Build -Status SUCCESS -Last | Tag-Build -Delete
  
  #Combine Tag and Pin
  Get-BuildType -BuildType Net_HardMock_MainBuild | Get-Build -Status SUCCESS -Last | Tag-Build -Tag 'Prod' | Pin-Build
```

### Start-Build

```powershell
   #Start all builds and wait the result in a progressbar :)
   Get-BuildType | Start-Build -Wait
```

### Get-Change
```powershell
   #Start all builds and wait the result in a progressbar :)
   Get-BuildType | Get-Build -Last | Get-Change
```


### Pipelining
  Thanks to PowerShell Pipeline, you can combine commands even if the output return a list. In this case an implicit foreach occurs on the next command. For example if the command Get-BuildTypes return 3 buildTypes then if you pipe to Start-Build, the 3 buildType starts