$Location = "australiaeast"
$creds = Get-Credential -Message "Choose your login credentials for the VM"
$ResourceGroup = New-AzResourceGroup -Name "CoolStuff" -Location $Location
New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroup.ResourceGroupName -TemplateFile .\templates\vm-template.json -TemplateParameterFile .\templates\vm.setup.json -adminUsername $creds.UserName -adminPassword $creds.Password