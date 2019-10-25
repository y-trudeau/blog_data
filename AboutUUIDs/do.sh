mkdir -p $1
cd $1
mysqladmin extended-status -i1 > >(gzip > mysql_status.gz) & 
MAPID=$!
#timeout 600 python ../uuid_gen.py | mysql UUID > out1 &
timeout 600 python ../uuid_gen.py | mysql UUID > out
kill $MAPID
mysql -e "show table status\G" UUID > table_status.txt
mysql -e "show global variables;" > global_variables.txt
mysqldump --no-data --single-transaction -R UUID > schema.sql
cd ..

