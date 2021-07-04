$INSTALLLOC=$env:INSTALLLOC
$ZIPURL=$env:ZIPURL

# Location to download driver files
$TEMPLOC="~\parsechost"
Write-Host "Install Location: $INSTALLLOC"
Write-Host "Host package url: $ZIPURL"

mkdir $TEMPLOC
Set-Location $TEMPLOC

# Download Zip Package.
Invoke-WebRequest -Uri $ZIPURL -OutFile parsecrelease.zip

# Extract Zip package
mkdir $INSTALLLOC
7z.exe x -o$INSTALLLOC .\parsecrelease.zip

# Delete install files
Set-Location ~
Remove-Item $TEMPLOC -Recurse