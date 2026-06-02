# Basic settings
$rg = "rg-kw-ADLab-created-with-powershell"
$vm = "kw-dc-ps"
$vnetName = "$rg-vnet"

# Remove VM
Remove-AzVM -ResourceGroupName $rg -Name $vm -Force

# Remove NIC
Remove-AzNetworkInterface -ResourceGroupName $rg -Name "$vm-nic" -Force

# Remove Public IP
Remove-AzPublicIpAddress -ResourceGroupName $rg -Name "$vm-pip" -Force

# Remove NSG
Remove-AzNetworkSecurityGroup -ResourceGroupName $rg -Name "$vm-nsg" -Force

# Remove VNet
Remove-AzVirtualNetwork -ResourceGroupName $rg -Name $vnetName -Force

# Remove Resource Group
Remove-AzResourceGroup -Name $rg -Force

Write-Output "All resources have been removed."