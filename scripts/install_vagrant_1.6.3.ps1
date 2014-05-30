$msi = "c:\vagrant\resources\vagrant_1.6.3.msi"

if (!(Test-Path $msi)) {
  Write-Host "Downloading Vagrant_1.6.3"
  $url = "https://dl.bintray.com/mitchellh/vagrant/vagrant_1.6.3.msi"
  (New-Object Net.WebClient).DownloadFile($url, $msi)
}

Write-Host "Installing Vagrant_1.6.3"
$log = "c:\vagrant\resources\vagrant_1.6.3.log"
Start-Process -FilePath msiexec -ArgumentList /i, $msi, /quiet, /L*V, $log -Wait

Write-Host "Done with Vagrant_1.6.3"
