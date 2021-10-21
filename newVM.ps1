#Created by Nicholas Teles
$vserver="vcenter.nicholas.local.nicholas.local"
Connect-VIServer($vserver)
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