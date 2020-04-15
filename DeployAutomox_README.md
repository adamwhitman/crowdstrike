# crowdstrike

# Deploy-Automox

### Prerequites
1.  Device running script needs to have **[PowerShell 5.1+](https://github.com/PowerShell/PowerShell#get-powershell)** installed


2. **OAuth2 App Creation**: Interacting with the CrowdStrike Falcon OAuth2 APIs requires an **[API Client ID and Secret](https://falcon.crowdstrike.com/support/api-clients-and-keys)** and a valid OAuth2 token. You will need to create this in the Falcon console to use for the script.
    

3. **List of Hosts for Deployment**: Using the Falcon Console, export Hosts > Host Management as a CSV. Remove all columns in the CSV except Hostname, Last Seen and Host ID of the devices you want to deploy the Automox agent to. 
   
      **WARNING**: Failing to remove the ‘policy’ columns will cause unexpected results. The ‘policy’ columns have line breaks which PowerShell has issues interpreting.


4. **Saving the host csv list** Save the csv file and name it ```HostList.csv```. Failure to name the csv file exactly as shown will cause the script to fail


5. **Required location of HostList.csv**: Put the HostList.csv file in the ```C:``` directory of the device you will be running the script from. The script calls ```c:\HostList.csv```, so '``HostList.csv'` need to be in the ``'C:``` directory 

6. **Upload the Automox .msi file**: Upload the ```Automox_Installer-1.0.28.msi``` file using the Falcon Console by navigating to Response Scripts & Files > "PUT" Files. From there, click 'Upload File' and upload the  ```Automox_Installer-1.0.28.msi``` file. DO NOT change the naming of the .msi file. The File Name must read 'Automox_Installer-1.0.28.msi'. This gets uploaded to the working directory of the device for Falcon sensor

7.  **Upload the installation script to install Automox**: You must upload the installation command powershell syntax as a ps1 script into the Falcon Console. Then, the Deploy-Automox script will use the uploaded ps1 script to run the installation command against the .msi file in the devices working directory for the Falcon sensor. You create the script using the Falcon Console by navigating to Response Scripts & Files > Custom Scripts. From there, click 'Create a script'. You will need to ensure the 2 values below are added to the custom script exactly as they are shown. 
```
Script Name:   AxAgentInstall.ps1
Script:        .\Automox_Installer-1.0.28.msi ACCESSKEY=<your_org_access_key> /quiet 
````
**NOTE** You can add as many arguments to the install command script. The abovew is for basic quiet install of Automox into your organization. visit https://support.automox.com for more install options for the Automox agent.

