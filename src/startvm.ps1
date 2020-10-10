

New-AzVM `
  -ResourceGroupName $ResourceGroup `
  -Name $VMName `
  -Location $Location `
  -VMSize $InstanceSize `
  -Image $Image `
  -VirtualNetworkName "$VMName`_Vnet" `
  -SubnetName "$VMName`_Subnet" `
  -SecurityGroupName "$VMName`_NetworkSecurityGroup" `
  -PublicIpAddressName "$VMName`_PublicIp" `
  -Credential $creds `
  -OpenPorts 3389