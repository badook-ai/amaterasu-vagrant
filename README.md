
# Amaterasu Dev Machine Vagrant Setup

This repository contains the vagrentfile and provisioning script for creating an Amaterasu dev machine.

## prerequisites

Before you create a dev machine, make sure you have the Ametarasu source code, to do so, simply clone the Amaterasu git repo:

```
git clone https://github.com/shintoio/amaterasu.git
``` 

**Note:** the vagrentfile assumes you have cloned the repository in the  *~/Shinto* directory. If you have cloned the repository to a different path, please edit the following line before continue the installation  to point to the correct path:

```
config.vm.synced_folder "~/Shinto/amaterasu/build/amaterasu", "/ama"
```

## Installation

Clone this repository to your local machine:

```
git clone https://github.com/shintoio/amaterasu-vagrant.git
``` 
Change the directory to amaterasu-vagrant and start the machine:

```
cd amaterasu-vagrant
vagrant up
```

Ssh to the vagrant machine:

```
vagrant ssh
```
