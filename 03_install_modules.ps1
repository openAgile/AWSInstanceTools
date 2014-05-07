cinst AWSTools.Powershell
(new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex
Import-Module psget
Install-Module AWSInstanceTools -Global
Import-Module AWSInstanceTools
