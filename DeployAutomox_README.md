# Deploying the Automox agent using the Falcon sensor

### Prerequisites
1.  **Ensure supported Powershell verion is installed**: Device running script needs to have **[PowerShell 5.1+](https://github.com/PowerShell/PowerShell#get-powershell)** installed. You can check your Powershell version by runnning the following command from the Powershell CLI on the device you will be deploying the agent from.

```
PS C:\> Get-Host | Select-Object Version

Version      
-------      
5.1.18362.628
```

2. Download and install the PSFalcon modules: You will need these for the Deploy-Automox.ps1 script to run as it calls several of these modules. To install it, you simply need to run ```Install-Module -Name PSFalcon``` from the Powershell CLI on device you will be deploying the agent from. Example below

```

PS C:\> Install-Module -Name PSFalcon

```




3. **OAuth2 App Creation**: Interacting with the CrowdStrike Falcon OAuth2 APIs requires an **[API Client ID and Secret](https://falcon.crowdstrike.com/support/api-clients-and-keys)** and a valid OAuth2 token. You will need to create this in the Falcon console to use for the script. This will give you your 'Client Id' and 'Client Secret', which are the only 2 parameters passed to the Deploy-Automox module that is installed by Deploy-Automox.ps1. These are used to create your OAuth2 token used for authentication. 
    

4. **List of Hosts for Deployment**: Using the Falcon Console, export Hosts > Host Management as a CSV. Remove all columns in the CSV except Hostname, Last Seen and Host ID of the devices you want to deploy the Automox agent to. Be sure to keep the column headers in the .csv. "Hostname, Last Seen and Host ID".  
   
      **WARNING**: Failing to remove the ‘policy’ columns will cause unexpected results. The ‘policy’ columns have line breaks which PowerShell has issues interpreting.


5. **Saving the host csv list** Save the csv file and name it ```HostList.csv```. Failure to name the CSV file exactly as shown will cause the script to fail


6. **Required location of HostList.csv**: Put the HostList.csv file in the ```C:``` directory of the device you will be running the script from. The script calls ```c:\HostList.csv```, so ```HostList.csv``` has to be in the ```C:``` directory 

7. **Upload the Automox .msi file**: Upload the ```Automox_Installer-1.0.28.msi``` file using the Falcon Console by navigating to Response Scripts & Files > "PUT" Files. From there, click 'Upload File' and upload the  ```Automox_Installer-1.0.28.msi``` file. DO NOT change the naming of the .msi file. The File Name must read 'Automox_Installer-1.0.28.msi'. This gets uploaded to the working directory of the device for Falcon sensor.  Here is the link to Download the [Automox_Installer-1.0.28.msi](https://console.automox.com/Automox_Installer-1.0.28.msi)

8.  **Upload the installation script to install Automox**: You must create the Automox .msi installation command as a ps1 script in the Falcon Console. Then, the Deploy-Automox script will use the created ps1 script to run the installation command against the Automox .msi file in the devices working directory for the Falcon sensor. You create the script using the Falcon Console by navigating to Response Scripts & Files > Custom Scripts. From there, click 'Create a script'. You will need to ensure the 2 values below are added to the custom script exactly as they are shown, and the script permissions are set accordingly:
```
Script Name:   AxAgentInstall.ps1
Script:        .\Automox_Installer-1.0.28.msi ACCESSKEY=<your_org_access_key> /quiet

Permission:    RTR Active Responder and RTR Administrator
````
 You will need to add your Automox organization access key where it says ```<your_org_access_key>``` to the script command. 
 example:```ACCESSKEY=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx```

**NOTE** You can add as many arguments to the Automox install command script. The above is for basic quiet install of Automox into your organization. visit https://support.automox.com for more install options for the Automox agent.

9. Once you have the custom script saved you can now run the Deploy-Automox.ps1 script.


### Deploy-Automox.ps1 

1. Copy the [Deploy-Automox.ps1](https://github.com/shakeybonesz/crowdstrike/blob/master/Deploy-Automox.ps1) script locally to the device you will be performing the deployment from. 

2. execute the ```Deploy-Automox.ps1``` script on the device. This script creates a powershell module on the device called ```Deploy-AxAgent```

Here is an example of the ```Deploy-AxAgent``` usage after running the ```Deploy-Automox.ps1```

```PS C:\> .\Deploy-Automox.ps1

PS C:\> Deploy-AxAgent
cmdlet Deploy-AxAgent at command pipeline position 1
Supply values for the following parameters:
Id: <string>
Secret: <string> 
```

The ```Id``` and ```Secret``` parameter is your 'client ID' and 'client Secret' you get from your OAuth2 app you created in the Falcon console in Step 2 of the Prerequisites instructions above.

3. You can now run Deploy-AxAgent to perform the install of the Automox agent to the devices you specified in your HostList.csv using the Falcon console. The final command would go as follows:

```

Deploy-AxAgent -Id '<your_client_id>' -Secret '<your_client_secret>'


```

The Automox agent should now be installed successfully on all your devices and reporting into your Automox console!


