**Посмотреть версию и информацию об окружении Ansible**

    ansible --version

**Общий вид команды**

    ansible <group|host> -m <module> -a <arg>

**View variables discovered from systems: Facts**

    ansible <host> -m setup

**Выполнение команды на удалённом сервере: по имени сервера в inventory, по имени группы, на всех с указанием файла inventory, на всех из настроек по-умолчанию** 

    ansible dbserver -m command -a uptime
    ansible app -m command -a uptime

    ansible all -i inventory.yml -m ping
    ansible all -m ping

**Получить информацию о версии ПО. Модули command и shell имеют различия**

    ansible app -m command -a 'ruby -v'
    ansible app -m command -a 'bundler -v'
    ansible app -m command -a 'ruby -v; bundler -v'
    ansible app -m shell -a 'ruby -v; bundler -v'

**Получить информацию о статусе сервиса, с помощью shell, command и специальных модулях systemd, service**

    ansible db -m shell -a 'systemctl status mongod'
    ansible db -m command -a 'systemctl status mongod'
    ansible db -m systemd -a name=mongod
    ansible db -m service -a name=mongod

**Использование Git на удалённом сервере**

    ansible app -m git -a 'repo=https://github.com/express42/reddit.git dest=/home/appuser/reddit'
    ansible app -m command -a 'git clone https://github.com/express42/reddit.git /home/appuser/reddit'

**Вызов плейбука**

    ansible-playbook clone.yml
    ansible app -m command -a 'rm -rf ~/reddit'

**View the list of available plugins.**

    ansible-doc -t inventory -l
    
**View plugin-specific documentation and examples.**

    ansible-doc -t inventory <plugin name>
    ansible-doc -t inventory gcp_compute > gcp_compute_doc.txt

**Display the configured inventory as Ansible sees it**

    ansible-inventory -i gcp.yml --graph

**dump the configured inventory to file with JSON or YAML format**

    ansible-inventory -i gcp.yml --list --output inventory.json
    ansible-inventory -i gcp.yml --list --yaml --output inventory.yaml

**Syntax check**

    ansible-playbook --syntax-check reddit-app.yml

**Dry run плейбука**

    ansible-playbook --check reddit-app.yml --limit db

**Running playbook within a scope of a single host or a group of hosts**

    ansible-playbook reddit-app.yml --limit db

**Various options of ansible-playbook**

--limit _<grpup|host>_  
--diff –-check  
--inventory _<file>_  
--list-tags  
--tags _tagA_\[,_tagB,tagC_\]  
--skip-tags _tagA_\[,_tagB,tagC_\]  
--list-hosts  
--list-tasks  
--start-at-task _<task_name>_  
--force-handlers

    ansible-playbook -t debug --check reddit-app.yml
    ansible-playbook -t db,debug --check --diff reddit-app.yml
    ansible-playbook  --list-tags reddit-app.yml
    ansible-playbook  --list-hosts reddit-app.yml
    ansible-playbook  --list-tasks reddit-app.yml
    ansible-playbook --list-hosts --list-tags --list-tasks reddit-app.yml
    ansible-playbook --force-handlers app.yml