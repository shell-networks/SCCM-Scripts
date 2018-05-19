<#
    .NOTES
    --------------------------------------------------------------------------------
    Code generated by:  Hands
    Generated on:       13/05/2018
    Generated by:       Guillaume Mateos
    Organization:       SHell Networks
    --------------------------------------------------------------------------------
    .SYNOPSIS
    Use this script to install all windows features on the SCCM Site Server
    .DESCRIPTION
    Has to be run from the site server computer 

    Installing all the followings : 

    .Net Framework 3.51 SP1
    .Net Framework 4
    IIS
    Remote Differential Compression
    BITS Server Extension
    WSUS 3.0 SP2
#>

$FeaturesSource = "Z:\sources\sxs"

$Features = @(
"Web-Windows-Auth",
"Web-ISAPI-Ext",
"Web-Metabase",
"Web-WMI",
"BITS",
"RDC",
"Web-Asp-Net",
"Web-Asp-Net45",
"NET-HTTP-Activation",
"NET-Non-HTTP-Activ",
"NET-Framework-Features",
"UpdateServices-Services",
"UpdateServices-WidDB"
)

foreach($Feature in $Features)
{
    Install-WindowsFeature -Name $Feature -source $FeaturesSource
}


