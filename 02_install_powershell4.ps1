Set-ExecutionPolicy Unrestricted
if ($PSVersionTable.PSVersion.Major -lt 4) {
  cinst powershell4
  $title = "Reboot"
  $message = "Sometimes a reboot is required after upgrading to Powershell 4. Would you like to reboot now to be safe?"
  
  $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", `
      "Reboot now."
  
  $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", `
      "Do not reboot now."
  
  $options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
  
  $result = $host.ui.PromptForChoice($title, $message, $options, 0) 
  
  switch ($result)
      {
          0 { 
            shutdown /r
          }
          1 { "Not rebooting."}
      }
} else {
  Write-Host "You already have Powershell version 4 or higher!"
}
