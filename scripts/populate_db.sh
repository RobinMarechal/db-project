#!/bin/bash
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
cd "$SCRIPTPATH/../"
source scripts/helpers/macros.sh
check_term

if [ $# -lt 1 ]; then
    echo "USAGE : ./purge_db.sh env"
    exit
fi

schemas_file="sql/schemas.sql"
entries_file="sql/entries.sql"

$(python3 scripts/get_yaml.py "config/db.yaml" "$1")
mysql_cmd="-h$server -u$username -p$password"
if [ "$LOCAL_DBPROJECT" = "true" ]; then
	cat "$schemas_file" | awk '!/^(use|create database|drop database|USE|CREATE DATABASE|DROP DATABASE)/' > buf.sql
        if [ "$1" = "app" ]; then
            cat "$entries_file" | awk '!/^(use|create database|drop database|USE|CREATE DATABASE|DROP DATABASE)/' >> buf.sql
        fi
	bash scripts/purge_db.sh "$1"	
	mysqladmin $mysql_cmd create "$db"
	mysql $mysql_cmd $db < buf.sql
	rm buf.sql
else
	vagrant ssh -c "bash /vagrant/scripts/populate_db.sh"
fi
