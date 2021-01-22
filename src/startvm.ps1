$InstanceSize = $VMSizes[$VMNo]
$InstanceSize

# Variables for common values
$resourceGroup = $ResourceGroup
$location = $Location
$vmName = $VMName
$cred = $creds

# Create a subnet configuration
$subnetConfig = New-AzVirtualNetworkSubnetConfig -Name $brandName`_Subnet -AddressPrefix 192.168.1.0/24

# Create a virtual network
$vnet = New-AzVirtualNetwork -ResourceGroupName $resourceGroup -Location $location `
  -Name $brandName`_Network -AddressPrefix 192.168.0.0/16 -Subnet $subnetConfig

# Create a public IP address and specify a DNS name
$pip = New-AzPublicIpAddress -ResourceGroupName $resourceGroup -Location $location `
  -Name $vmName`_$brandName$ -DomainNameLabel $vmName-$brandName$(Get-Random -Maximum 99) -AllocationMethod Static -IdleTimeoutInMinutes 4 -

# Create an inbound network security group rule for port 3389
$nsgRuleRDP = New-AzNetworkSecurityRuleConfig -Name nsgRDPRule  -Protocol Tcp `
  -Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * `
  -DestinationPortRange 3389 -Access Allow

# Create a network security group
$nsg = New-AzNetworkSecurityGroup -ResourceGroupName $resourceGroup -Location $location `
  -Name $brandName`_NSG -SecurityRules $nsgRuleRDP

# Create a virtual network card and associate with public IP address and NSG
$nic = New-AzNetworkInterface -Name $vmName`_NIC -ResourceGroupName $resourceGroup -Location $location `
  -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id -NetworkSecurityGroupId $nsg.Id

# Create the disk for storing games
#$gamedisk = New-AzVMDataDisk -DiskSizeInGB $GameDiskSizeGB -Caching 'ReadOnly' -Lun 2 -CreateOption Attach -StorageAccountType Standard_LRS
#$gamedisk = New-AzDisk -DiskName $vmName-gamedisk -SkuName StandardSSD_LRS -DiskSizeGB $GameDiskSizeGB -Location $location -CreateOption Empty -ResourceGroupName $resourceGroup

# Create a virtual machine configuration
$vmConfig = New-AzVMConfig -VMName $vmName -VMSize $InstanceSize | `
Set-AzVMOperatingSystem -Windows -ComputerName $vmName -Credential $cred | `
Set-AzVMSourceImage -Id $ImageId | `
Set-AzVMOSDisk -StorageAccountType StandardSSD_LRS | `
Add-AzVMNetworkInterface -Id $nic.Id | `
Add-AzVMDataDisk -Name $vmName-gamedisk -DiskSizeInGB $GameDiskSizeGB -StorageAccountType StandardSSD_LRS -CreateOption Attach -Lun 1

# Create a virtual machine
New-AzVM -ResourceGroupName $resourceGroup -Location $location -VM $vmConfig

# Format any vm disks without a filesystem
Invoke-AzVMRunCommand -ResourceGroupName $resourceGroup -VMName $vmName -CommandId 'RunPowerShellScript' -ScriptPath 'formatdisk.ps1'
