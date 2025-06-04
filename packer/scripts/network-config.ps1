Write-Host 'Configuring static IP address...'
$hostOnlyAdapter = Get-NetAdapter | Where-Object { $_.InterfaceDescription -like '*Host-Only*' }
if ($hostOnlyAdapter) {
  Remove-NetIPAddress -InterfaceAlias $hostOnlyAdapter.Name -Confirm:$false -ErrorAction SilentlyContinue
  Remove-NetRoute -InterfaceAlias $hostOnlyAdapter.Name -Confirm:$false -ErrorAction SilentlyContinue
  New-NetIPAddress -InterfaceAlias $hostOnlyAdapter.Name -IPAddress '192.168.56.10' -PrefixLength 24 -DefaultGateway '192.168.56.1'
  Set-DnsClientServerAddress -InterfaceAlias $hostOnlyAdapter.Name -ServerAddresses '8.8.8.8'
  Write-Host 'Static IP configured on Host-Only adapter'
} else {
  Write-Host 'Host-Only adapter not found, configuring first available adapter'
  $adapter = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' } | Select-Object -First 1
  Remove-NetIPAddress -InterfaceAlias $adapter.Name -Confirm:$false -ErrorAction SilentlyContinue
  Remove-NetRoute -InterfaceAlias $adapter.Name -Confirm:$false -ErrorAction SilentlyContinue
  New-NetIPAddress -InterfaceAlias $adapter.Name -IPAddress '192.168.56.10' -PrefixLength 24 -DefaultGateway '192.168.56.1'
  Set-DnsClientServerAddress -InterfaceAlias $adapter.Name -ServerAddresses '192.168.56.10'
}
