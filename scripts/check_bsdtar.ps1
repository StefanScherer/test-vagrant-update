$testdir = "c:\hashicorp\vagrant\embedded\gnuwin32\bin"
$bsdtar = $testdir + "\bsdtar.exe"

if (Test-Path $bsdtar) {
  Write-Host -fore green OK - bsdtar.exe found.
} else {
  $host.ui.WriteErrorLine("FAIL - bsdtar.exe NOT found.")
}

Write-Host Listing all files in $testdir
$items = Get-ChildItem -Path c:\hashicorp\vagrant\embedded\gnuwin32\bin
 
foreach ($item in $items) {
  Write-Host $item.Name
}
