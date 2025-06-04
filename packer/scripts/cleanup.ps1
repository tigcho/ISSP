Write-Output "***** Starting cleanup process"

Write-Output "***** Cleaning Windows Update cache"
Stop-Service wuauserv -Force -ErrorAction SilentlyContinue
Remove-Item C:\Windows\SoftwareDistribution\Download\* -Recurse -Force -ErrorAction SilentlyContinue
Start-Service wuauserv -ErrorAction SilentlyContinue

Write-Output "***** Cleaning temporary files"
Remove-Item C:\Windows\Temp\* -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item $env:TEMP\* -Recurse -Force -ErrorAction SilentlyContinue

Write-Output "***** Defragmenting disk"
Optimize-Volume -DriveLetter C -Defrag -Verbose

Write-Output "***** Cleanup completed"
