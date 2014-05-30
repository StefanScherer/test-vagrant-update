# test-vagrant-update

This repo is for testing a vagrant update 1.5.3 -> 1.6.3 as there seems to be an issue 
with a missing `bsdtar.exe` after the update. See [Vagrant Issue 3674](https://github.com/mitchellh/vagrant/issues/3674) for details.

## Requirements

You will need the following tools on your host machine:

* Vagrant 1.6.2 or higher
* VirtualBox 4.3.10 or higher

## Build the box

Guess what?

```
vagrant up
```

Will download a windows 7 box, starts it up, downloads and installs Vagrant 1.5.2 and afterwards downloads and install Vagrant 1.6.3. It then checks for the bsdtar.exe and calls a `vagrant box add` test command. For further MSI debugging, I install SuperOrca as well.

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
vagrant_1.6.3.log
vagrant_1.6.3.msi
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
==> default: Running cleanup tasks for 'shell' provisioner...
==> default: Running cleanup tasks for 'shell' provisioner...
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'ferventcoder/win7pro-x64-nocm-lite'...
==> default: Matching MAC address for NAT networking...
==> default: Checking if box 'ferventcoder/win7pro-x64-nocm-lite' is up to date...
==> default: Setting the name of the VM: test-vagrant-update_default_1400568387436_54527
==> default: Clearing any previously set forwarded ports...
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
==> default: Forwarding ports...
    default: 5985 => 55985 (adapter 1)
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
==> default: Downloading Vagrant_1.6.3
==> default: Installing Vagrant_1.6.3
==> default: Done with Vagrant_1.6.3
==> default: Running provisioner: shell...
    default: Running: c:\tmp\vagrant-shell.ps1
==> default: Installing SuperOrca 11.0.0.1
==> default: Done with SuperOrca 11.0.0.1
==> default: Running provisioner: shell...
    default: Running: c:\tmp\vagrant-shell.ps1
==> default: FAIL - bsdtar.exe NOT found.
==> default: Listing all files in c:\hashicorp\vagrant\embedded\gnuwin32\bin
==> default: libarchive.dll
==> default: Running provisioner: shell...
    default: Running: c:\tmp\vagrant-shell.ps1
==> default: Testing vagrant box add
==> default: ==> box: Adding box 'dummy' (v0) for provider: 
==> default: 
==> default:     box: Downloading: https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box
==> default:     box: Progress: 0% (Rate: 0/s, Estimated time remaining: --:--:--)
==> default: 
==> default:     box: Progress: 100% (Rate: 133/s, Estimated time remaining: --:--:--)
==> default:     box: Progress: 100% (Rate: 123/s, Estimated time remaining: --:--:--)
==> default:     box: 
==> default: The executable 'bsdtar' Vagrant is trying to run was not
==> default: found in the %PATH% variable. This is an error. Please verify
```

As you can see the `FAIL - bastar.exe NOT found.` error, the file is really missing after the update.
The `vagrant box add` also fails as mentioned in the GitHub Issue.

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

### Update to vagrant_1.6.3.log

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

### Fresh installation of vagrant_1.6.3

Without the install_vagrant_1.5.3.ps1 provisiong script, the msi log shows this:

```
MSI (s) (88:A8) [23:32:15:046]: Executing op: ComponentRegister(ComponentId={57FD6298-3821-4E4A-AF50-4DFF89B48142},KeyPath=c:\HashiCorp\Vagrant\embedded\gnuwin32\bin\bsdtar.exe,State=3,,Disk=1,SharedDllRefCount=0,BinaryType=0)
MSI (s) (88:A8) [23:32:16:765]: Executing op: ComponentRegister(ComponentId={5EE49329-5C55-48FF-AA92-A26F99F038DB},KeyPath=c:\HashiCorp\Vagrant\embedded\mingw\bin\bsdtar.exe,State=3,,Disk=1,SharedDllRefCount=0,BinaryType=0)
MSI (s) (88:A8) [23:32:24:812]: Executing op: FileCopy(SourceName=bsdtar.exe,SourceCabKey=fil5493118014D2CE8ABC10574179771328,DestName=bsdtar.exe,Attributes=512,FileSize=1281328,PerTick=65536,,VerifyMedia=1,,,,,CheckCRC=0,,,InstallMode=58982400,HashOptions=0,HashPart1=-155489478,HashPart2=1289703212,HashPart3=-1719279071,HashPart4=85235568,,)
MSI (s) (88:A8) [23:32:24:812]: File: c:\HashiCorp\Vagrant\embedded\gnuwin32\bin\bsdtar.exe;    To be installed;    Won't patch;    No existing file
MSI (s) (88:A8) [23:32:28:656]: Executing op: FileCopy(SourceName=bsdtar.exe,SourceCabKey=fil7D70791D735CDCBD1A12E5DCBCD11800,DestName=bsdtar.exe,Attributes=512,FileSize=73728,PerTick=65536,,VerifyMedia=1,,,,,CheckCRC=0,,,InstallMode=58982400,HashOptions=0,HashPart1=-728757211,HashPart2=717283750,HashPart3=642632498,HashPart4=1953887051,,)
MSI (s) (88:A8) [23:32:28:656]: File: c:\HashiCorp\Vagrant\embedded\mingw\bin\bsdtar.exe;   To be installed;    Won't patch;    No existing file
```

This is a fresh installation without update. And also the check script shows some files. Here is my complete output of this `vagrant pristine -f` call:

```
$ vagrant pristine -f
==> default: Forcing shutdown of VM...
==> default: Destroying VM and associated drives...
==> default: Running cleanup tasks for 'shell' provisioner...
==> default: Running cleanup tasks for 'shell' provisioner...
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'ferventcoder/win7pro-x64-nocm-lite'...
==> default: Matching MAC address for NAT networking...
==> default: Checking if box 'ferventcoder/win7pro-x64-nocm-lite' is up to date...
==> default: Setting the name of the VM: test-vagrant-update_default_1400542260611_26744
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
==> default: Installing Vagrant_1.6.3
==> default: Done with Vagrant_1.6.3
==> default: Running provisioner: shell...
    default: Running: c:\tmp\vagrant-shell.ps1
==> default: OK - bsdtar.exe found.
==> default: Listing all files in c:\hashicorp\vagrant\embedded\gnuwin32\bin
==> default: bsdcpio.exe
==> default: bsdtar.exe
==> default: libarchive.dll
```

So, bsdtar.exe and bsdcpio.exe are missing after an update. Perhaps other files in other directories as well. Haven't looked deeper into the logs yet.

### Deeper log into update 1.5.3 to vagrant_1.6.3.log

Searching for the ComponentId, I found following lines that shows some Disallow messages for the two files (not other messages found):

```
Action start 22:33:32: CostFinalize.
MSI (s) (78:78) [22:33:32:438]: Note: 1: 2205 2:  3: MsiAssembly 
MSI (s) (78:78) [22:33:32:438]: Note: 1: 2228 2:  3: MsiAssembly 4:  SELECT `MsiAssembly`.`Attributes`, `MsiAssembly`.`File_Application`, `MsiAssembly`.`File_Manifest`,  `Component`.`KeyPath` FROM `MsiAssembly`, `Component` WHERE  `MsiAssembly`.`Component_` = `Component`.`Component` AND `MsiAssembly`.`Component_` = ? 
MSI (s) (78:78) [22:33:36:533]: Disallowing installation of component: {57FD6298-3821-4E4A-AF50-4DFF89B48142} since the same component with higher versioned keyfile exists
MSI (s) (78:78) [22:33:36:533]: Disallowing installation of component: {8C99AA3D-1415-419C-834D-E4B4766EDEBD} since the same component with higher versioned keyfile exists
MSI (s) (78:78) [22:33:37:530]: Doing action: MigrateFeatureStates
MSI (s) (78:78) [22:33:37:530]: Note: 1: 2205 2:  3: ActionText 
Action ended 22:33:37: CostFinalize. Return value 1.
MSI (s) (78:78) [22:33:37:530]: Migrating feature settings from product(s) '{12F15A73-F334-4EA6-8D73-CE23C79A2DA9}'
MSI (s) (78:78) [22:33:37:621]: MigrateFeatureStates: based on existing product, setting feature 'VagrantFeature' to 'Local' state.
Action start 22:33:37: MigrateFeatureStates.
MSI (s) (78:78) [22:33:38:238]: Disallowing installation of component: {8C99AA3D-1415-419C-834D-E4B4766EDEBD} since the same component with higher versioned keyfile exists
MSI (s) (78:78) [22:33:38:238]: Disallowing installation of component: {57FD6298-3821-4E4A-AF50-4DFF89B48142} since the same component with higher versioned keyfile exists
MSI (s) (78:78) [22:33:40:109]: Doing action: InstallValidate
MSI (s) (78:78) [22:33:40:109]: Note: 1: 2205 2:  3: ActionText 
Action ended 22:33:40: MigrateFeatureStates. Return value 1.
```

### Only install 1.5.3

Then I only have installed Vagrant 1.5.3 to see which files are installed and which version has bsdtar.exe

```
==> default: Running provisioner: shell...
    default: Running: c:\tmp\vagrant-shell.ps1
==> default: Installing Vagrant 1.5.3
==> default: Done with Vagrant 1.5.3
==> default: Running provisioner: shell...
    default: Running: c:\tmp\vagrant-shell.ps1
==> default: OK - bsdtar.exe found.
==> default: Listing all files in c:\hashicorp\vagrant\embedded\gnuwin32\bin
==> default: bsdcpio.exe
==> default: bsdtar.exe
==> default: bunzip2.exe
==> default: bzcat.exe
==> default: bzcmp
==> default: bzdiff
==> default: bzegrep
==> default: bzfgrep
==> default: bzgrep
==> default: bzip2.dll
==> default: bzip2.exe
==> default: bzip2recover.exe
==> default: bzless
==> default: bzmore
==> default: libarchive2.dll
==> default: zlib1.dll
```

The version of bsdtar.exe is 2.4.12.3100 from 6/27/2008

### Only install 1.6.3

```
==> default: Running provisioner: shell...
    default: Running: c:\tmp\vagrant-shell.ps1
==> default: Installing Vagrant_1.6.3
==> default: Done with Vagrant_1.6.3
==> default: Running provisioner: shell...
    default: Running: c:\tmp\vagrant-shell.ps1
==> default: OK - bsdtar.exe found.
==> default: Listing all files in c:\hashicorp\vagrant\embedded\gnuwin32\bin
==> default: 
==> default: bsdcpio.exe
==> default: bsdtar.exe
==> default: libarchive.dll
```

It installs less files and the version of bsdtar.exe is not set.


## Acknowledgement

Thanks to @mitchellh for Vagrant and the vagrantcloud!
Thanks to @ferventcoder for the win7 test box, and of course for Chocolatey!

Only with you this repo is possible. Sharing an update problem in a windows box to everyone in the world is possible, I haven't dreamed that this really works. 
No more 'works on my machine' - even in these tricky situation. Testing vagrant update with vagrant. 

## Copyright
Copyright (c) 2014 Stefan Scherer

MIT License, see LICENSE for more details.

