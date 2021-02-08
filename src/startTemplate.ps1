$Location = "australiaeast"
$ResourceGroup = New-AzResourceGroup -Name "CoolStuff" -Location $Location
New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroup -TemplateFile .\templates\vm-template.json -TemplateParameterFile .\templates\vm.setup.json