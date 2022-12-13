mkdir -p $1
duree=3600
db=tpcc_innodb
ssh 10.0.4.112 'df -h' > $1/fs_size.out 
mysql -h 10.0.4.112 -u sysbench -psysbench -e 'show global variables' > $1/mysql_vars.out
mysql -h 10.0.4.112 -u sysbench -psysbench -e 'show global status' > $1/mysql_status_start.out
ssh 10.0.4.112 "vmstat 1 $duree" > $1/vmstat.out &
./tpcc.lua --mysql-host=10.0.4.112 --mysql-user=sysbench --mysql-password=sysbench --mysql-ssl=off --mysql-db=$db --threads=4 --scale=200 --use_fk=0 --mysql_storage_engine=innodb --mysql_table_options="COLLATE latin1_bin" --trx_level=RC --report-interval=10 --time=$duree run > $1/sb.out
mysql -h 10.0.4.112 -u sysbench -psysbench -e 'show global status' > $1/mysql_status_end.out
