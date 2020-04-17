# 1965a44-12fd59f_infra
1965a44-12fd59f Infra repository

Previous README is here: [README.md](README01.md)

**Text formatting**  
[Basic writing and formatting syntax](https://help.github.com/en/github/writing-on-github/basic-writing-and-formatting-syntax)  
[Markdown Guide](https://www.markdownguide.org/basic-syntax)



### HOMEWORK 8
#### Основы работы с Ansible
Запуск Ansible playbook с уже выполненными задачами не вносит изменений (идемпотентность), как видно по коду ответа **changed=0**, в противном случае код ответа будет не нулевой:

`$ ansible-playbook clone.yml`

**result**:

    # --- (output omitted) ---    
    appserver                  : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

Для динамической инвентаризации объектов в GCE было решено использовать встроенный плагин _gcp\_compute_, так как в _Ansible Documentation_ рекомендуется использовать плагины вместо скриптов:
> We recommend plugins over scripts for dynamic inventory.

В результате подготовлен YAML файл _gcp.yml_ со следующим содержанием:
```yaml
    plugin: gcp_compute
    auth_kind: application
    scopes:
      - 'https://www.googleapis.com/auth/cloud-platform'
      - 'https://www.googleapis.com/auth/compute.readonly'
    cache: yes
    cache_plugin: jsonfile
    cache_timeout: 7200
    cache_connection: "./gcp_inventory"
    cache_prefix: gcp_compute
    projects:
    # поменять на настоящее имя проекта
      - my-project-name
    hostnames:
      - name
    #keyed_groups:
    #  - prefix: ""
    #    key: labels
    groups:
      app: "'app' in name"
      db: "'db' in name"
    filters:
      - name != bastion
      - name != someinternalhost
    compose:
      ansible_host: networkInterfaces[0].accessConfigs[0].natIP
```
При его вызове через утилиту `ansible-inventory` можно получить общее описание инфраструктуры, которую видит _Ansible_:

`$ ansible-inventory -i gcp.yml --graph`

**result**:

    @all:
      |--@app:
      |  |--reddit-app0
      |--@db:
      |  |--reddit-db
      |--@ungrouped:

Проверка:

`$ ansible all -i gcp.yml -m ping`

**result**:

    reddit-db | SUCCESS => {
        "ansible_facts": {
            "discovered_interpreter_python": "/usr/bin/python"
        },
        "changed": false,
        "ping": "pong"
    }
    reddit-app0 | SUCCESS => {
        "ansible_facts": {
            "discovered_interpreter_python": "/usr/bin/python"
        },
        "changed": false,
        "ping": "pong"
    }

Чтобы получить файл с описанием инфраструктуры (_inventory_) в формате JSON, необходимо выполнить следующую команду:

`$ ansible-inventory -i gcp.yml --list --output inventory.json`


##### Inventory from JSON file:
> Ansible's yaml plugin will actually parse a JSON file, and has done so for years.
> It's barely documented but you can see in the parameters section of the yaml plugin docs, .json is listed as a valid extension.
> The JSON format has the same semantics as the YAML format.
> Note: not the same format as the dynamic inventory.  
[Reference](https://stackoverflow.com/questions/48680425/how-to-use-json-file-consisting-of-host-info-as-input-to-ansible-inventory)



#### Guidances:
_Ansible documents_:  
https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html  
https://docs.ansible.com/ansible/latest/user_guide/intro_dynamic_inventory.html#intro-dynamic-inventory  
https://docs.ansible.com/ansible/latest/plugins/inventory.html  
https://docs.ansible.com/ansible/latest/plugins/inventory/gcp_compute.html  
https://docs.ansible.com/ansible/latest/plugins/inventory/yaml.html#parameters  
https://docs.ansible.com/ansible/latest/cli/ansible.html  
https://docs.ansible.com/ansible/latest/cli/ansible-doc.html  
https://docs.ansible.com/ansible/latest/cli/ansible-inventory.html

_Gcloud docs_:  
https://cloud.google.com/iam/docs/understanding-service-accounts  
https://cloud.google.com/compute/docs/reference/rest/v1/instances/aggregatedList

_Local notes_:  
[ansible/commands.md](ansible/commands.md)  
[ansible/gcp_compute_doc.txt](ansible/gcp_compute_doc.txt)
