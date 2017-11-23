#!/bin/sh
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
cd "$SCRIPTPATH/../"

if [ $# -lt 1 ]; then
    echo "USAGE : ./purge_db.sh env"
    exit
fi

schemas_file="sql/schemas.sql"
entries_file="sql/entries.sql"

$(python3 scripts/get_yaml.py "config/db.yaml" "$1")
mysql_cmd="-h$server -u$username -p$password"
if [ "$local_database" = "true" ]; then
	bash scripts/purge_db.sh "$1"	
	mysqladmin $mysql_cmd create "$db"
	cat "$schemas_file" | awk '!/^(use|create database|drop database|USE|CREATE DATABASE|DROP DATABASE)/' > buf.sql
        if [ "$1" = "app" ]; then
            cat "$entries_file" | awk '!/^(use|create database|drop database|USE|CREATE DATABASE|DROP DATABASE)/' >> buf.sql
        fi
	mysql $mysql_cmd $db < buf.sql
	rm buf.sql
else
	vagrant ssh -c "export local_database=true; bash /vagrant/scripts/populate_db.sh"
	read -n1 -r -p 'press a key to close' k
fi

