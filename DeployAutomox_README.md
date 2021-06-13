# Deploying the Automox agent using the Falcon sensor

### Prerequisites
1.  **Ensure supported Powershell verion is installed**: Device running script needs to have **[PowerShell 5.1+](https://github.com/PowerShell/PowerShell#get-powershell)** installed. You can check your Powershell version by runnning the following command from the Powershell CLI on the device you will be deploying the agent from.

```
PS C:\> Get-Host | Select-Object Version

Version      
-------      
5.1.18362.628
```

2. Follow the instruction to download and install the PSFalcon module. https://github.com/CrowdStrike/psfalcon/wiki/Installation



3. **API Credentials**: Interacting with the CrowdStrike Falcon API requires an **[API Client ID and Secret](https://falcon.crowdstrike.com/support/api-clients-and-keys)**. You will need to create this in the Falcon console to use for the script. 
    

7. **Upload the Automox .msi file**: Upload the ```Automox_Installer-1.0.31.msi``` file using the Falcon Console by navigating to Response Scripts & Files > "PUT" Files. From there, click 'Upload File' and upload the  ```Automox_Installer-1.0.28.msi``` file. DO NOT change the naming of the .msi file. The File Name must read 'Automox_Installer-1.0.28.msi'. This gets uploaded to the working directory of the device for Falcon sensor.  Here is the link to Download the [Automox_Installer-1.0.28.msi](https://console.automox.com/Automox_Installer-1.0.31.msi)

8.  **Upload the installation script to install Automox**: You must create the Automox .msi installation command as a ps1 script in the Falcon Console. Then, the Deploy-Automox script will use the created ps1 script to run the installation command against the Automox .msi file in the devices working directory for the Falcon sensor. You create the script using the Falcon Console by navigating to Response Scripts & Files > Custom Scripts. From there, click 'Create a script'. You will need to ensure the 2 values below are added to the custom script exactly as they are shown, and the script permissions are set accordingly:
```
Script Name:   AxAgentInstall.ps1
Script:        .\Automox_Installer-1.0.31.msi ACCESSKEY=<your_org_access_key> /quiet

Permission:    RTR Active Responder and RTR Administrator
````
 You will need to add your Automox organization access key where it says ```<your_org_access_key>``` to the script command. 
 example:```ACCESSKEY=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx```

**NOTE:** You can add as many arguments to the Automox install command script. The above is for basic quiet install of Automox into your organization. visit https://support.automox.com for more install options for the Automox agent.

9. Once you have the custom script saved you can now run the Deploy-Automox.ps1 script.


### Deploy-Automox.ps1 

1. Copy the [Deploy-Automox.ps1](https://github.com/shakeybonesz/crowdstrike/blob/master/Deploy-Automox.ps1) script locally to the device you will be performing the deployment from. 

2. execute the ```Deploy-Automox.ps1``` script on the device. This script creates a powershell function called ```Deploy-AxAgent```

Here is an example of the ```Deploy-AxAgent``` usage after running the ```Deploy-Automox.ps1```

```
PS C:\> .\Deploy-Automox.ps1

PS C:\> Deploy-AxAgent
cmdlet Deploy-AxAgent at command pipeline position 1
Supply values for the following parameters:
Id: <string> (Your API Client ID)
Secret: <string> (Your API Client Secret) 
HostGroup: "<string>" (The host group of devices you want to deploy the automox agent to. NOTE: You must put the group name in ". example: "windows group"
```


Example command:

Deploy-AxAgent -Id '<your_client_id>' -Secret '<your_client_secret>' -HostGroup "<your_host_group>" 


```

The Automox agent should now be installed successfully on all your devices and reporting into your Automox console!


