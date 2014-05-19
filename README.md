# test-vagrant-update

This repo is for testing a vagrant update 1.5.3 -> 1.6.2 as there seems to be an issue 
with a missing `bsdtar.exe` after the update. See [Vagrant Issue 3674](https://github.com/mitchellh/vagrant/issues/3674) for details.

## Requirements

You will need the following tools on your host machine:

* Vagrant 1.6.2 
* VirtualBox 4.3.10

## Build the box

Guess what?

```
vagrant up
```

Will download a windows 7 box, starts it up, downloads and installs Vagrant 1.5.2 and afterwards downloads and install Vagrant 1.6.3.

## Faster provisioning

The box uses the directory `resources` to cache the download and also writes the msiexec install logs there.

So you can pre-feed the box with the downloaded msi files. Also after a

```
vagrant destroy -f
vagrant up
```

the box will provision faster with the already downloaded files in the `c:\vagrant\resources` directory shared from the host.

The results in the `resources` directory looks like this:

```
$ ls -1 resources/
vagrant_1.5.3.log
vagrant_1.5.3.msi
vagrant_1.6.2.log
vagrant_1.6.2.msi
```
## Test results

My current output of a `vagrant pristine -f` call looks like this:

```
$ vagrant pristine -f
==> default: Forcing shutdown of VM...
==> default: Destroying VM and associated drives...
==> default: Running cleanup tasks for 'shell' provisioner...
==> default: Running cleanup tasks for 'shell' provisioner...
==> default: Running cleanup tasks for 'shell' provisioner...
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'ferventcoder/win7pro-x64-nocm-lite'...
==> default: Matching MAC address for NAT networking...
==> default: Checking if box 'ferventcoder/win7pro-x64-nocm-lite' is up to date...
==> default: Setting the name of the VM: test-vagrant-update_default_1400538711191_52833
==> default: Clearing any previously set forwarded ports...
==> default: Fixed port collision for 5985 => 55985. Now on port 2200.
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
==> default: Forwarding ports...
    default: 5985 => 2200 (adapter 1)
==> default: Running 'pre-boot' VM customizations...
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
==> default: Machine booted and ready!
==> default: Checking for guest additions in VM...
    default: The guest additions on this VM do not match the installed version of
    default: VirtualBox! In most cases this is fine, but in rare cases it can
    default: prevent things such as shared folders from working properly. If you see
    default: shared folder errors, please make sure the guest additions within the
    default: virtual machine match the version of VirtualBox you have installed on
    default: your host and reload your VM.
    default: 
    default: Guest Additions Version: 4.2.16
    default: VirtualBox Version: 4.3
==> default: Setting hostname...
==> default: Mounting shared folders...
    default: /vagrant => /Users/stefan/code/test-vagrant-update
==> default: Running provisioner: shell...
    default: Running: c:\tmp\vagrant-shell.ps1
==> default: Installing Vagrant 1.5.3
==> default: Done with Vagrant 1.5.3
==> default: Running provisioner: shell...
    default: Running: c:\tmp\vagrant-shell.ps1
==> default: Installing Vagrant_1.6.2
==> default: Done with Vagrant_1.6.2
==> default: Running provisioner: shell...
    default: Running: c:\tmp\vagrant-shell.ps1
==> default: FAIL - bsdtar.exe NOT found.
==> default: Listing all files in c:\hashicorp\vagrant\embedded\gnuwin32\bin
==> default: libarchive.dll
```

As you can see the `FAIL - bastar.exe NOT found.` error, the file is really missing after the update.

## First msi log file analysis

These are the log files of the msiexec regarding `bsdtar.exe`.


### vagrant_1.5.3.log

```
MSI (s) (78:98) [22:33:04:691]: Executing op: ComponentRegister(ComponentId={6C6CEB7D-6C95-4347-92AD-4627CEBEEFD2},KeyPath=c:\HashiCorp\Vagrant\embedded\gnuwin32\bin\bsdtar.exe,State=3,,Disk=1,SharedDllRefCount=0,BinaryType=0)
MSI (s) (78:98) [22:33:06:105]: Executing op: ComponentRegister(ComponentId={81A2C8B9-6274-40B6-BC8B-61C8C2796AC0},KeyPath=c:\HashiCorp\Vagrant\embedded\mingw\bin\bsdtar.exe,State=3,,Disk=1,SharedDllRefCount=0,BinaryType=0)
MSI (s) (78:98) [22:33:12:637]: Executing op: FileCopy(SourceName=bsdtar.exe,SourceCabKey=fil5493118014D2CE8ABC10574179771328,DestName=bsdtar.exe,Attributes=512,FileSize=75264,PerTick=65536,,VerifyMedia=1,,,,,CheckCRC=0,Version=2.4.12.3100,Language=1033,InstallMode=58982400,,,,,,,)
MSI (s) (78:98) [22:33:12:637]: File: c:\HashiCorp\Vagrant\embedded\gnuwin32\bin\bsdtar.exe;    To be installed;    Won't patch;    No existing file
MSI (s) (78:98) [22:33:15:339]: Executing op: FileCopy(SourceName=bsdtar.exe,SourceCabKey=fil7D70791D735CDCBD1A12E5DCBCD11800,DestName=bsdtar.exe,Attributes=512,FileSize=73728,PerTick=65536,,VerifyMedia=1,,,,,CheckCRC=0,,,InstallMode=58982400,HashOptions=0,HashPart1=-728757211,HashPart2=717283750,HashPart3=642632498,HashPart4=1953887051,,)
MSI (s) (78:98) [22:33:15:339]: File: c:\HashiCorp\Vagrant\embedded\mingw\bin\bsdtar.exe;   To be installed;    Won't patch;    No existing file
```

### vagrant_1.6.2.log

```
MSI (s) (78:F8) [22:34:05:944]: Executing op: FileRemove(,FileName=bsdtar.exe,,ComponentId={6C6CEB7D-6C95-4347-92AD-4627CEBEEFD2})
MSI (s) (78:F8) [22:34:05:944]: Verifying accessibility of file: bsdtar.exe
MSI (s) (78:F8) [22:34:10:403]: Executing op: FileRemove(,FileName=bsdtar.exe,,ComponentId={81A2C8B9-6274-40B6-BC8B-61C8C2796AC0})
MSI (s) (78:F8) [22:34:10:403]: Verifying accessibility of file: bsdtar.exe
MSI (s) (78:78) [22:34:21:167]: Executing op: ComponentRegister(ComponentId={57FD6298-3821-4E4A-AF50-4DFF89B48142},KeyPath=c:\HashiCorp\Vagrant\embedded\gnuwin32\bin\bsdtar.exe,State=3,,Disk=1,SharedDllRefCount=2,BinaryType=0)
MSI (s) (78:78) [22:34:23:303]: Executing op: ComponentRegister(ComponentId={5EE49329-5C55-48FF-AA92-A26F99F038DB},KeyPath=c:\HashiCorp\Vagrant\embedded\mingw\bin\bsdtar.exe,State=3,,Disk=1,SharedDllRefCount=2,BinaryType=0)
MSI (s) (78:78) [22:34:35:235]: Executing op: FileCopy(SourceName=bsdtar.exe,SourceCabKey=fil7D70791D735CDCBD1A12E5DCBCD11800,DestName=bsdtar.exe,Attributes=512,FileSize=73728,PerTick=65536,,VerifyMedia=1,,,,,CheckCRC=0,,,InstallMode=58982400,HashOptions=0,HashPart1=-728757211,HashPart2=717283750,HashPart3=642632498,HashPart4=1953887051,,)
MSI (s) (78:78) [22:34:35:235]: File: c:\HashiCorp\Vagrant\embedded\mingw\bin\bsdtar.exe;   To be installed;    Won't patch;    No existing file
https://github.com/StefanScherer/test-vagrant-update
```

In the update, only the bsdtar.exe in the mingw directory will be installed, but not in gnuwin32.
The old files with old ComponentId's will be removed.

## Acknowledgement

Thanks to @mitchellh for Vagrant and the vagrantcloud!
Thanks to @ferventcoder for the win7 test box, and of course for Chocolatey!

Only with you this repo is possible. Sharing an update problem in a windows box to everyone in the world is possible, I haven't dreamed that this really works. 
No more 'works on my machine' - even in these tricky situation. Testing vagrant update with vagrant. 

## Copyright
Copyright (c) 2014 Stefan Scherer

MIT License, see LICENSE for more details.

