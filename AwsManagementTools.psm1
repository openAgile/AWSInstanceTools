filter Is-Running {
    if($_.State.Name -eq 'running') { $_ }
}

filter IsNot-Running {
    if($_.State.Name -ne 'running') { $_ }
}

filter IsNot-Stopped {
    if($_.State.Name -ne 'stopped') { $_ }
}

function Stop-AllEC2Instances {
    (Get-EC2Instance).Instances | IsNot-Stopped |
    % { Stop-EC2Instance -Instance $_.InstanceId -Force }
}

function Get-EC2InstancesWithFilter {
    param([parameter(Mandatory=$true)][string]$filter)
    (Get-EC2Instance -Filter @{ Name="tag:Name"; Value="$filter"}).Instances
}

function Write-RunningInfo {
    param([parameter(Mandatory=$true,ValueFromPipeline=$true)] [object]$instance)
    process {
        Write-Host $instance.InstanceId : "<$($instance.PublicIpAddress)>" : $instance.State.Name : $instance.Tags.Value
    }
}

function Write-NotRunningInfo {
    param([parameter(Mandatory=$true,ValueFromPipeline=$true)] [object]$instance)
    process {
        Write-Host $instance.InstanceId : $instance.State.Name : $instance.Tags.Value
    }
}

function Get-EC2InstancesStatus {
    param(
    [parameter(Mandatory=$true)][object[]]$instancesId,
    [parameter(Mandatory=$true)][string]$retry)
    
    $maxRetries = 20
    $instances  = (Get-EC2Instance -Instance $instancesId).Instances
    ($running = $instances | Is-Running) | Write-RunningInfo
    $notRunning = $instances | IsNot-Running
    
    $keepGoing = ($notRunning -ne $null) -and ($notRunning.Length -gt 0) -and ($retry -lt $maxRetries)
    $stop = ($notRunning -ne $null) -and ($notRunning.Length -gt 0)
    
    if ($keepGoing)
    {
        Write-Host "Waiting for the next instances to start..."
        $notRunning | Write-NotRunningInfo
        Start-Sleep -s 30
        Get-EC2InstancesStatus $notRunning.InstanceId ($retry + 1)
    }
    elseif($stop)
    {
        Write-Host "After $maxRetries retries the next instances failed to go into running."
        $notRunning | Write-NotRunningInfo
    }
}

function Start-EC2InstancesWithFilter {
    param([parameter(Mandatory=$true)] [string]$filter)
    
    ($instances = Get-EC2InstancesWithFilter $filter | IsNot-Running ) |
    Start-EC2Instance >> $null
    
    Get-EC2InstancesStatus $instances.InstanceId 1
    Write-Host "Finished running Start-EC2InstancesWithFilter."
}