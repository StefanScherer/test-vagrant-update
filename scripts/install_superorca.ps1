
$exe = "c:\vagrant\resources\SuperOrcaSetup.exe"

if (!(Test-Path $exe)) {
  Write-Host "Downloading SuperOrca 11.0.0.1"
  $url = "http://www.pantaray.com/SuperOrcaSetup.exe"
  (New-Object Net.WebClient).DownloadFile($url, $exe)
}

Write-Host "Installing SuperOrca 11.0.0.1"
Start-Process -FilePath $exe /silent

Write-Host "Done with SuperOrca 11.0.0.1"
