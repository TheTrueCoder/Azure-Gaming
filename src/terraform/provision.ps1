# Log output
Start-Transcript -Path 'C:\parsec\provision.log'
Write-Output $PARSEC_SESSIONID
# Start Parsec Host
Start-Process 'C:\parsec\host\host.exe' -ArgumentList $PARSEC_SESSIONID
Stop-Transcript
# Exit with code zero to ensure module succeeds.
exit 0