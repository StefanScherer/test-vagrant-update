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

## Acknowledgement

Thanks to @mitchellh for Vagrant and the vagrantcloud!
Thanks to @ferventcoder for the win7 test box, and of course for Chocolatey!

Only with you this repo is possible. Sharing an update problem in a windows box to everyone in the world is possible, I haven't dreamed that this really works. 
No more 'works on my machine' - even in these tricky situation. Testing vagrant update with vagrant. 

## Copyright
Copyright (c) 2014 Stefan Scherer

MIT License, see LICENSE for more details.

