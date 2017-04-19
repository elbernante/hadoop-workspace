# hadoop-workspace
Hadoop 2.8.0 installed in Ubuntu 16.04 Xenial 64-bit. The Hadoop is configured in Pseudo-Distributed mode.

### System Requirements
- [Vagrant 1.9](https://www.vagrantup.com/downloads.html)
- [VirtualBox 5.1](https://www.virtualbox.org/wiki/Downloads)

### Setting Up
Clone `hadoop-workspace` repository from https://github.com/elbernante/hadoop-workspace by issuing the following the command line:

```
git clone https://github.com/elbernante/hadoop-workspace.git
```

Go to the root directory of the cloned repo and fire up vagrant:

```
cd hadoop-workspace
vagrant up
```

Running `vagrant up` for the first time may take a while. It will download all the necessary setup files including Hadoop 2.8.0 distribution package (≈430MB). Subsequent `vagrant up` commands will be significantly faster.

SSH to the virtual machine by issuing the command:

```
vagrant ssh
```

You are now connected to an Ubuntu 16.04 machine with Hadoop 2.8.0 running in psuedo-distributed mode.
