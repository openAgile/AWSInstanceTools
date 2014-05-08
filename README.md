# AWSInstanceTools

Amazon Web Services Instance Tools lets you simplify using the [AWS Powershell Tools](http://docs.aws.amazon.com/powershell/latest/userguide/pstools-getting-set-up.html) to start and stop your AWS EC2 virtual machines.

# Requirements

Don't worry, all of these will be installed with our set up scripts:

* Powershell 4.0
* Chocolatey
* PsGet

# Install

It's easy to install using our install scripts 01 - 03. 

* Open Powershell as Administrator
* Clone this repository with `git clone https://github.com/openAgile/AWSInstanceTools.git`
* Type `cd AWSInstanceTools`
* Type `cinst` to see if you already have Chocolatey installed. If not, type `cmd` to start a simple command shell, then types `01_install_chocolatey.bat` to install Chocolatey. When done, open a **brand new Powershell** window as Administrator so that you have an updated PATH.
* Type `Set-ExecutionPoliciy Unrestricted` to allow running *powerful* scripts.
* Type `$PSVersionTable.PSVersion` to see you already have Powershell 4 installed. If not, type `.\02_install_powershell4.ps1`. This determines if you need to upgrade and uses Chocolatey to install Powershell 4 if you do. **Warning: this will prompt you to reboot to ensure all path environment variables are updated. You can try without rebooting, but you might need to anyway.**
* Next, type `.\03_install_modules.ps1` from Powershell to install **PsGet** and the **AWSInstanceTools** module.
* **VersionOne Team:** If you're using this as a VersionOne employee, go to our private `ProviderCredentials` repo and execute the `AmazonWebServices/InitializeDefaultCreds.ps1` script in your Powershell window. This will configure your system with the credentials for AWS. The configuration is saved, so you never have to do it again.
* If you're using these tools from another company, you will have to follow the instructions in the [Amazon Powershell Tools Documentation](http://docs.aws.amazon.com/powershell/latest/userguide/pstools-getting-set-up.html) for getting your default credentials set up.

Once you have everything installed and your credentials set, you can try these example commands:

# Usage

To test that you are configured correctly, run this command:

```powershell
Get-EC2InstancesWithFilter "*"  | select -expand Tags
```

Expect something like this as a result:

```
PS C:\Users\Daniel> Get-EC2InstancesWithFilter "*"  | select -expand Tags

Key                                                         Value
---                                                         -----
Name                                                        i-12345678
Name                                                        i-0abcdefg
Name                                                        ClarityOne Sandbox - V1
Name                                                        ClarityOne Sandbox - Clarity PPM
Name                                                        Demo Data
Name                                                        i-23456789
Name                                                        Clarity PPM
```


# Get several instances' IP addresses
We can get one or more instances by passing a filter. This filters by the tag name:

```powershell
Get-EC2InstancesWithFilter "ClarityOne*" | select -expand PublicIpAddress
```

The previous example gets all the instances with the tag name that starts with "ClarityOne".
We can also reduce the amount of information we show. Doing the next we only show the ip addresses for those instances:

```powershell
Get-EC2InstancesWithFilter "ClarityOne*" | select -expand PublicIpAddress
```

# Stopping all instances
If you want to stop all running instances, but not terminate them, then do this:

```powershell
Stop-AllEC2Instances
```

# Stopping several instances with a filter
The next works in the same way as `Get-EC2InstancesWithFilter`, but instead of getting the instances it stops them:

```powershell
Stop-EC2InstancesWithFilter "Clarity*"
```

# Starting several instances with a filter 
Like the previous example, but starts instances:

```powershell
Start-EC2InstancesWithFilter "Clarity*"
```
