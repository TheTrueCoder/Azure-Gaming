# Define constants
$Location = "australiaeast"
$VMName = "NCloudVM"

# Check Azure authentication
if ([string]::IsNullOrEmpty($(Get-AzContext).Account)) {Connect-AzAccount}

# Brief user on password
Write-Output "Make sure to pick a password compliant with windows server spec."
Write-Output "Basically, make sure you have lowercase and uppercase letters and use either numbers and/or special characters"
Write-Output "And make sure it doesn't contain your username."
Write-Output "https://docs.microsoft.com/en-us/windows/security/threat-protection/security-policy-settings/password-must-meet-complexity-requirements"

# Get user credentials
$creds = Get-Credential -Message "Choose your login credentials for the VM"

# Cloud resources start after here
# Make Resource Group
$ResourceGroup = New-AzResourceGroup -Name $VMName -Location $Location
Write-Output "Resource Group created."

# Make basic VM
Write-Output "Starting VM. This can take a long time and it has no progress indicator."
New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroup.ResourceGroupName `
-TemplateFile .\templates\vm.template.json -TemplateParameterFile .\templates\vm.setup.params.json `
-adminUsername $creds.UserName -adminPassword $creds.Password

Write-Output "A Virtual Machine has been started that can't run games, but is much cheaper, for you to setup you logins and install your game."
Write-Output "Keep in mind that this VM has nothing related to any previous runs of this script, as all the resources and related data is deleted at the end to save cost."

Read-Host "Press enter when you are ready to connect to your VM."
Get-AzRemoteDesktopFile -ResourceGroupName $ResourceGroup.ResourceGroupName -Name $VMName -Launch
