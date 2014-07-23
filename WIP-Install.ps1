$hasChoc=$false
if (!(gcm cinst)) {
  Write-Host "You don't have Chocolatey. Trying to install it for you..."
  (new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1') | iex
  if ($?) {
   $hasChoc=$true
  }
} else {
 $hasChoc=$true
}
Write-Host Chocolatey installed? $hasChoc

if ($PSVersionTable.PSVersion.Major -lt 4) {
	Write-Host "You don't have Powershell 4. Trying to install it for you via Chocolatey..."
	cinst powershell4
	if ($?) {
		# Start a new shell in Powershell 4...
		Write-Host Powershell version: $PSVersionTable.PSVersion.Major
		# TODO: finish this...
	}
} else {
  (new-object net.webclient).DownloadString('https://raw.githubusercontent.com/openAgile/AWSInstanceTools/master/03_install_modules.ps1') | iex
}
