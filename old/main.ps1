$brandName = "NCloud"

#Initialise vars
$ResourceGroup = "PS_$brandName"
$Location = "australiaeast"
$ImageId = "/subscriptions/50248d07-cf32-4323-be00-c0db0e8eb9f0/resourceGroups/AUS_CloudGaming/providers/Microsoft.Compute/images/Gaming-Template-Small"
$VMSizes = "Standard_B2ms", "Standard_NV6"

#Scripts
$VMStartScript = "startTemplate.ps1"

#------------------------------------/

if ([string]::IsNullOrEmpty($(Get-AzContext).Account)) {Connect-AzAccount}

# Write-Output "All available Azure locations"
# (Get-AzLocation).Location
# Write-Output "Choose an Azure location for this service. (The location must have NV6 GPU instances)"
# $Location = Read-Host -Prompt "Azure location"

#Instances check
$AvalInst = (Get-AzVMSize -Location $Location).Name
if ($AvalInst -match "NV6" -and $AvalInst -match "B2s") 
{Write-Output "It's got all the instances required"}

#Get Credentials
Write-Output "`n`nMake sure to keep your login credentials elsewhere"
Write-Output "And make sure your password is compatible with windows server policy: https://docs.microsoft.com/en-us/windows/security/threat-protection/security-policy-settings/password-must-meet-complexity-requirements"
#$creds = Get-Credential -Message "Choose your login credentials for the VM"
$LoginName = Read-Host -Prompt "Choose a Username"
$LoginPassword = Read-Host -Prompt "Choose a Password"

$VMName = Read-Host -Prompt "What do you want to call your VM? (Only alpanumeric characters!)"

$GameDiskSizeGB = Read-Host -Prompt "How many GB do you need for your VM Game drive? Nearest power of two recommended."
$GameDiskSizeGB = [int]$GameDiskSizeGB

# Create Resource Group
New-AzResourceGroup -Name $ResourceGroup -Location $Location

while (1) {
    $response = Read-Host -Prompt "Enter command"

    if($response -eq "exit"){
        if((Read-Host -Prompt "Do you want to delete resources created by this script? (y Recommended) y/n") -eq "y"){Remove-AzResourceGroup -Name $ResourceGroup}
        Write-Output "Always check the azure portal resource groups a couple minutes after this script has ended for leftover resources"
        exit
    }
    elseif ($response -eq "list-vars"){
        # Lists all variables for debugging
        Get-Variable -Scope 0
    }
    elseif ($response -eq "Start Setup VM") {
        $VMNo = 0
        Invoke-Expression -Command $PSScriptRoot/$VMStartScript
    }
    else {
        # Help message
        "Available commands:"
        "Main:"
        "   Start Setup VM"
        "Debug:"
        "   list-vars"
    }
}