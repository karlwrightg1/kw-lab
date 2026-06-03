# Basic Settings
$user = "kwright"
$pass = "ADEngineer2026#1"
$securePass = ConvertTo-SecureString -String $pass -AsPlainText -Force
$cred = New-Object PSCredential($user, $securePass)  # FIX: $cred was never defined

# Create Resource Groups  # FIX: locations updated to match intended regions
New-AzResourceGroup -Name "kw-lab-ADLab-sea" -Location "southeastasia"
New-AzResourceGroup -Name "kw-lab-ADLab-eus" -Location "centralus"
New-AzResourceGroup -Name "kw-lab-ADLab-cin" -Location "centralindia"

# ── SouthEast Asia VMs ──────────────────────────────────────────────────────────────
$loc = "southeastasia"  # FIX: was "centralus"
$rg  = "kw-lab-ADLab-sea"

# sea-dc1
$vm  = "sea-dc1"
$pip = New-AzPublicIPAddress -Name "$vm-pip" -ResourceGroupName $rg -Location $loc -AllocationMethod Static -Sku Standard
$vnet = New-AzVirtualNetwork -ResourceGroupName $rg -Location $loc -Name "vnet-$rg" -AddressPrefix "10.0.0.0/16" -Subnet (New-AzVirtualNetworkSubnetConfig -Name "default" -AddressPrefix "10.0.0.0/24")
$nic = New-AzNetworkInterface -Name "$vm-nic" -ResourceGroupName $rg -Location $loc -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id
$nsg = New-AzNetworkSecurityGroup -ResourceGroupName $rg -Location $loc -Name "$vm-nsg" -SecurityRules (New-AzNetworkSecurityRuleConfig -Name "RDP" -Protocol Tcp -Direction Inbound -Priority 100 -SourcePortRange * -SourceAddressPrefix * -DestinationPortRange 3389 -DestinationAddressPrefix * -Access Allow)
$nic.NetworkSecurityGroup = $nsg
Set-AzNetworkInterface -NetworkInterface $nic
$vmConfig = New-AzVMConfig -VMName $vm -VMSize "Standard_D2s_v3" |
    Set-AzVMOperatingSystem -Windows -ComputerName $vm -Credential $cred |
    Set-AzVMSourceImage -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2025-Datacenter-Azure-Edition" -Version "latest" |
    Add-AzVMNetworkInterface -Id $nic.Id
$vmConfig = Set-AzVMBootDiagnostic -VM $vmConfig -Disable  # FIX: was missing
New-AzVM -ResourceGroupName $rg -Location $loc -VM $vmConfig  # FIX: was missing

# sea-dc2
$vm  = "sea-dc2"
$pip = New-AzPublicIPAddress -Name "$vm-pip" -ResourceGroupName $rg -Location $loc -AllocationMethod Static -Sku Standard
$nic = New-AzNetworkInterface -Name "$vm-nic" -ResourceGroupName $rg -Location $loc -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id
$nsg = New-AzNetworkSecurityGroup -ResourceGroupName $rg -Location $loc -Name "$vm-nsg" -SecurityRules (New-AzNetworkSecurityRuleConfig -Name "RDP" -Protocol Tcp -Direction Inbound -Priority 100 -SourcePortRange * -SourceAddressPrefix * -DestinationPortRange 3389 -DestinationAddressPrefix * -Access Allow)
$nic.NetworkSecurityGroup = $nsg
Set-AzNetworkInterface -NetworkInterface $nic
$vmConfig = New-AzVMConfig -VMName $vm -VMSize "Standard_D2s_v3" |
    Set-AzVMOperatingSystem -Windows -ComputerName $vm -Credential $cred |
    Set-AzVMSourceImage -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2025-Datacenter-Azure-Edition" -Version "latest" |
    Add-AzVMNetworkInterface -Id $nic.Id
