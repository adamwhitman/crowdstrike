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
        $script
        )

Get-CsToken -Id $cus_id -Secret $cus_secret

#Get host ids for each host you want to deploy the ax agent to
$hostid = Import-Csv C:\HostList.csv | select 'Host ID'

#assign batch_id to list of hosts 
$response = (Start-RtrBatch -Id $($hostid."Host ID"))
$batbuild = $response | select "batch_id"
$axbatchid = $batbuild."batch_id"



#push the Automox msi file to the device in the Crowdstrike RTR working directy "C:\"
$putfile = Get-RtrFileId | select "resources"
$build1 = Get-RtrFileInfo -Id ($putfile."resources")
$axfile = $build1 | ForEach-Object {$_.resources} | select ("name", "id") | ? {$_.name -match "Automox_Installer-1.0.28.msi"} | select "id"
$axfileid = $axfile."id"
    

#get script for the put command 
$scrpt = Get-RtrScriptId | select "resources"
$scrbuild = Get-RtrScriptInfo -Id ($scrpt."resources")
$axscrpt = $scrbuild | ForEach-Object {$_.resources} | select ("name", "content") | ? {$_.name -match "Automox Agent Install"} | select "content"
$axscript = $axscrpt."content"
$axscript1=('-CloudFile=' + $scriptfile + ' ' + '-CommandLine="-Verbose true"' )



Send-RtrCommand -Id $axbatchid -Command 'put' -String 'Automox_Installer-1.0.28.msi'
Send-RtrCommand -Id $axbatchid -Command 'runscript' -String $axscript1


#remove-item C:\HostList.csv
}