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