$vmConfig = Set-AzVMBootDiagnostic -VM $vmConfig -Disable  # FIX: was missing
New-AzVM -ResourceGroupName $rg -Location $loc -VM $vmConfig  # FIX: was missing

# ── East US VMs ───────────────────────────────────────────────────────────────
$loc = "centralus"  # FIX: was "centralus"
$rg  = "kw-lab-ADLab-eus"

# ny-dc1
$vm  = "ny-dc1"
$pip = New-AzPublicIPAddress -Name "$vm-pip" -ResourceGroupName $rg -Location $loc -AllocationMethod Static -Sku Standard
$vnet = New-AzVirtualNetwork -ResourceGroupName $rg -Location $loc -Name "vnet-$rg" -AddressPrefix "10.1.0.0/16" -Subnet (New-AzVirtualNetworkSubnetConfig -Name "default" -AddressPrefix "10.1.0.0/24")
$nic = New-AzNetworkInterface -Name "$vm-nic" -ResourceGroupName $rg -Location $loc -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id
$nsg = New-AzNetworkSecurityGroup -ResourceGroupName $rg -Location $loc -Name "$vm-nsg" -SecurityRules (New-AzNetworkSecurityRuleConfig -Name "RDP" -Protocol Tcp -Direction Inbound -Priority 100 -SourcePortRange * -SourceAddressPrefix * -DestinationPortRange 3389 -DestinationAddressPrefix * -Access Allow)
$nic.NetworkSecurityGroup = $nsg
Set-AzNetworkInterface -NetworkInterface $nic
$vmConfig = New-AzVMConfig -VMName $vm -VMSize "Standard_D2s_v3" |
    Set-AzVMOperatingSystem -Windows -ComputerName $vm -Credential $cred |
    Set-AzVMSourceImage -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2025-Datacenter-Azure-Edition" -Version "latest" |
    Add-AzVMNetworkInterface -Id $nic.Id
$vmConfig = Set-AzVMBootDiagnostic -VM $vmConfig -Disable  # FIX: was missing
New-AzVM -ResourceGroupName $rg -Location $loc -VM $vmConfig  # FIX: was missing

# ny-dc2
$vm  = "ny-dc2"
$pip = New-AzPublicIPAddress -Name "$vm-pip" -ResourceGroupName $rg -Location $loc -AllocationMethod Static -Sku Standard
$nic = New-AzNetworkInterface -Name "$vm-nic" -ResourceGroupName $rg -Location $loc -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id
$nsg = New-AzNetworkSecurityGroup -ResourceGroupName $rg -Location $loc -Name "$vm-nsg" -SecurityRules (New-AzNetworkSecurityRuleConfig -Name "RDP" -Protocol Tcp -Direction Inbound -Priority 100 -SourcePortRange * -SourceAddressPrefix * -DestinationPortRange 3389 -DestinationAddressPrefix * -Access Allow)
$nic.NetworkSecurityGroup = $nsg
Set-AzNetworkInterface -NetworkInterface $nic
$vmConfig = New-AzVMConfig -VMName $vm -VMSize "Standard_D2s_v3" |
    Set-AzVMOperatingSystem -Windows -ComputerName $vm -Credential $cred |
    Set-AzVMSourceImage -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2025-Datacenter-Azure-Edition" -Version "latest" |
    Add-AzVMNetworkInterface -Id $nic.Id
$vmConfig = Set-AzVMBootDiagnostic -VM $vmConfig -Disable  # FIX: was missing
New-AzVM -ResourceGroupName $rg -Location $loc -VM $vmConfig  # FIX: was missing

# ── Central India VMs ─────────────────────────────────────────────────────────
$loc = "centralindia"  # FIX: was "centralus"
$rg  = "kw-lab-ADLab-cin"

