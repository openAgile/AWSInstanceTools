# AWSInstanceTools

Amazon Web Services Instance Tools lets you simplify using the AWS Powershell Tools to start and stop your AWS EC2 virtual machines.

# Requirements

* Powershell 4.0

# Install

It's easy to install using our install scripts 01 - 03. 

* If you don't have Chocolatey, open `CMD.exe` and run script #1 to install Chocolatey. Once done, open a **brand new Powershell** window as Administrator.
* Type `Set-ExecutionPoliciy Unrestricted` to allow running *powerful* scripts.
* If you don't have Powershell 4, or don't know what version you have, open Powershell as Administrator and run script #2 by typing `./02_install_powershell4.ps1`. This determines if you need to upgrade and uses Chocolatey to install Powershell 4 if you do. **Warning: this will prompt you to reboot to ensure all path environment variables are updated. You can try without rebooting, but you might need to anyway.**
* Finally, run script #3 from Powershell to install PsGet and the AWSInstanceTools themselves.

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
