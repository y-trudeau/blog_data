./tpcc.lua --mysql-host=10.0.4.112 --mysql-user=sysbench --mysql-password=sysbench --mysql-ssl=off --mysql-db=tpcc_myrocks --threads=2 --scale=200 \
     --use_fk=0 --mysql_storage_engine=rocksdb --mysql_table_options='COLLATE latin1_bin' --trx_level=RC prepare
