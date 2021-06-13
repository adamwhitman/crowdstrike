function Deploy-AxAgent {

[CmdletBinding()]
[OutputType([psobject])]

param(
        [Parameter(Mandatory = $true)]
        [ValidateLength(32,32)]
        [string]
        $Id,

        [Parameter(Mandatory = $true)]
        [ValidateLength(40,40)]
        [string]
        $Secret,

        [Parameter(Mandatory = $true)]
        [string]
        $HostGroup
        )

Request-FalconToken -ClientId $Id -ClientSecret $Secret

#Get Group you want to deploy the ax agent to
$groupfilter = Get-FalconHostGroup -detailed | select ("name", "id") | ? {$_.name -match $HostGroup} | select "id"
$group = $groupfilter."id"

#get devices within group to deploy ax agent to
$devicelist = Get-Falconhost -detailed | select ("device_id", "platform_name", "groups") | ? {$_.groups -eq $group} | select ("device_id", "platform_name")
$hostids = $devicelist."device_id"


#push the Automox msi file to the device in the Crowdstrike RTR working directy "C:\"
$axfile = Get-FalconPutFile -Detailed -All | select ("id", "name") | ? {$_.name -match "Automox_installer-1.0.31.msi"} | select "name"
$axfileid = $axfile."name"
    

#get script for the put command 
$axscrpt = Get-FalconScript -Detailed -All | select ("content", "name") | ? {$_.name -match  "AxAgentInstall.ps1"} | select "content"
$axscript = $axscrpt."content"
$axscript1=('-CloudFile=' + '"AxAgentInstall.ps1"' + ' ' + '-CommandLine="-Verbose true"' )


#commands to push the ax .msi and run the installation script
Invoke-FalconRTR -HostIds $hostids -Command 'put' -Arguments $axfileid -QueueOffline $true
Invoke-FalconRTR -HostIds $hostids -Command 'runscript' -Arguments $axscript1 -QueueOffline $true
}
