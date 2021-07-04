$DRIVERURL=$env:DRIVERURL

# Location to download driver files
$TEMPLOC="~\nvdriver"
Write-Output "Driverurl: $DRIVERURL"

mkdir $TEMPLOC
Set-Location $TEMPLOC

# Download Az supported GRID driver.
Invoke-WebRequest -Uri $DRIVERURL -OutFile grid_server2019_64bit_azure.exe
#wget.exe -O grid_server2019_64bit_azure.exe https://go.microsoft.com/fwlink/?linkid=874181

# Extract Driver package
7z.exe x .\grid_server2019_64bit_azure.exe

# Install driver silently
#.\setup.exe -s
PNPUtil.exe /add-driver .\Display.Driver\nvgridsw_azure.inf /install

# Delete install files
Set-Location ~
Remove-Item $TEMPLOC -Recurse