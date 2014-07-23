write-host "`nStart: Installing Chocolatey`...n"
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
write-host "`Finished: Installing Chocolatey`n"

write-host "`nStart: Installing Powershell 4 if you do not already have it...`n"
if ($PSVersionTable.PSVersion.Major -lt 4) {
  cinst powershell4
  if ($? -eq $true) {
    write-host "`nFinished upgrading you to Powershell 4. But, you need to open a new Administrator Powershell window now and run this command: TODO`n"
  }
  else {
    write-error "Could not upgrade you to Powershell 4!"
  }
}
