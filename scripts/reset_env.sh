#!/bin/bash
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
source "$SCRIPTPATH/helpers/macros.sh"
check_term

if [ -z "$LOCAL_DBPROJECT" ]; then
	vagrant ssh -c "export LOCAL_DBPROJECT=true; bash /vagrant/scripts/reset_env.sh"
    exit
fi

PURGE_MSTUD=true bash update.sh

rm -r $SCRIPTPATH/../model_student
cp -r /home/ubuntu/.db-project/model_student $SCRIPTPATH/../
rm -r $SCRIPTPATH/../sql
cp -r /home/ubuntu/.db-project/sql $SCRIPTPATH/../
bash $SCRIPTPATH/purge_db.sh "app"
bash $SCRIPTPATH/purge_db.sh "test"
