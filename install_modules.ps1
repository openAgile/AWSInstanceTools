cinst AWSTools.Powershell
$awsPath=$Env:ProgramFiles
if (test-path ${Env:ProgramFiles(x86)}) {
	$awsPath=${Env:ProgramFiles(x86)}
}
Import-Module "$awsPath\AWS Tools\PowerShell\AWSPowerShell\AWSPowerShell.psd1"
if (test-path \\files\pub\openAgile\ProviderCredentials\AmazonWebServices\InitializeDefaultCreds.ps1) {
  write-host "Setting your default credentials for AWS..."
  \\files\pub\openAgile\ProviderCredentials\AmazonWebServices\InitializeDefaultCreds.ps1
} else {
	Write-Error "You are either not on the VersionOne network or you're not a VersionOne employee! Please refer to the AWS Tools for Windows Powershell documentation for caching your default AWS credentials."
}
(new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex
Import-Module psget
Install-Module AWSInstanceTools -Global
Import-Module AWSInstanceTools
Update-Module AWSInstanceTools -Global
