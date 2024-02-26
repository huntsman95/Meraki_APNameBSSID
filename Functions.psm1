
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

#$APIKey = Get-Content $($PSScriptRoot + "\apikey.txt")

function Get-MerakiHeaders {
     $APIKey = [MerakiBSSIDMapper]::APIKey()

     $headers = @{}
     $headers.Add('X-Cisco-Meraki-API-Key', $apiKey)
     $headers.Add('Content-Type', 'application/json')
     $headers.Add('Accept', '*/*')

     return $headers
}

$BaseAPIURL = 'https://api.meraki.com/api/v1'


#########

function Get-MerakiNetworks {
     Param(
          [Parameter(Mandatory = $true, ValueFromPipeline = $true)][string]$OrgID
     )
     $EndpointURL = $BaseAPIURL + "/organizations/$OrgID/networks"
     $headers = Get-MerakiHeaders

     return (Invoke-RestMethod -Uri $EndpointURL -Method GET -Headers $headers)

}

function Get-MerakiOrganizations {

     $EndpointURL = $BaseAPIURL + '/organizations'
     $headers = Get-MerakiHeaders

     return (Invoke-RestMethod -Uri $EndpointURL -Method GET -Headers $headers)

}


function Get-MerakiOrganizationDevices {

     Param(
          [Parameter(Mandatory = $true, ValueFromPipeline = $true)][string]$OrgID
     )

     $EndpointURL = $BaseAPIURL + "/organizations/$OrgID/devices"
     $headers = Get-MerakiHeaders

     return (Invoke-RestMethod -Uri $EndpointURL -Method GET -Headers $headers)

}

function Get-MerakiAPBSSID {

     Param(
          [Parameter(Mandatory = $true, ValueFromPipeline = $true)][string]$SN
     )

     $EndpointURL = $BaseAPIURL + "/devices/$SN/wireless/status"
     $headers = Get-MerakiHeaders

     return (Invoke-RestMethod -Uri $EndpointURL -Method GET -Headers $headers).basicServiceSets

}

function Get-MerakiAPLLDPCDP {

     Param(
          [Parameter(Mandatory = $true, ValueFromPipeline = $true)][string]$SN
     )

     $EndpointURL = $BaseAPIURL + "/devices/$SN/lldpCdp"
     $headers = Get-MerakiHeaders

     return (Invoke-RestMethod -Uri $EndpointURL -Method GET -Headers $headers)

}

function ShowSplash {
     $ESC = [char]27
     "$ESC[38;2;211;1;252m"
     '|=======================================================================|'
     "$ESC[38;2;227;227;227m"
     '      /$$      /$$ /$$$$$$$$ /$$$$$$$   /$$$$$$  /$$   /$$ /$$$$$$
     | $$$    /$$$| $$_____/| $$__  $$ /$$__  $$| $$  /$$/|_  $$_/
     | $$$$  /$$$$| $$      | $$  \ $$| $$  \ $$| $$ /$$/   | $$  
     | $$ $$/$$ $$| $$$$$   | $$$$$$$/| $$$$$$$$| $$$$$/    | $$  
     | $$  $$$| $$| $$__/   | $$__  $$| $$__  $$| $$  $$    | $$  
     | $$\  $ | $$| $$      | $$  \ $$| $$  | $$| $$\  $$   | $$  
     | $$ \/  | $$| $$$$$$$$| $$  | $$| $$  | $$| $$ \  $$ /$$$$$$
     |__/     |__/|________/|__/  |__/|__/  |__/|__/  \__/|______/
            ___    ____        __   ____ __________ ________ 
           /   |  / __ \     _/_/  / __ ) ___/ ___//  _/ __ \
          / /| | / /_/ /   _/_/   / __  \__ \\__ \ / // / / /
         / ___ |/ ____/  _/_/    / /_/ /__/ /__/ // // /_/ / 
        /_/  |_/_/      /_/     /_____/____/____/___/_____/  
'
     "$ESC[38;2;252;186;3m"
     '                   *             (    (         (     
                 (  `     (      )\ ) )\ )      )\ )  
                 )\))(    )\    (()/((()/( (   (()/(  
                ((_)()\((((_)(   /(_))/(_)))\   /(_)) 
                (_()((_))\ _ )\ (_)) (_)) ((_) (_))   
                |  \/  |(_)_\(_)| _ \| _ \| __|| _ \  
                | |\/| | / _ \  |  _/|  _/| _| |   /  
                |_|  |_|/_/ \_\ |_|  |_|  |___||_|_\  
'
     "$ESC[38;2;211;1;252m"
     '   			 
|=======================================================================|'
     "$ESC[0m"
     '         COPYRIGHT (C) HUNTER KLEIN 2024 ALL RIGHTS RESERVED'
     "$ESC[38;2;102;255;154m"
     '.__                  __                               ________.________
|  |__  __ __  _____/  |_  ______ _____ _____    ____/   __   \   ____/
|  |  \|  |  \/    \   __\/  ___//     \\__  \  /    \____    /____  \ 
|   Y  \  |  /   |  \  |  \___ \|  Y Y  \/ __ \|   |  \ /    //       \
|___|  /____/|___|  /__| /____  >__|_|  (____  /___|  //____//______  /
     \/           \/          \/      \/     \/     \/              \/ 
'
     "$ESC[38;2;211;1;252m"                                                              
     '|=======================================================================|'
     "$ESC[0m"
}

Export-ModuleMember Get-MerakiAPLLDPCDP, Get-MerakiAPBSSID, Get-MerakiNetworks, Get-MerakiOrganizationDevices, Get-MerakiOrganizations, ShowSplash