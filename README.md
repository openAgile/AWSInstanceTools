# AWSInstanceTools

Amazon Web Services Instance Tools lets you simplify using the [AWS Powershell Tools](http://docs.aws.amazon.com/powershell/latest/userguide/pstools-getting-set-up.html) to start and stop your AWS EC2 virtual machines.

# Requirements

Don't worry, all of these will be installed with our installation script in the next step:

* Powershell 4.0
* Chocolatey
* AWS Tools for Windows Powershell
* PsGet

# Install

First of all, if you're installing this from VersionOne, make sure you are **in the office or connected to the VPN** because the scripts use a file from `\\files`. If you're not able to do that, you'll need to run the command in this private [GitHub file](https://github.com/versionone/ProviderCredentials/blob/master/AmazonWebServices/InitializeDefaultCreds.ps1) in Powershell once you've run the install script. This configures your system with our default credentials for AWS, and caches them so you don't have to do it every time.

## Do this:

* Open Powershell as Administrator.
* Type or copy and paste the following commands:
```
Set-ExecutionPolicy Unrestricted
(new-object net.webclient).DownloadString('https://raw.githubusercontent.com/openAgile/AWSInstanceTools/master/install.ps1') | iex
```
If all goes well, you should have everything installed now and be able to test your installation below!

## Notes for people outside of VersionOne

If you're using these tools from another company, you will have to follow the instructions in the [Amazon Powershell Tools Documentation](http://docs.aws.amazon.com/powershell/latest/userguide/pstools-getting-set-up.html) for getting your default credentials set up.

# Test installation

Once you have everything installed and your credentials set, try the example commands below.

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
Get-EC2InstancesWithFilter "ClarityOne*"
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