# mum-dc1
$vm  = "mum-dc1"
$pip = New-AzPublicIPAddress -Name "$vm-pip" -ResourceGroupName $rg -Location $loc -AllocationMethod Static -Sku Standard
$vnet = New-AzVirtualNetwork -ResourceGroupName $rg -Location $loc -Name "vnet-$rg" -AddressPrefix "10.2.0.0/16" -Subnet (New-AzVirtualNetworkSubnetConfig -Name "default" -AddressPrefix "10.2.0.0/24")
$nic = New-AzNetworkInterface -Name "$vm-nic" -ResourceGroupName $rg -Location $loc -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id
$nsg = New-AzNetworkSecurityGroup -ResourceGroupName $rg -Location $loc -Name "$vm-nsg" -SecurityRules (New-AzNetworkSecurityRuleConfig -Name "RDP" -Protocol Tcp -Direction Inbound -Priority 100 -SourcePortRange * -SourceAddressPrefix * -DestinationPortRange 3389 -DestinationAddressPrefix * -Access Allow)
$nic.NetworkSecurityGroup = $nsg
Set-AzNetworkInterface -NetworkInterface $nic
$vmConfig = New-AzVMConfig -VMName $vm -VMSize "Standard_D2s_v5" |
    Set-AzVMOperatingSystem -Windows -ComputerName $vm -Credential $cred |
    Set-AzVMSourceImage -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2025-Datacenter-Azure-Edition" -Version "latest" |
    Add-AzVMNetworkInterface -Id $nic.Id
$vmConfig = Set-AzVMBootDiagnostic -VM $vmConfig -Disable  # FIX: was missing
New-AzVM -ResourceGroupName $rg -Location $loc -VM $vmConfig  # FIX: was missing

# mum-dc2
$vm  = "mum-dc2"
$pip = New-AzPublicIPAddress -Name "$vm-pip" -ResourceGroupName $rg -Location $loc -AllocationMethod Static -Sku Standard
$nic = New-AzNetworkInterface -Name "$vm-nic" -ResourceGroupName $rg -Location $loc -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id
$nsg = New-AzNetworkSecurityGroup -ResourceGroupName $rg -Location $loc -Name "$vm-nsg" -SecurityRules (New-AzNetworkSecurityRuleConfig -Name "RDP" -Protocol Tcp -Direction Inbound -Priority 100 -SourcePortRange * -SourceAddressPrefix * -DestinationPortRange 3389 -DestinationAddressPrefix * -Access Allow)
$nic.NetworkSecurityGroup = $nsg
Set-AzNetworkInterface -NetworkInterface $nic
$vmConfig = New-AzVMConfig -VMName $vm -VMSize "Standard_D2s_v5" |
    Set-AzVMOperatingSystem -Windows -ComputerName $vm -Credential $cred |
    Set-AzVMSourceImage -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2025-Datacenter-Azure-Edition" -Version "latest" |
    Add-AzVMNetworkInterface -Id $nic.Id
$vmConfig = Set-AzVMBootDiagnostic -VM $vmConfig -Disable  # FIX: was missing
New-AzVM -ResourceGroupName $rg -Location $loc -VM $vmConfig  # FIX: was missing

# ── Output Connection Info ────────────────────────────────────────────────────
Write-Output "`n=== Connection Information ==="
Get-AzPublicIpAddress -ResourceGroupName "kw-lab-ADLab-sea" | ForEach-Object { Write-Output "VM: $($_.Name.Replace('-pip',''))  IP: $($_.IpAddress)  RDP: mstsc /v:$($_.IpAddress) /u:$user" }
Get-AzPublicIpAddress -ResourceGroupName "kw-lab-ADLab-eus" | ForEach-Object { Write-Output "VM: $($_.Name.Replace('-pip',''))  IP: $($_.IpAddress)  RDP: mstsc /v:$($_.IpAddress) /u:$user" }
Get-AzPublicIpAddress -ResourceGroupName "kw-lab-ADLab-cin" | ForEach-Object { Write-Output "VM: $($_.Name.Replace('-pip',''))  IP: $($_.IpAddress)  RDP: mstsc /v:$($_.IpAddress) /u:$user" }