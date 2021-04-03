$rgName = "NCloud_Images"
$location = "australiaeast"
$vmSize = "Standard_DS1_v2"
# No of days before Service Principle expires
$SPDays = 1

# Make resource group
$rg = New-AzResourceGroup -Name $rgName -Location $location

# Create Az service principle and convert the password to a plain string.
# -Scope $rg.ResourceId 
$sp = New-AzADServicePrincipal -DisplayName "PackerSP$(Get-Random)" -EndDate (Get-Date).AddDays($SPDays)
$appID = $sp.ApplicationId.Guid
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($sp.Secret)
$plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

# Get subscription
$sub = Get-AzSubscription

# Write-Output "App ID:", $sp.ApplicationId.Guid
# Write-Output "Password:", $plainPassword
# Write-Output "Run the command (Remove-AzADServicePrincipal -DisplayName PackerSP*) after building the image to prevent unauthorised access to your account."

# Set Packer Azure authentication
$PKR_VAR_az_client_id = $appID
$PKR_VAR_az_client_secret = $plainPassword
$PKR_VAR_az_tenant_id = $sub.TenantId
$PKR_VAR_az_subscription_id = $sub.Id

# Other config
$PKR_VAR_resource_group = $rgName
$PKR_VAR_azure_region = $location
$PKR_VAR_vm_size = $vmSize

$text = "y"
while ($text -eq "y") {
    packer build ./medWindows.json.pkr.hcl
    $text = Read-Host "Would you like to try again (y/n)?"
}


Remove-AzADServicePrincipal -DisplayName PackerSP* -Force
Remove-AzResourceGroup -Id $rg.ResourceId -Force
