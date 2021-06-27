# Parameters
# The resource ID of an image gallery image version.
$srcImgId = "/subscriptions/50248d07-cf32-4323-be00-c0db0e8eb9f0/resourceGroups/AUS_CloudGaming_Gallery/providers/Microsoft.Compute/galleries/CloudGaming_Gallery/images/CavesRD-CRB/versions/1.0.0"
$imagename = "rockybeach"

$location = "australiaeast"

# Constants
$rgname = "azgamingvhds"
$saname = $rgname
$containername = "vhds"


$rg = New-AzResourceGroup -Location $location -Name $rgname

$sa = New-AzStorageAccount -ResourceGroupName $rgname -Location $location -Name $saname -SkuName "Standard_LRS"
$context = New-AzStorageContext -StorageAccountName $saname -UseConnectedAccount
$container = New-AzStorageContainer -Name $containername -Context $context

$galleryImageReference = @{Id = $srcImgId; Lun=1}
$diskConfig = New-AzDiskConfig -Location $location -CreateOption 'FromImage' -GalleryImageReference $srcImgId;
New-AzDisk -ResourceGroupName $rgname -DiskName "$imagename-disk" -Disk $diskConfig

$sas = Grant-AzDiskAccess -ResourceGroupName $rgname -DiskName "$imagename-disk" -Access Read -DurationInSecond (60*60*24)
$blobcopy = Start-AzStorageBlobCopy -AbsoluteUri $sas.AccessSAS -DestinationContainer $containername -DestinationBlob "$imagename.vhd" -DestinationContext $context

While ($status.Status -eq "Pending") {
    $status = $blobcopy | Get-AzStorageBlobCopyState
    $status
    Start-Sleep 10
}

Get-AzStorageBlob -Context $context -Blob "$imagename.vhd" -Container $containername