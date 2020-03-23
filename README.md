# 1965a44-12fd59f_infra
1965a44-12fd59f Infra repository

One line cmd to get in: `ssh -l <user> -A -J <user>@<public_ip> <internal_host_ip>`

***OR***

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

```
bastion_IP = 35.206.156.240
someinternalhost_IP = 10.132.0.4
```
