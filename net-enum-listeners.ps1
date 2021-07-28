param ($p, [Switch]$l, [Switch]$h)

function Get-Usage
{
	Write-Output "usage: .\net-enum-listeners.ps1 [-h] -p protocol [-l]" 
	Write-Output ""
	Write-Output "Options:"
	Write-Output "-h`tPrint this help"
	Write-Output "-p`tProtocol (TCP, UDP, TCPv6 or UDPv6)"
	Write-Output "-l`tOnly display listeners on localhost"	
}

function Get-Output
{
	param ($p)
	
	if ($p -eq 'TCP' -or $p -eq 'UDP')
	{
		$localhost = "127.0.0.1"
	}
	
	elseif ($p -eq 'TCPv6' -or $p -eq 'UDPv6')
	{
		$localhost = "\[::1\]"	
	}
		
	if ($p -eq 'TCP' -or $p -eq 'TCPv6')
	{
		$output = "netstat -anop $p | findstr LISTENING"
	}
	
	elseif ($p -eq 'UDP' -or $p -eq 'UDPv6')
	{
		$output = "netstat -anop $p | Select-Object -Skip 4"
	}

	if ($l -eq $true)
	{
		$output = "$output | findstr $localhost"
	}
	
	$output = Invoke-Expression $output

	if ($output -eq $null)
	{
		Write-Output "No results"
		Exit 0
	}
	
	return $output
	
}

if ($h -eq $true)
{
	Get-Usage
	Exit 0
}

if (@('TCP','UDP','TCPv6','UDPv6') -notcontains $p)
{
	Get-Usage
	Exit 1
}

elseif ($p -eq $null)
{
	Get-Usage
	Exit 0
}

# Get netstat output based on provided protocol
$output = Get-Output -p $p

foreach ($line in $output)
{
	[regex]$re = "(?:TCP|UDP)\s+(\S+:\d+)"
	$listener = $re.Match($line).groups[1].value
		
	if ($p -eq 'TCP' -or $p -eq 'TCPv6')
	{
		[regex]$re = "LISTENING\s+(\d+)"
		$process_id = $re.Match($line).groups[1].value
	}

	elseif ($p -eq 'UDP' -or $p -eq 'UDPv6')
	{
		[regex]$re = "\*:\*\s+(\d+)"
		$process_id = $re.Match($line).groups[1].value	
	}
	
	$line2 = tasklist /svc | findstr /rc:"\<$process_id\>"
	
	[regex]$re = "\s+\d+\s(.+)"
	$match = $re.Match($line2).groups[0].value

	# Get process and services for corresponding PID of listener
	$process = $line2.replace($match, '')
	$service = $re.Match($line2).groups[1].value.trim()
		
	$p = $p.ToUpper()
	
	Write-Output "Protocol: $p"
	Write-Output "Local address: $listener"
	Write-Output "PID: $process_id"
	Write-Output "Process: $process"
	Write-Output "Service: $service"
	Write-Output "`n"
}

