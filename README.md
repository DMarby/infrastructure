# Infrastructure
This repository contains ansible playbooks and packer configuration managing the infrastructure in my homelab

### Running packer
#### Installation (OS X)
To run packer you need to install packer and ansible. You can do so using brew by running:

```brew install packer ansible```

You also need VMWare OVFTool, get it from [here](https://www.vmware.com/support/developer/ovf/)
Then add it to the path:

```ln -s /Applications/VMware\ OVF\ Tool/ovftool /usr/local/bin/ovftool```

Packer will be directly against the ESXI host, this requires that it has SSH enabled.
It also requires the "GuestIPHack" to be enabled, to enable it via SSH, run:

```ssh <username>@<host> 'esxcli system settings advanced set -o /Net/GuestIPHack -i 1'```

You also need to open a range of ports to allow packer to connect to the VM using VNC:

```
ssh <username>@<host> '\
chmod 644 /etc/vmware/firewall/service.xml && \
chmod +t /etc/vmware/firewall/service.xml && \
sed -i '"'"'$i<service id="1000"> \
<id>packer-vnc</id> \
<rule id="0000"> \
  <direction>inbound</direction> \
  <protocol>tcp</protocol> \
  <porttype>dst</porttype> \
  <port> \
    <begin>5900</begin> \
    <end>6000</end> \
  </port> \
</rule> \
<enabled>true</enabled> \
<required>true</required> \
</service>'"'"' /etc/vmware/firewall/service.xml && \
chmod 444 /etc/vmware/firewall/service.xml && \
esxcli network firewall refresh'
```

#### Usage
To build a vm template using packer, run `./run-packer <name-of-template> (e.g. ubuntu)`

#### Testing ansible for packer in vagrant
In order to speed up testing the ansible scripts, you can run them against a local VM with vagrant and virtualbox.
This requires [virtualbox](https://www.virtualbox.org/) and [vagrant](https://www.vagrantup.com/) to be installed.
Run `./test-packer <name-of-template> (e.g. ubuntu)`

### Running ansible
#### Installation (OS X)
To install ansible using brew, run:

```brew install ansible```

# vCenter/vSphere
To communicate with vCenter/vSphere, ansible needs some additional python modules. To install them, run:

```pip install pyvmomi pexpect```

# OVA/OVF
In order to deploy OVA/OVFs (required for VyOS) you'll need install `govc` and add it to your path, releases can be found [here](https://github.com/vmware/govmomi/tree/master/govc).

# VCSA
To deploy VCSA, you'll need to download the VCSA .iso, extract it, and specify the path to it in `private_vars.json`.

#### Usage
To create a new vm and run ansible against it, run `./run-ansible <name-of-app>`
