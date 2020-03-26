# 1965a44-12fd59f_infra
1965a44-12fd59f Infra repository

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
