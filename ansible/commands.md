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
