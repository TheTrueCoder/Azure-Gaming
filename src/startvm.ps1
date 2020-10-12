$InstanceSize = $VMSizes[$VMNo]
$InstanceSize

New-AzVM `
  -ResourceGroupName $ResourceGroup `
  -Name $VMName `
  -Location $Location `
  -Size $InstanceSize `
  -Image $ImageId `
  -VirtualNetworkName "$VMName`_Vnet" `
  -SubnetName "$VMName`_Subnet" `
  -SecurityGroupName "$VMName`_NetworkSecurityGroup" `
  -PublicIpAddressName "$VMName`_PublicIp" `
  -Credential $creds `
  -OpenPorts 3389