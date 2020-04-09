# 1965a44-12fd59f_infra
1965a44-12fd59f Infra repository

[Basic writing and formatting syntax](https://help.github.com/en/github/writing-on-github/basic-writing-and-formatting-syntax)

### HOMEWORK 3

One line cmd to get in: `ssh -l <user> -A -J <user>@<public_ip> <internal_host_ip>`

**OR**

Configure login cmd `ssh someinternalhost` by editing *~/.ssh/config*

```
Host bastion
 User <user>
 IndentityFile ~/.ssh/<secret_key_file>
 HostName <public_ip>

Host someinternalhost
 User <user>
 ProxyJump bastion
 HostName <internal_host_ip>
```

##### Required options
```
bastion_IP = 35.206.156.240
someinternalhost_IP = 10.132.0.4
```

### HOMEWORK 4

**NOTE:** During Travis CI tests your app in your cloud MUST be running

Creating the instance
```
gcloud compute instances create reddit-app\
--boot-disk-size=10GB \
--image-family ubuntu-1604-lts \
--image-project=ubuntu-os-cloud \
--machine-type=g1-small \
--tags puma-server \
--preemptible \
--restart-on-failure \
--metadata-from-file startup-script=install_all.sh
```

Creating the firewall rule for service
```
gcloud compute firewall-rules create default-puma-server \
--direction=INGRESS --action=ALLOW \
--priority=1000 --network=default \
--rules=tcp:9292 --source-ranges=0.0.0.0/0 --target-tags=puma-server
```

Useful subshell from Google with autocompletion
`gcloud beta interactive`

Useful command to look at the console output
`gcloud compute instances get-serial-port-output reddit-app`

If something went wrong with your script check this out
[gCloud Docs](https://cloud.google.com/compute/docs/startupscript#rerunthescript)

After complete the task destroy the instance
`gcloud compute instances delete reddit-app --quiet`

##### Required options
```
testapp_IP = 34.76.99.202
testapp_port = 9292
```

### HOMEWORK 5

**Base task**
1. Installed the Packer on the local system [Packer Installation Guide](https://packer.io/intro/getting-started/install.html#precompiled-binaries)
   - To check the version run the `packer -v` command
2. Created ADC for GCP using the `gcloud auth application-default login` command
3. Created the template for building a "Fry" image [ubuntu16.json](packer/ubuntu16.json)
4. The reddit-base image has built on GCP with `packer build -var-file=variables.json ubuntu16.json` command

**Advanced task**
1. Created the template for building a "Bake" image [immutable.json](packer/immutable.json)
2. Created the systemd unit file [reddit.service](packer/files/reddit.service)
3. Prepared script for auto app deployment [deploy.sh](packer/scripts/deploy.sh)
4. The reddit-full image has built on GCP using the `packer build -var-file=variables.json immutable.json` command
5. Created the script to run a VM instance [create-reddit-vm.sh](config-scripts/create-reddit-vm.sh)


### HOMEWORK 6
#### Terraform

**Advanced task 1**

After adding ssh keys with Terraform from [metadata.tf](terraform/metadata.tf):
```bash
appuser@reddit-app:~$ getent passwd |grep appuser
appuser:x:1001:1002::/home/appuser:/bin/bash
appuser1:x:1002:1003::/home/appuser1:/bin/bash
appuser2:x:1003:1004::/home/appuser2:/bin/bash
appuser3:x:1004:1005::/home/appuser3:/bin/bash

$ ssh appuser1@34.76.120.103
appuser1@reddit-app:~$ whoami
appuser1
appuser1@reddit-app:~$

$ ssh appuser2@34.76.120.103
appuser2@reddit-app:~$ whoami
appuser2
appuser2@reddit-app:~$

$ ssh appuser3@34.76.120.103
appuser3@reddit-app:~$ whoami
appuser3
appuser3@reddit-app:~$
```
For some reasons you probably won't want to use project-wide public keys on certain VMs to accomplish this objective add configuration to VM from the guide below:

https://cloud.google.com/compute/docs/instances/adding-removing-ssh-keys?hl=en_GB#block-project-keys

_*A problem 1*_

When you add an ssh key through the web interface you can't change username correctly thus you get the issue when you try to connect to a host:
```shell
$ ssh appuser-web@34.76.120.103
appuser-web@34.76.120.103: Permission denied (publickey).
```
Another notice is when adding ssh keys using Terraform is in that it overwrites existing keys in the GCP metadata key-chain, and keeps the previous key in its state if it's a separate resource.
