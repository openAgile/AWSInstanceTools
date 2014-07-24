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
		Write-Host "Powershell 4 upgrade succeeded! Now installing additional Chocolatey packages and Powershell modules...`n`n"
		powershell -Version 4.0 -NoExit -Command "(new-object net.webclient).DownloadString('https://raw.githubusercontent.com/openAgile/AWSInstanceTools/master/install_modules.ps1') | iex"
		if ($?) {
			Write-Host "AWSInstanceTools installation complete!"
		}
	} else {
	  Write-Error "Could not install Powershell 4 with Chocolatey. Please try to install it manually."
	  Write-Error "Once you've installed it manually, run this command from an Administrator Powershell prompt:`n`n(new-object net.webclient).DownloadString('https://raw.githubusercontent.com/openAgile/AWSInstanceTools/master/install_modules.ps1') | iex`n`n"
	}
} else {
	Write-Host "You already have Powershell 4 installed. Great! Now installing additional Chocolatey packages and Powershell modules..."
  	(new-object net.webclient).DownloadString('https://raw.githubusercontent.com/openAgile/AWSInstanceTools/master/install_modules.ps1') | iex
	if ($?) {
		Write-Host "AWSInstanceTools installation complete!"
	}
}
