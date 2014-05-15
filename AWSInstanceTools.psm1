filter IsStopped {
    if($_.State.Name -eq 'stopped') { $_ }
}

filter IsRunning {
    if($_.State.Name -eq 'running') { $_ }
}

filter IsNotRunning {
    if($_.State.Name -ne 'running') { $_ }
}

filter IsNotStopped {
    if($_.State.Name -ne 'stopped') { $_ }
}

function Stop-AllEC2Instances {
    (Get-EC2Instance).Instances | IsRunning |
    % { Stop-EC2Instance -Instance $_.InstanceId -Force }
}

function Get-EC2InstancesWithFilter {
    param([parameter(Mandatory=$true)][string]$filter)
    (Get-EC2Instance -Filter @{ Name="tag:Name"; Value="$filter"}).Instances
}

function WriteRunningInfo {
    param([parameter(Mandatory=$true,ValueFromPipeline=$true)] [object]$instance)
    process {
        Write-Host $instance.InstanceId : "<$($instance.PublicIpAddress)>" : $instance.State.Name : $instance.Tags.Value
    }
}

function WriteNotRunningInfo {
    param([parameter(Mandatory=$true,ValueFromPipeline=$true)] [object]$instance)
    process {
        Write-Host $instance.InstanceId : $instance.State.Name : $instance.Tags.Value
    }
}

function GetEC2InstancesStatus {
    param(
    [parameter(Mandatory=$true)][object[]]$instancesId,
    [parameter(Mandatory=$true)][string]$retry)
    
    $maxRetries = 20
    $instances  = (Get-EC2Instance -Instance $instancesId).Instances
    ($running = $instances | IsRunning) | WriteRunningInfo
    $notRunning = $instances | IsNotRunning
    
    $keepGoing = ($notRunning -ne $null) -and ($notRunning.Length -gt 0) -and ($retry -lt $maxRetries)
    $stop = ($notRunning -ne $null) -and ($notRunning.Length -gt 0)
    
    if ($keepGoing)
    {
        Write-Host "Waiting for the next instances to start..."
        $notRunning | WriteNotRunningInfo
        Start-Sleep -s 30
        GetEC2InstancesStatus $notRunning.InstanceId ($retry + 1)
    }
    elseif($stop)
    {
        Write-Host "After $maxRetries retries the next instances failed to go into running."
        $notRunning | WriteNotRunningInfo
    }
}

function Start-EC2InstancesWithFilter {
    param([parameter(Mandatory=$true)] [string]$filter)
    
    ($instances = Get-EC2InstancesWithFilter $filter | IsStopped ) |
    Start-EC2Instance >> $null
    
    GetEC2InstancesStatus $instances.InstanceId 1
    Write-Host "Finished running Start-EC2InstancesWithFilter."
}

function Stop-EC2InstancesWithFilter {
    param([parameter(Mandatory=$true)] [string]$filter)
    
    ($instances = Get-EC2InstancesWithFilter $filter | IsRunning) |
    Stop-EC2Instance
}

Export-ModuleMember -Function Stop-AllEC2Instances,Get-EC2InstancesWithFilter,Start-EC2InstancesWithFilter,Stop-EC2InstancesWithFilter
