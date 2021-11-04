#Created by Nicholas Teles
$vserver="vcenter.nicholas.local.nicholas.local"
Connect-VIServer($vserver)
$createorstart = Read-Host -Prompt "[A] Ansible [C] Create VM`n[S] Start VM`n[N]Change VM Network`n[M] Make New Network`n[I] See IP Address`nPlease choose an option: "
#Ansible
if ($createorstart -eq "A") {
    (Get-VMGuest -VM blue7-fw).IPAddress
    ansible-playbook -i ansible/blue7-fw/vyos1.txt --user vyos --ask-pass ansible/vyos-config1.yml
} elseif ($createorstart -eq "a") {
    (Get-VMGuest -VM blue7-fw).IPAddress
    ansible-playbook -i ansible/blue7-fw/vyos1.txt --user vyos --ask-pass ansible/vyos-config1.yml
}
#Change Network
elseif ($createorstart -eq "N") {
    $vmnetworkname = Read-Host -Prompt "What VM would you like to change the network on? "
    $newnetworkname = Read-Host -Prompt "What do you want the new network to be? "
    Get-VM $vmnetworkname | Get-NetworkAdapter | Set-NetworkAdapter -NetworkName $newnetworkname
} elseif ($createorstart -eq "n") {
    $vmnetworkname = Read-Host -Prompt "What VM would you like to change the network on? "
    $newnetworkname = Read-Host -Prompt "What do you want the new network to be? "
    Get-VM $vmnetworkname | Get-NetworkAdapter | Set-NetworkAdapter -NetworkName $newnetworkname
} 
#Make New Network
elseif ($createorstart -eq "M") {
    $networkname = Read-Host -Prompt "What would you like to name the network? "
    New-VirtualSwitch -Name $networkname -VMHost "192.168.3.126" -Mtu 9000
    New-VirtualPortGroup -VirtualSwitch $networkname -Name $networkname
} elseif ($createorstart -eq "m") {
    $networkname = Read-Host -Prompt "What would you like to name the network? "
    New-VirtualSwitch -Name $networkname -VMHost "192.168.3.126" -Mtu 9000
    New-VirtualPortGroup -VirtualSwitch $networkname -Name $networkname
} 
#See IP Address
elseif ($createorstart -eq "I") {
    $vmnameip = Read-Host -Prompt "VM to see the IP Address of: "
    (Get-VM -Name $vmnameip).Guest.IPAddress
} elseif ($createorstart -eq "i") {
    $vmnameip = Read-Host -Prompt "VM to see the IP Address of: "
    (Get-VM -Name $vmnameip).Guest.IPAddress
} 
#Start VM
elseif ($createorstart -eq "S") {
    $vmstartname = Read-Host -Prompt "vm to start: "
    Start-VM $vmstartname
} elseif ($createorstart -eq "s") {
    $vmstartname = Read-Host -Prompt "vm to start: "
    Start-VM $vmstartname
} 
#Create VM
elseif ($createorstart -eq "C") {
    $vmhost = Get-VMHost -Name "192.168.3.126"
    Get-VM
    $vm = Read-Host -Prompt "Please choose a VM to get a snapshot from`n"
    $snapshot = Get-Snapshot -VM $vm -Name "Base"
    Get-Datastore
    $ds = Read-Host -Prompt "Please choose a datastore for the VM to be stored on`n"
    $linkedorfull = Read-Host -Prompt "[L] Linked Clone`n[F] Full Clone`nPlease Choose an Option: "

    if ($linkedorfull -eq "L")
    {
        $linkedname = Read-Host -Prompt "VM Name: "
        $linkedvm = New-VM -LinkedClone -Name $linkedname -VM $vm -ReferenceSnapshot $snapshot -VMHost $vmhost -Datastore $ds
    } elseif ($linkedorfull -eq "l")
    {
        $linkedname = Read-Host -Prompt "VM Name: "
        $linkedvm = New-VM -LinkedClone -Name $linkedname -VM $vm -ReferenceSnapshot $snapshot -VMHost $vmhost -Datastore $ds
    } elseif ($linkedorfull -eq "F")
    {
        $linkedname = "{0}.linked" -f $vm.name
        $fullname = Read-Host -Prompt "VM Name: "
        $linkedvm = New-VM -LinkedClone -Name $linkedname -VM $vm -ReferenceSnapshot $snapshot -VMHost $vmhost -Datastore $ds
        $newvm = New-VM -Name $fullname -VM $linkedvm -VMHost $vmhost -Datastore $ds
        $newvm | new-snapshot -Name "Base"
        $linkedvm | Remove-VM
    } elseif ($linkedorfull -eq "f")
    {
        $linkedname = "{0}.linked" -f $vm.name
        $fullname = Read-Host -Prompt "VM Name: "
        $linkedvm = New-VM -LinkedClone -Name $linkedname -VM $vm -ReferenceSnapshot $snapshot -VMHost $vmhost -Datastore $ds
        $newvm = New-VM -Name $fullname -VM $linkedvm -VMHost $vmhost -Datastore $ds
        $newvm | new-snapshot -Name "Base"
        $linkedvm | Remove-VM
    } else {
        print "Invalid Option"
        Exit-PSHostProcess
    }
} elseif ($startorcreate -eq "c") {
    $vmhost = Get-VMHost -Name "192.168.3.126"
    Get-VM
    $vm = Read-Host -Prompt "Please choose a VM to get a snapshot from`n"
    $snapshot = Get-Snapshot -VM $vm -Name "Base"
    Get-Datastore
    $ds = Read-Host -Prompt "Please choose a datastore for the VM to be stored on`n"
    $linkedorfull = Read-Host -Prompt "[L] Linked Clone`n[F] Full Clone`nPlease Choose an Option: "
    
    if ($linkedorfull -eq "L")
    {
        $linkedname = Read-Host -Prompt "VM Name: "
        $linkedvm = New-VM -LinkedClone -Name $linkedname -VM $vm -ReferenceSnapshot $snapshot -VMHost $vmhost -Datastore $ds
    } elseif ($linkedorfull -eq "l")
    {
        $linkedname = Read-Host -Prompt "VM Name: "
        $linkedvm = New-VM -LinkedClone -Name $linkedname -VM $vm -ReferenceSnapshot $snapshot -VMHost $vmhost -Datastore $ds
    } elseif ($linkedorfull -eq "F")
    {
        $linkedname = "{0}.linked" -f $vm.name
        $fullname = Read-Host -Prompt "VM Name: "
        $linkedvm = New-VM -LinkedClone -Name $linkedname -VM $vm -ReferenceSnapshot $snapshot -VMHost $vmhost -Datastore $ds
        $newvm = New-VM -Name $fullname -VM $linkedvm -VMHost $vmhost -Datastore $ds
        $newvm | new-snapshot -Name "Base"
        $linkedvm | Remove-VM
    } elseif ($linkedorfull -eq "f")
    {
        $linkedname = "{0}.linked" -f $vm.name
        $fullname = Read-Host -Prompt "VM Name: "
        $linkedvm = New-VM -LinkedClone -Name $linkedname -VM $vm -ReferenceSnapshot $snapshot -VMHost $vmhost -Datastore $ds
        $newvm = New-VM -Name $fullname -VM $linkedvm -VMHost $vmhost -Datastore $ds
        $newvm | new-snapshot -Name "Base"
        $linkedvm | Remove-VM
    } else {
        print "Invalid Option"
        Exit-PSHostProcess
    }
} else {
    Exit-PSHostProcess
}


#createnetwork -networkName "BLUE7-LAN" -esxi_host-name "192.168.3.126" -vcenter_server "vcenter.nicholas.local.nicholas.local"
#cloner -config_path "./480-utils.json"