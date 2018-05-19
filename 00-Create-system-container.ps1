<#
    .NOTES
    --------------------------------------------------------------------------------
    Code generated by:  Hands
    Generated on:       13/05/2018
    Generated by:       Guillaume Mateos
    Organization:       SHell Networks
    --------------------------------------------------------------------------------
    .SYNOPSIS
    Use this script to create the system management container in the AD schema
    .DESCRIPTION
    1 - Creation of the container
    2 - Attributing rights on the container for the choosen server group (they should be site server)  
#>

#region Modules
Import-Module ActiveDirectory
#endregion

#region Variables
$DomainDN = (Get-ADDomain).DistinguishedName
$SiteServerGroup = "GG-SHN-SCCM-SiteServers"

#endregion

#region Functions
function Set-SystemManagementContainer
{   
     <#
        .SYNOPSIS
        Use this to create system management container
        .DESCRIPTION
        Create the system management container, and give to the server in parameter full rights on this container
        .PARAMETER ServerName
        Nqme of the server that should have rights on the system management container
        .PARAMETER DistinguishedName
        This is the DN of your domain
        .EXAMPLE
        Set-SystemManagementContainer -ServerName SHNPRODSCM01 -DistinguishedName "DC=shell-networks,DC=local"
    #>
    [Cmdletbinding()]
    Param (
    [Parameter(Mandatory = $True,Position = 0)]
    [String]
    $ServerGroupName,
    [Parameter(Mandatory = $True,Position = 1)]
    [String]
    $DistinguishedName
    )   
    
    $SystemDN = "CN=System,$DistinguishedName"
    $Container = "CN=System Management,$($SystemDN)" #Path for the container to create

    $Find = $True
    try #We search for the container within the active directory
    {
        Get-ADObject $Container
    }
    catch 
    {
        Write-Host -ForegroundColor Yellow "System Management Container does not exist"
        $Find = $false
    }

    if(!($Find))#If the container does not already exist
    {
        Write-Host -ForegroundColor Cyan "Creating System Management Container"

        $Create = $True
        try 
        {
            New-ADObject -Type Container -Name $Container.substring(3,17) -Path $SystemDN -PassThru
        }
        catch 
        {
            $Create = $false
        }

        if($Create)
        {
            Write-Host -ForegroundColor Green "System Management Container created"

            $ContainerACL = Get-Acl -Path "AD:\$($Container)" #Now we are going to give good acl on this container

            write-host -ForegroundColor Cyan "Querying SID for SCCM Server Group"
            try 
            {
                $ServerGroupSid = (Get-ADGroup -Identity $ServerGroupName).SID #Query of the SID for the SCCM Server
            }
            catch 
            {
                Write-Host -ForegroundColor Red "Error querying SCCM Server in AD"
                exit
            }

            # Create a new access control entry for the System Management container -  FULL CONTROL FOR THE SCCM SITE SERVER
            $AdRights = [System.DirectoryServices.ActiveDirectoryRights] "GenericAll"
            $Type = [System.Security.AccessControl.AccessControlType] "Allow"
            $InheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance] "All"
            $ACE = New-Object System.DirectoryServices.ActiveDirectoryAccessRule $ServerGroupSid,$AdRights,$Type,$InheritanceType

            $ContainerACL.AddAccessRule($ACE) #Here we add our now entry to the ACL of the container
            
            Write-Host -ForegroundColor Cyan "Commiting ACL on the System Management Container"

            $Commit = $True
            try 
            {
                Set-ACL -AclObject $ContainerACL -Path "AD:\$Container"  # Commit the new rule on the container
            }
            catch 
            {
                Write-Host -ForegroundColor Red "Error commiting the ACL for the server group $($ServerGroupName)"
                $Commit = $False
            }
            
            if($Commit)
            {
                Write-Host -ForegroundColor Green "Container and ACL OK - Schema modification Prerequisites Done for SCCM"
            }
        }
        else 
        {
            Write-Host -ForegroundColor Red "Error creating system management container"
        }
    }
    else 
    {
        Write-Host -ForegroundColor Green "The System Management Container already exists !"
    }
}
#endregion

#region Script

Set-SystemManagementContainer -ServerGroupName $SiteServerGroup -DistinguishedName $DomainDN

#endregion