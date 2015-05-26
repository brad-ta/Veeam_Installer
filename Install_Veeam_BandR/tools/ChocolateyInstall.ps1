    choco install -y vcredist2010 
    choco install -y sql2012.clrtypes
    choco install -y sql2012.smo
    choco install -y mssqlserver2012express

    # Installing Veeam
	if ($true) {
		#Add test to make sure directory doesn't exist
		mkdir c:\veeam
		mkdir c:\veeam\install-logs
		cd c:\veeam
	 
		$wc = New-Object net.webclient
		$wc.Downloadfile("http://172.21.23.241/sw/veeam/VeeamAvailabilitySuite.8.0.0.11.iso", "c:\veeam\VeeamAvailabilitySuite.8.0.0.11.iso")
		$wc.Downloadfile("http://172.21.23.241/sw/veeam/VeeamBackup&Replication_8.0.0.2021_Update2.zip", "c:\veeam\VeeamBackup&Replication_8.0.0.2021_Update2.zip")
		$wc.Downloadfile("http://172.21.23.241/sw/veeam/VeeamONE_8.0.0.1669_Update2.zip", "c:\veeam\VeeamONE_8.0.0.1669_Update2.zip")
	 
		& 'C:\Program Files\7-Zip\7z.exe' x -y -oc:\veeam\VeeamAvailabilitySuite.8.0.0.11 c:\veeam\VeeamAvailabilitySuite.8.0.0.11.iso
		& 'C:\Program Files\7-Zip\7z.exe' x -y '-oc:\veeam\VeeamBackup&Replication_8.0.0.2021_Update2' 'c:\veeam\VeeamBackup&Replication_8.0.0.2021_Update2.zip'
		& 'C:\Program Files\7-Zip\7z.exe' x -y -oc:\veeam\VeeamONE_8.0.0.1669_Update2 c:\veeam\VeeamONE_8.0.0.1669_Update2.zip
	 
		# Remove the ISO file once it's been expanded
		del c:\veeam\VeeamAvailabilitySuite.8.0.0.11.iso
		del 'c:\veeam\VeeamBackup&Replication_8.0.0.2021_Update2.zip'
		del c:\veeam\VeeamONE_8.0.0.1669_Update2.zip
	}
 
	# Install Veeam 8.0
	# Reference: http://helpcenter.veeam.com/backup/80/vsphere/index.html
 
	if ($true) {
		#Install Veeam Backup Catalog
		# Reference: http://helpcenter.veeam.com/backup/80/vsphere/silent_install_catalog.html
	
		Write-Host "Installing Veeam Backup Catalog."
		Start-Process -FilePath msiexec.exe -Wait -ArgumentList `
		    /L*v, "c:\veeam\install-logs\01-CatalogSetupLog.txt", `
		    /qn, /i, "c:\veeam\VeeamAvailabilitySuite.8.0.0.11\Catalog\VeeamBackupCatalog64.msi", `
			VBRC_SERVICE_USER="WINDOWSNODE\Administrator",
			VBRC_SERVICE_PASSWORD="TechAccel1!"

        <#
        # Direct command-line call
		msiexec.exe /L*v "c:\veeam\install-logs\01-CatalogSetupLog.txt" /qn /i `
			"c:\veeam\VeeamAvailabilitySuite.8.0.0.11\Catalog\VeeamBackupCatalog64.msi" `
			VBRC_SERVICE_USER="WINDOWSNODE\Administrator" VBRC_SERVICE_PASSWORD="TechAccel1!"
		#>
	}
 
	if ($true) {
		#Install Veeam Backup & Replication
		# Reference: http://helpcenter.veeam.com/backup/80/vsphere/silent_install_vbr.html
	
		Write-Host "Installing Veeam Backup & Replication."
		Start-Process -FilePath msiexec.exe -Wait -ArgumentList `
            /L*v, "c:\veeam\install-logs\02-BackupSetupLog.txt", `
            /qn, /i, "c:\veeam\VeeamAvailabilitySuite.8.0.0.11\Backup\BU_x64.msi", `
			VBR_SQLSERVER_SERVER="WINDOWSNODE\SQLEXPRESS", `
			VBR_SQLSERVER_DATABASE="VeeamBackup", `
			ACCEPTEULA="YES", `
			VBR_SERVICE_USER="WINDOWSNODE\Administrator", `
			VBR_SERVICE_PASSWORD="TechAccel1!", `
			VBR_AUTO_UPGRADE="YES"
		
		<#
        # Direct command-line call
		msiexec.exe /L*v "c:\veeam\install-logs\02-BackupSetupLog.txt" /qn /i `
			"c:\veeam\VeeamAvailabilitySuite.8.0.0.11\Backup\BU_x64.msi" `
			VBR_SQLSERVER_SERVER="WINDOWSNODE\SQLEXPRESS" `
			VBR_SQLSERVER_DATABASE="VeeamBackup" `
			ACCEPTEULA="YES" VBR_SERVICE_USER="administrator" VBR_SERVICE_PASSWORD="TechAccel1!" VBR_AUTO_UPGRADE="YES"
        #>
	}
 
	if ($true) {
		#Install Veeam Explorer for Microsoft Active Directory
		# Reference: http://helpcenter.veeam.com/backup/80/vsphere/silent_install_vead.html
	
		Write-Host "Installing Veeam Explorer for Microsoft Active Directory."
		Start-Process -FilePath msiexec.exe -Wait -ArgumentList `
            /L*v, "c:\veeam\install-logs\03-ExplorerADSetupLog.txt", `
            /qn, /i, "c:\veeam\VeeamAvailabilitySuite.8.0.0.11\Explorers\VeeamExplorerForActiveDirectory.msi"

        <#
        # Direct command-line call
		msiexec.exe /L*v "c:\veeam\install-logs\03-ExplorerADSetupLog.txt" /qn /i `
			"c:\veeam\VeeamAvailabilitySuite.8.0.0.11\Explorers\VeeamExplorerForActiveDirectory.msi"
	    #>
	}
 
	if ($true) {
		#Install Veeam Powershell Snap-In
		# This Snap-in is needed in order to automate configuration of Veeam and Execute policies on the PS command line
		# Reference: http://helpcenter.veeam.com/backup/80/vsphere/silent_install_powershell.html
	
		Write-Host "Installing Veeam Powershell Snap-In."
		Start-Process -FilePath msiexec.exe -Wait -ArgumentList `
            /L*v, "c:\veeam\install-logs\04-PowershellSetupLog.txt", `
            /qn, /i, "c:\veeam\VeeamAvailabilitySuite.8.0.0.11\Backup\BPS_x64.msi"
        
        <#
        # Direct command-line call
		msiexec.exe /L*v "c:\veeam\install-logs\04-PowershellSetupLog.txt" /qn /i `
			"c:\veeam\VeeamAvailabilitySuite.8.0.0.11\Backup\BPS_x64.msi"
	    #>
	}
 
	if ($true) {
		#Install Veeam 8 Update 2
		
		Write-Host "Installing B&R Update #2."
		Start-Process -FilePath `
		    "c:\veeam\VeeamBackup&Replication_8.0.0.2021_Update2\VeeamBackup&Replication_8.0.0.2021_Update2.exe" `
		    -Wait -ArgumentList `
		    /q, /c, /t:c:\veeam\temp_update_2
		
		<#
		#start /wait 'c:\veeam\VeeamBackup&Replication_8.0.0.2021_Update2\VeeamBackup&Replication_8.0.0.2021_Update2.exe' /q /c /t:c:\veeam\update2
		#start /wait 'c:\veeam\update2\HotFixRunner.exe' silent noreboot log c:\veeam\install-logs\05-update2.log VBR_AUTO_UPGRADE=1
		#>
	}
	
	Write-Host "Finished."
