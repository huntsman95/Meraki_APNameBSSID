Import-Module ($PSScriptRoot + "\Functions.psm1")
ShowSplash
$APIKey = Get-Content $($PSScriptRoot + "\apikey.txt") -ErrorAction SilentlyContinue

if($APIKey -eq $null -or $APIKey -eq ''){
$APIKey = Read-Host "Please provide your API Key"
if((Read-Host "Do you want to save your key to file? (WARNING: This will save it in plain-text!) [y/N]") -like "y"){
    $APIKey | Out-File $($PSScriptRoot + "\apikey.txt") -NoNewline
}
}

Add-Type @"
 using System;
 public class MerakiBSSIDMapper {
   public static string APIKey() {
     return `"$APIKey`";
   }
 }
"@

#Import-Module ($PSScriptRoot + "\Functions.psm1")

$OrgName = Read-Host "Please type all or part of the organization name"

$orgResults = Get-MerakiOrganizations | Where-Object {$_.name -like "*$OrgName*"}
Write-Host "Please Choose a Selection:"; $i = 0; $orgResults | % {Write-Host $([string]$i + ". " + $_.name); $i++}
[int]$orgSelection = Read-Host $("Enter number of selection [0-"+($i-1)+"]")
$OrgID = $orgResults[$orgSelection].id

Write-Host -ForegroundColor Yellow "Processing your request. Please wait; this may take a while due to API rate limiting..."

$APList = Get-MerakiOrganizationDevices -OrgID $OrgID | where {$_.model -like "MR*"}

$i = 0; $APTable = foreach($AP in $APList) {

    Write-Progress -Activity $("Processing AP: " + $AP.name) -PercentComplete $([Math]::Ceiling((($i / $APList.Count)*100))); $i++

    $BSSIDs = (Get-MerakiAPBSSID -SN $($AP.serial)).bssid

    $BSSIDs | % {New-Object -TypeName PSObject -Property ([ordered]@{Name=($AP.name); BSSID=$_})}

}

$csvSavePath = Read-Host "Enter save path for CSV Export"

$APTable | Export-Csv -Path $csvSavePath -NoTypeInformation