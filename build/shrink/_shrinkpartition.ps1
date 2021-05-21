# [CmdletBinding()]
#     param(
#         [Parameter()]
#         [string]$Size
#     )
# $partSize = $Size-1

Get-Partition -DiskNumber 0 -PartitionNumber 2 | Resize-Partition -Size 15GB