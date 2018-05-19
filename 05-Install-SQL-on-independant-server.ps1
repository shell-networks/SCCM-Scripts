<#
    .NOTES
    --------------------------------------------------------------------------------
    Code generated by:  Hands
    Generated on:       13/05/2018
    Generated by:       Guillaume Mateos
    Organization:       SHell Networks
    --------------------------------------------------------------------------------
    .SYNOPSIS
    Automatic Installation of SQL Server 2012 for SCCM
    .DESCRIPTION
    Automatic Installation of SQL Server 2012 for SCCM
    Create inbound firewall rules
#>

$SqlExePath = "D:\Setup.exe" #Indicate there where is stored the .exe

$SccmSQLConfigFile = ".\05-SQL-ConfigurationFile.ini" #Here is the custom ini file, feel free to adapt to your needs

& $SqlExePath /IACCEPTSQLSERVERLICENSETERMS /CONFIGURATIONFILE=$SccmSQLConfigFile /QUIETSIMPLE

New-NetFirewallRule -Name "SQL SCCM INBOUND" -DisplayName "SQL SCCM INBOUND" -Description "All nescessary inbound ports for SCCM instance" `
-Profile Domain -Direction Inbound -LocalPort "135","1433","4022" -Enabled True -Protocol TCP