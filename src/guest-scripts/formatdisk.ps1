# Source: https://stackoverflow.com/questions/42620986/formatting-a-disk-using-powershell-without-prompting-for-confirmation
$disk = Get-Disk | where-object PartitionStyle -eq "RAW"  
Initialize-Disk -Number $disk.Number -PartitionStyle GPT -confirm:$false  
New-Partition -DiskNumber $disk.Number -UseMaximumSize -IsActive | Format-Volume -FileSystem NTFS -NewFileSystemLabel "GameDisk" -confirm:$False  
Set-Partition -DiskNumber $disk.Number -PartitionNumber 1 -NewDriveLetter G
