# SCCM-Scripts
A bunch of usefull scripts for SCCM installation. 
It has to be done step by step to perform a SCCM install for a standalone primary site, with a database hosted on another server.

- 00-Create-SCCM-users-and-groups

Creation of usefull users and groups that SCCM will need

- 01-Create-system-container

Update the AD schema by creating System Management Container for SCCM and giving rights to site server

- 02-No-SMS-on-Drives

Creation of no_sms_on_drive.sms file on drives you dont want SCCM to install files

- 03-Install-WIndowsFeatures-on-SCCM-Server

Installation of all needed WIndows features on SCCM Site Server

- 04-Install-ADK-and-ReportViewer-on-SCCM-Site-Server

Installation of ADK and reportviewer with good options

- 05-Install-SQL-on-independant-server

Install SQL on a different server than the SCCM server.

- 05-SQL-ConfigurationFile

Config file for SQL installation

- 06-SCCM-Site-server-prerequ-cheks

Checks SCCM prerequ before installation

- 07-SCCM-ConfigurationFile

Configuration file for SCCM unattend installation

- 07-SCCM-Site-server-unattend-install

Installation of the SCCM Primary site server