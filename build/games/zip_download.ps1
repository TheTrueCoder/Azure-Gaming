$INSTALLLOC=$env:INSTALLLOC
$ZIPURL=$env:ZIPURL

# Location to download driver files
$TEMPLOC="~\zipinstall"
Write-Host "Install Location: $INSTALLLOC"
Write-Host "Host package url: $ZIPURL"

mkdir $TEMPLOC
Set-Location $TEMPLOC

# Download Zip Package.
Invoke-WebRequest -Uri $ZIPURL -OutFile parsecrelease.zip

# Extract Zip package
mkdir $INSTALLLOC
Expand-Archive -Path parsecrelease.zip -DestinationPath $INSTALLLOC -Force

# Delete install files
Set-Location ~
Remove-Item $TEMPLOC -Recurse