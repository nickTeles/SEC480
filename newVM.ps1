#Created by Nicholas Teles
#Variables for a new vm
#DO NOT RUN AS SITS RIGHT NOW!!!
$vserver="vcenter.nicholas.local.nicholas.local"
Connect-VIServer($vserver)
Get-VM
$vm=Get-VM -Name xubuntu-wan
$snapshot = Get-Snapshot -VM $vm -Name "Base"
$vmhost = Get-VMHost -Name "192.168.3.126"
$ds = Get-DataStore -Name datastore2-super7
$linkedname = "{0}.linked" -f $vm.name
$linkedvm = New-VM -LinkedClone -Name $linkedname -VM $vm -ReferenceSnapshot $snapshot -VMHost $vmhost -Datastore $ds
$newvm = New-VM -Name "xubuntu-20.04-base" -VM $linkedvm -VMHost $vmhost -Datastore $ds
$newvm | new-snapshot -Name "Base"
$linkedvm | Remove-VM