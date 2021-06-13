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
        $Secret
        )

Request-FalconToken -ClientId $Id -ClientSecret $Secret

#Get host ids for each host you want to deploy the ax agent to
$hostidlist = Import-Csv C:\temp\HostList.csv | select 'Host ID'
$hostids = $hostidlist."Host ID"

#assign batch_id to list of hosts 
$response = (Start-FalconSession -HostIds $hostids)
$batbuild = $response | select "batch_id"
$axbatchid = $batbuild."batch_id"



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
