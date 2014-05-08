$hasCho=False
if (!(gcm cinst)) {
  Write-Host "You don't have Chocolatey! Trying to install it for you..."
  cmd /c" PS C:\Users\JGough> cmd /c "@powershell -NoProfile -ExecutionPolicy unrestricted -Command ""iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))"" && SET PATH=%PATH%;%systemdrive%\chocolatey\bin"
  if ($?) {
   $hasChoc=True
  }
} else {
 $hasChoc=True
}
Write-Host $hasChoc

if ($PSVersionTable.PSVersion.Major -gt 3)
