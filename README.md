# 1965a44-12fd59f_infra
1965a44-12fd59f Infra repository

##### Text formatting
[Basic writing and formatting syntax](https://help.github.com/en/github/writing-on-github/basic-writing-and-formatting-syntax)  
[Markdown Guide](https://www.markdownguide.org/basic-syntax)



### HOMEWORK 3

One line cmd to get in: `ssh -l <user> -A -J <user>@<public_ip> <internal_host_ip>`  
**OR**  
Configure login cmd `ssh someinternalhost` by editing _~/.ssh/config_:
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

Creating the instance:
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

Creating the firewall rule for service:
```
gcloud compute firewall-rules create default-puma-server \
--direction=INGRESS --action=ALLOW \
--priority=1000 --network=default \
--rules=tcp:9292 --source-ranges=0.0.0.0/0 --target-tags=puma-server
```

Useful subshell from Google with autocompletion: `gcloud beta interactive`

Useful command to look at the console output: `gcloud compute instances get-serial-port-output reddit-app`

If something went wrong with your script check this out: [gCloud Docs](https://cloud.google.com/compute/docs/startupscript#rerunthescript)

After complete the task destroy the instance: `gcloud compute instances delete reddit-app --quiet`

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
_Terraform_

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

**_A problem_**  
When you add an ssh key through the web interface you can't change username correctly thus you get the issue when you try to connect to a host:
```shell
$ ssh appuser-web@34.76.120.103
appuser-web@34.76.120.103: Permission denied (publickey).
```
Another notice is when adding ssh keys using Terraform is in that it overwrites existing keys in the GCP metadata key-chain, and keeps the previous key in its state if it's a separate resource.


**References:**  
<https://cloud.google.com/compute/docs/instances/adding-removing-ssh-keys#project-wide>
<https://stackoverflow.com/questions/38645002/how-to-add-an-ssh-key-to-an-gcp-instance-using-terraform>


**Advanced task 2**  
In gcloud shell we need these 5 steps for creating load balancer:
1. Add a new external address as well as for bastion host:
```
gcloud compute addresses create network-lb-000 \
    --region=europe-west1
```
2. Add a legacy HTTP health check resource
```
gcloud compute http-health-checks create hlth-chck-000 \
    --port=9292
```
3. Add a target pool
```
gcloud compute target-pools create nlb-pool-000 \
    --http-health-check hlth-chck-000
```
4. Add your instances to the target pool
```
gcloud compute target-pools add-instances nlb-pool-000 \
    --instances reddit-app
```
5. Add a forwarding rule
```
gcloud compute forwarding-rules create fwd-rule-000 \
    --region=europe-west1 \
    --ports 9292 \
    --address network-lb-000 \
    --target-pool nlb-pool-000
```
Above, we see the minimum required parameters for creating a load balancer, which will be plenty for leverage in Terraform. Look  through: [terraform/lb.tf](terraform/lb.tf)

To check health status of each node in pool use the command: `gcloud compute target-pools get-health nlb-pool-000`

**_A problem_**  
Each node in the HA pool works as a standalone service without any relationship with each other. Both nodes have own databases. There is no necessity to stop any of them the problem lies in the fact that we have a split-brain hence we give a different states of our app to internet users.


**References:**  
_GCP documets_:  
<https://cloud.google.com/load-balancing/docs>  
<https://cloud.google.com/load-balancing/docs/network>  
<https://cloud.google.com/load-balancing/docs/network/setting-up-network>  
<https://cloud.google.com/load-balancing/docs/target-pools>  

_Terraform documets_:  
<https://www.terraform.io/docs/index.html>  
<https://www.terraform.io/docs/providers/google/r/compute_forwarding_rule.html>  
<https://www.terraform.io/docs/providers/google/r/compute_target_pool.html>  
<https://www.terraform.io/docs/providers/google/r/compute_http_health_check.html>  
<https://www.terraform.io/docs/providers/google/r/compute_address.html>  
<https://www.terraform.io/docs/providers/google/r/compute_instance.html>  
<https://www.terraform.io/docs/providers/google/r/compute_instance.html#self_link>  

<https://www.terraform.io/docs/configuration/resources.html#count-multiple-resource-instances-by-count>  
<https://www.terraform.io/docs/configuration/expressions.html#references-to-resource-attributes>  
<https://www.terraform.io/docs/configuration/expressions.html#for-expressions>  
<https://www.terraform.io/docs/configuration/expressions.html#splat-expressions>  

_Terraform provider GCP source code_:  
<https://github.com/terraform-providers/terraform-provider-google>  

_Terraform NLB example config_:  
<https://github.com/gruntwork-io/terraform-google-load-balancer/tree/master/modules/network-load-balancer>

_Other_:  
<https://stackoverflow.com/questions/58810902/azure-terraform-reports-missing-resource-instance-key>  



### HOMEWORK 7
_Terraform_

A little hint to show a summary for terraform execution plan:

    echo "alias tfplan='terraform plan | grep \"# google\|# module\|Plan:\"'" >> ~/.bash_aliases

Customize the `diff` command:

    echo "alias diff='diff --color -u'" >> ~/.bash_aliases


**References:**  
_Terraform docs_:  
<https://www.terraform.io/docs/configuration/resources.html>  
<https://www.terraform.io/docs/configuration/resources.html#depends_on-explicit-resource-dependencies>  
<https://www.terraform.io/docs/modules/sources.html>  
