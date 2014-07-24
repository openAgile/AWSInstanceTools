cinst AWSTools.Powershell
Import-Module 'C:\Program Files (x86)\AWS Tools\PowerShell\AWSPowerShell\AWSPowerShell.psd1'
if (test-path \\files\pub\openAgile\ProviderCredentials\AmazonWebServices\InitializeDefaultCreds.ps1) {
  write-host "Setting your default credentials for AWS..."
  \\files\pub\openAgile\ProviderCredentials\AmazonWebServices\InitializeDefaultCreds.ps1
} else {
	Write-Error "You are either not on the VersionOne network or you're not a VersionOne employee! Please refer to the AWS Tools for Windows Powershell documentation for setting your default credentials to AWS."
}
(new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex
Import-Module psget
Install-Module AWSInstanceTools -Global -Update
Import-Module AWSInstanceTools