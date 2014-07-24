cinst AWSTools.Powershell
#Import-Module 'C:\Program Files (x86)\AWS Tools\PowerShell\AWSPowerShell\AWSPowerShell.psd1'
Import-Module AWSPowerShell
if (test-path \\files\pub\openAgile\ProviderCredentials\AmazonWebServices\InitializeDefaultCreds.ps1) {
  write-host "Setting your default credentials for AWS..."
  \\files\pub\openAgile\ProviderCredentials\AmazonWebServices\InitializeDefaultCreds.ps1
}
(new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex
Import-Module psget
Install-Module AWSInstanceTools -Global -Update
Import-Module AWSInstanceTools