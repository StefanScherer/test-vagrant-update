Write-Host "Testing vagrant box add"
Start-Process -NoNewWindow -FilePath c:\hashicorp\vagrant\bin\vagrant.exe -ArgumentList box, add, dummy, https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box -Wait
