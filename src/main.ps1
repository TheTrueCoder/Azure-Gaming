#Initialise vars
$ResourceGroup = "PS_Cloud-Gaming"
$Location = "australiaeast"
$Image = "Gaming-Template-Small"
$VMSizes = ""

#Scripts
$VMStartScript = "startvm.ps1"

#------------------------------------/

if ([string]::IsNullOrEmpty($(Get-AzContext).Account)) 
{Connect-AzAccount}

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
$creds = Get-Credential -Message "Choose your login credentials for the VM"

$VMName = Read-Host -Prompt "What do you want to call your VM?"

$GameDiskSizeGB = [int]Read-Host -Prompt "How many GB do you need for your VM Game drive? Nearest power of two recommended."

#Create Resource Group
New-AzResourceGroup -Name $ResourceGroup -Location $Location

while (1) {
    $input = Read-Host -Prompt "Enter command"

    if($input -eq "exit"){
        if((Read-Host -Prompt "Do you want to delete resources created by this script? (Recommended)") -contains "n","N")Remove-AzResourceGroup -Name $ResourceGroup
        Write-Output "Always check the azure portal resource groups a couple minutes after this script has ended for leftover resources"
        Write-Output "Get-AzImage -ImageName `"Gaming-Template-Small`""
        exit
    }
    elseif ($input -eq "list-vars"){
        #Lists all variables for debugging
        Get-Variable -Scope 0
    }
    elseif ($input -eq "Start Setup VM") {
        Invoke-Expression -Command $PSScriptRoot/$VMStartScript
    }
    else {
        #Help message
        "Available commands:"
        "Main:"
        "Debug:"
    }
}