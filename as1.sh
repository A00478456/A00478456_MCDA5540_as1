#!/bin/bash
#
set -eu
db="$1"
user="$2"
pass="$3"
#
echo
#### INSERT HERE the command to import from authors.json into MONGO collection author
col_name=author
mongouri="mongodb://$user:$pass@localhost/$db" 
mongo "$mongouri" --eval "db.$col_name.drop()"
mongoimport "$mongouri" -c $col_name --file authors.json
echo
echo "-> Imported authors.json into Mongodb collection \"author\""
echo

#### INSERT HERE the commands to export the MONGO collection and delete it
csv_file=authors.csv
mongoexport "$mongouri" -c $col_name --type=csv --fields=email,fname,lname -o $csv_file
mongo "$mongouri" --eval "db.$col_name.drop()"
echo
echo "-> Exported collection \"author\" into authors.csv and deleted the collection"
#
mysql -u "$user" --password="$pass" "$db" -e "drop table if exists author;"
mysql -u "$user" --password="$pass" "$db" -e "source create_author_table.sql;"
echo
echo "-> Created table \"author\" in MySQL database"
#
echo
#### INSERT HERE the commands to (possibly compile and) execute your program
#
python3 csv_to_sql.py $csv_file insert_authors.sql
mysql -u "$user" --password="$pass" "$db" -e "source insert_authors.sql;"
rm authors.csv
rm insert_authors.sql
echo
echo "-> Inserted from authors.csv into table \"authors\", and deleted authors.csv" #
mysql -u "$user" --password="$pass" "$db" -e "select * from author;" > "$user".txt
echo
echo "-> Contents of table \"author\" saved in file \"$user.txt\""
mysql -u "$user" --password="$pass" "$db" -e "drop table if exists author;"
echo
echo "-> Deleted table \"author\" from MySQL database. Bye!"
echo

