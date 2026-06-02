# Basic Settings
$rg = "rg-kw-ADLab-created-with-powershell"
$vm = "kw-dc-ps"
$loc = "centralus"
$user = "kwright"
$pass = ConvertTo-SecureString "ADEngineer2026#1" -AsPlainText -Force

# Create Resource Group
New-AzResourceGroup -Name $rg -Location $loc -Force

# Create VNet and Subnet
$subnet = New-AzVirtualNetworkSubnetConfig -Name "default" -AddressPrefix "10.0.0.0/24"
$vnet = New-AzVirtualNetwork -Name "$rg-vnet" -ResourceGroupName $rg -Location $loc -AddressPrefix "10.0.0.0/16" -Subnet $subnet

# Create Public IP and NIC
$pip = New-AzPublicIPAddress -Name "$vm-pip" -ResourceGroupName $rg -Location $loc -AllocationMethod Static -Sku Standard
$nic = New-AzNetworkInterface -Name "$vm-nic" -ResourceGroupName $rg -Location $loc -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id

# Create NSG Rule for RDP
$nsgRuleRDP = New-AzNetworkSecurityRuleConfig -Name "RDP" -Protocol Tcp -Direction Inbound -Priority 100 -SourcePortRange * -SourceAddressPrefix * -DestinationPortRange 3389 -DestinationAddressPrefix * -Access Allow
$nsg = New-AzNetworkSecurityGroup -ResourceGroupName $rg -Location $loc -Name "$vm-nsg" -SecurityRules $nsgRuleRDP
$nic.NetworkSecurityGroup = $nsg
Set-AzNetworkInterface -NetworkInterface $nic

# Create VM Config
$cred = New-Object PSCredential($user, $pass)
$vmConfig = New-AzVMConfig -VMName $vm -VMSize "Standard_D2s_v5" |
    Set-AzVMOperatingSystem -Windows -ComputerName $vm -Credential $cred |
    Set-AzVMSourceImage -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2025-Datacenter-Azure-Edition" -Version "latest" |
    Add-AzVMNetworkInterface -Id $nic.Id

# Disable Boot Diagnostics
$vmConfig = Set-AzVMBootDiagnostic -VM $vmConfig -Disable

# Create the VM
New-AzVM -ResourceGroupName $rg -Location $loc -VM $vmConfig

# Output VM Details
$newVM = Get-AzVM -ResourceGroupName $rg -Name $vm
$newPIP = Get-AzPublicIpAddress -ResourceGroupName $rg -Name "$vm-pip"
Write-Output "VM: $vm"
Write-Output "User: $user"
Write-Output "Public IP: $($newPIP.IpAddress)"
Write-Output "Connect via RDP using these credentials and the public IP"