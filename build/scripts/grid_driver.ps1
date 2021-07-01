mkdir ~\nvdriver
Set-Location ~\nvdriver

# Download Az supported GRID driver.
Invoke-WebRequest -Uri $DRIVERURL -OutFile 461.09_grid_server2019_64bit_azure.exe
#wget.exe -O 461.09_grid_server2019_64bit_azure.exe https://go.microsoft.com/fwlink/?linkid=874181

# Extract Driver package
7z.exe x .\461.09_grid_server2019_64bit_azure.exe

# Install driver silently
#.\setup.exe -s
PNPUtil.exe /add-driver .\Display.Driver\nvgridsw_azure.inf /install

# Delete install files
Set-Location ~
Remove-Item ~\nvdriver -Recurse