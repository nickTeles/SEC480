$symbols = '!@#$%^&*'.ToCharArray()
$characterList = 'a'..'z' + 'A'..'Z' +'0'..'9' + $symbols

function GeneratePassword {
    param (
        [ValidateRange(12,256)]
        [int]
        $length = 14
    )

    do {
        $password = -join (0..$length | % { $characterList | Get-Random })
        [int]$hasLowerChar = $password -cmatch '[a-z]'
        [int]$hasUpperChar = $password -cmatch '[A-Z]'
        [int]$hasDigit = $password -match '[0-9]'
        [int]$hasSymbol = $password.IndexOfAny($symbols) -ne -1

    }

    until (($hasLowerChar + $hasUpperChar + $hasDigit + $hasSymbol) -ge 3)
    $password
}

$users = Import-CSV ./AllstarFull.csv

$account_header = "name,account_name,group,password"
$group_header = "team"

$accountfile = "accounts.csv"

$groupfile = "groups.txt"

$account_array = @()
$group_array = @()

$account_array += $account_header
$group_array += $group_header

foreach ($user in $users)
{
    $account_name = $user.playerID
    $account_name = $account_name -replace '\s','.'
    $group_name = $user.teamID.ToLower()
    $group_name = $group_name -replace '\s','_'

    $pw = GeneratePassword(12)
    $row = "{0},{1},{2},{3}" -f $user.playerID, $account_name, $group_name, $pw
    $account_array += $row
}

$groups = $users | Select-Object -Property teamID -Unique -ExpandProperty teamID | Select-Object -Skip 0
#Write-Output $groups[0]
#Write-Output $groups
foreach ($group in $groups) {
    #Write-Output $group
    #Write-Output "++++++++++"
    #Write-Output $group.teamID
    $group_array += $group
    #Write-Output $group_array
    #if($group.teamID)
    #{
    #    #Write-Output $group
    #    $group_name = $user.teamID.ToLower()
    #    $group_name = $group_name -replace '\s','_'
    #    $group_array += $group_name
    #    Write-Output $group_array
    #}
}

$account_array | Out-File $accountfile
$group_array | Out-File $groupfile