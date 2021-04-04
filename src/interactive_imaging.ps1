# Define constants
$Location = "australiaeast"
$VMName = "NCloudVM"
$SrcImageID = "/subscriptions/50248d07-cf32-4323-be00-c0db0e8eb9f0/resourceGroups/AUS_CloudGaming/providers/Microsoft.Compute/images/Base-Windows"

$DstImageName = "CavesRD-CRB"
$DstRG = "AUS_CloudGaming"

$SetupSize = "Standard_F2"

$User = "Gaming"

# Check Azure authentication
if ([string]::IsNullOrEmpty($(Get-AzContext).Account)) {Connect-AzAccount}

# Brief user on password
Write-Output "Make sure to pick a password compliant with windows server spec."
Write-Output "Basically, make sure you have lowercase and uppercase letters and use either numbers and/or special characters"
Write-Output "And make sure it doesn't contain your username."
Write-Output "https://docs.microsoft.com/en-us/windows/security/threat-protection/security-policy-settings/password-must-meet-complexity-requirements"

# Get user credentials
if ((Read-Host "Do you want to chose your own login (y/N)?") -eq "y") {
   $creds = Get-Credential -Message "Choose your login credentials for the VM"
}
else {
    $pswdStr = "U&M$([system.guid]::NewGuid().tostring().replace('-','').substring(1,15))"
    $PWord = ConvertTo-SecureString -String $pswdStr -AsPlainText -Force
    $creds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
    Write-Output "Username: $User" 
    Write-Output "Password: $pswdStr"
}

# Cloud resources start after here
# Make Resource Group
$ResourceGroup = New-AzResourceGroup -Name $VMName -Location $Location
$RGName = $ResourceGroup.ResourceGroupName
Write-Output "Resource Group created."

# Make basic VM
Write-Output "Starting VM. This can take a long time and it has no progress indicator."
New-AzResourceGroupDeployment -ResourceGroupName $RGName `
-TemplateFile .\templates\vm.template.json -TemplateParameterFile .\templates\vm.setup.params.json `
-adminUsername $creds.UserName -adminPassword $creds.Password `
-image $SrcImageID `
-virtualMachineSize $SetupSize


Write-Output "A Virtual Machine has been started that can't run games, but is much cheaper, for you to setup you logins and install your game."
Write-Output "Keep in mind that this VM has nothing related to any previous runs of this script, as all the resources and related data is deleted at the end to save cost."

Read-Host "Press enter when you are ready to connect to your VM."
Get-AzRemoteDesktopFile -ResourceGroupName $RGName -Name $VMName -Launch
Write-Output ""

while (1) {
    Write-Output "image, rdp-connect, exit"
    $response = Read-Host -Prompt "Choose an option"

    if ($response -eq "image") {
        # Make image
        Stop-AzVM -ResourceGroupName $RGName -Name $VMName -Force
        Set-AzVM -ResourceGroupName $RGName -Name $VMName -Generalized
        $vm = Get-AzVM -Name $VMName -ResourceGroupName $RGName
        $image = New-AzImageConfig -Location $location -SourceVirtualMachineId $vm.Id
        New-AzImage -Image $image -ImageName $DstImageName -ResourceGroupName $DstRG
    }

    if ($response -eq "rdp-connect") {
        Get-AzRemoteDesktopFile -ResourceGroupName $RGName -Name $VMName -Launch
    }

    if ($response -eq "exit") {
        Write-Output "Always check the azure portal resource groups a couple minutes after this script has ended for leftover resources"
        Remove-AzResourceGroup -ResourceGroupName $RGName
        exit
    }
}
