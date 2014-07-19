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

#deprecated
function Stop-AllEC2InstancesExcept {
    param([parameter(Mandatory=$true)][string]$filter)
    Write-Host 'Deprecated, use Stop-AllEC2Instances -exclude instead.' -ForegroundColor Red
    (Get-EC2Instance).Instances | IsRunning |
    ? { 
       if( $_.Tags.Key.Contains("Name"))
       {
            $i = $_.Tags.Key.IndexOf("Name")
            $_.Tags[$i].Value -notlike $filter
       }
       else
       { $true }
    } |
    % { Stop-EC2Instance -Instance $_.InstanceId -Force }
}

#deprecated
function Get-EC2InstancesWithFilter {
    param([parameter(Mandatory=$true)][string]$filter)
    Write-Host 'Deprecated, use Get-EC2InstancesWithTagName instead.' -ForegroundColor Red
    (Get-EC2Instance -Filter @{ Name="tag:Name"; Value="$filter"}).Instances
}

#deprecated
function Stop-EC2InstancesWithFilter {
    param([parameter(Mandatory=$true)] [string]$filter)
    Write-Host 'Deprecated, use Stop-EC2InstancesWithTagName instead.' -ForegroundColor Red
    ($instances = Get-EC2InstancesWithFilter $filter | IsRunning) |
    Stop-EC2Instance
}

#deprecated
function Start-EC2InstancesWithFilter {
    param([parameter(Mandatory=$true)] [string]$filter)
    Write-Host 'Deprecated, use Start-EC2InstancesWithTagName instead.' -ForegroundColor Red
    
    ($instances = Get-EC2InstancesWithFilter $filter | IsStopped ) |
    Start-EC2Instance >> $null
    
    GetEC2InstancesStatus $instances.InstanceId 1
    Write-Host "Finished running Start-EC2InstancesWithFilter."
}

# private functions
function FilterInstances {
    param(
    [parameter(Mandatory=$true)]$instances,
    [parameter(Mandatory=$true)]$filters)
    
    $instances | ? { 
        if( $_.Tags.Key.Contains("Name"))
        {
            $tagIndex = $_.Tags.Key.IndexOf("Name")
            $tagValue = $_.Tags[$tagIndex].Value
            $shouldPass = $true
            # every instance iterates over all the filters, it should be true for all of them (not like any of the filter)
            $filters | % { $shouldPass = ($shouldPass -and $tagValue -notlike $_)}
            $shouldPass
        }
        #if it doesn't have name tag get it too
        else {
            $true
        }
    }
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
# public functions

function Stop-AllEC2Instances {
    param($exclude)
    
    $instances = $null
    if($exclude -eq $null) {
        $instances = (Get-EC2Instance).Instances
    } else { 
        $instances = Get-EC2InstancesWithTagName -exclude $exclude
    }
    
    $instances | IsRunning |
    % { Stop-EC2Instance -Instance $_.InstanceId -Force }
}

function Get-EC2InstancesWithTagName {
    param(
    [parameter(Mandatory=$true,Position=0)]$tagName,    
    $exclude)
    
    $instances = (Get-EC2Instance -Filter @{ Name="tag:Name"; Value="$tagName"}).Instances
    
    if($exclude -ne $null) {
        $instances = (FilterInstances $instances $exclude)
    }
    
    $instances
}

function Start-EC2InstancesWithTagName {
    param([parameter(Mandatory=$true)] $tagName)
    
    ($instances = Get-EC2InstancesWithTagName $tagName | IsStopped ) |
    Start-EC2Instance >> $null
    
    GetEC2InstancesStatus $instances.InstanceId 1
    Write-Host "Finished running Start-EC2InstancesWithFilter."
}

function Stop-EC2InstancesWithTagName {
    param([parameter(Mandatory=$true)] $tagName)
    
    ($instances = Get-EC2InstancesWithTagName $tagName | IsRunning) |
    Stop-EC2Instance
}

Export-ModuleMember -Function Stop-AllEC2Instances,Stop-AllEC2InstancesExcept,Get-EC2InstancesWithTagName,Get-EC2InstancesWithFilter,Start-EC2InstancesWithTagName,Start-EC2InstancesWithFilter,Stop-EC2InstancesWithTagName,Stop-EC2InstancesWithFilter
