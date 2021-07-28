# net-enum-listeners

PowerShell script for enumerating network processes listening on internal ports.

## Description

This script enumerates internal network processes and the corresponding services on Windows machines without using admin privileges. This can be used during the post-exploitation phase where you need to determine what process is running on an internal port. This can be useful for CTFs and for the OSCP when trying to escalate privileges. The script can display network processes using the following protcols: TCP, UDP, TCPv6 and UDPv6. This script should work on Windows 7 and above.

## Usage

```
> .\net-enum-listeners.ps1 -h
usage: .\net-enum-listeners.ps1 [-h] -p protocol [-l]

Options:
-h      Print this help
-p      Protocol (TCP, UDP, TCPv6 or UDPv6)
-l      Only display listeners on localhost
```

## Examples

Displaying processes listening on localhost over TCP:

```
> powershell -ExecutionPolicy bypass -file .\net-enum-listeners.ps1 -p tcp -l
Protocol: TCP
Local address: 127.0.0.1:5037
PID: 22968
Process: adb.exe
Service: N/A
```

Displaying processes listening on all interfaces over TCP (includes processes not accessible from outside due to firewall):

```
> powershell -ExecutionPolicy bypass -file .\net-enum-listeners.ps1 -p tcp
Protocol: TCP
Local address: 0.0.0.0:135
PID: 1348
Process: svchost.exe
Service: RpcEptMapper, RpcSs


Protocol: TCP
Local address: 0.0.0.0:443
PID: 5156
Process: svchost.exe
Service: iphlpsvc


Protocol: TCP
Local address: 0.0.0.0:445
PID: 4
Process: System
Service: N/A
```

Displaying processes listening on localhost over TCPv6:

```
powershell -ExecutionPolicy bypass -file .\net-enum-listeners.ps1 -p tcpv6 -l
Protocol: TCPV6
Local address: [::1]:49670
PID: 5852
Process: jhi_service.exe
Service: jhi_service
```

## Links

Enumerating Internal Network Processes Using net-enum-listeners: https://oncybersec.com/enumerating-internal-network-processes-using-net-enum-listeners/
