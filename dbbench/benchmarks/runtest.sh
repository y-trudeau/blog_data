#!/bin/bash
# $1 is the test name
#

if [ "b$1" == "b" ]; then
    echo "Need a test name"
    exit 1
fi

# Clearing the file cache
echo 3 > /proc/sys/vm/drop_caches

export PGPASSWORD=pmm

mkdir -p $1
cd $1

grep vda /proc/diskstats > vda_stats.start
du -s /mnt/data/* > du.start

(date; date +%s) > start

vmstat 1 > vmstat.out &
vmstatpid=$!

iostat -xNm 5 vda > iostat.out &
iostatpid=$!

psql dbbench pmm -c 'show all;' > pg_config.out
mysql -u dbbench -pdbbench -e 'show global variables;' > mysql_config.out
mysql -u dbbench -pdbbench -e 'show global status;' > mysql_status_start.out


# Run the actual test
pmm-admin annotate "start bench $1"

rm -f stop_collect

if false; then
    # MySQL

    head -n 20000000 ../../generator/100M_inserts.sql | mysql -u dbbench -pdbbench dbbench
    #cat ../../generator/5M_updates.sql | mysql -u dbbench -pdbbench dbbench
    (date; date +%s) > end_load
    mysql -u dbbench -pdbbench dbbench -e 'select now(), (select count(*) from data_uuid force index (idx_ab)) idx_ab, (select count(*) from data_uuid force index (idx_ba)) idx_ba, (select count(*) from data_uuid force index (idx_ca)) idx_ca, (select count(*) from data_uuid force index (idx_cb)) idx_cb, (select count(*) from data_uuid force index (idx_acb)) idx_acb, (select count(*) from data_uuid force index (idx_bca)) idx_bca;' > idx_counts1
    (date; date +%s) > end_counts1
    mysql -u dbbench -pdbbench dbbench -e 'select now(), (select count(*) from data_uuid force index (idx_ab)) idx_ab, (select count(*) from data_uuid force index (idx_ba)) idx_ba, (select count(*) from data_uuid force index (idx_ca)) idx_ca, (select count(*) from data_uuid force index (idx_cb)) idx_cb, (select count(*) from data_uuid force index (idx_acb)) idx_acb, (select count(*) from data_uuid force index (idx_bca)) idx_bca;' > idx_counts2
    (date; date +%s) > end_counts2

    while true; do
        dirty=$(mysql -BN -e "show global status like 'Innodb_buffer_pool_pages_dirty';" | cut -f2)
        if [ "$dirty" -gt 0 ] || [ -f stop_collect ]; then
            sleep 5 
        else
            break
        fi
    done
fi

if false; then
    # Pg
    # pmm-admin add postgresql --username=pmm --password=pmm --database=dbbench
    (head -n 20000000 ../../generator/100M_inserts.sql) | psql dbbench pmm -q -f -
    #(cat ../../generator/5M_updates.sql) | psql dbbench pmm -q -f -
    sleep 30
    pmm-admin annotate "vacuum $1"
    grep vda /proc/diskstats > vda_stats.vacuum
    psql dbbench pmm -q -c 'vacuum;'
fi

if true; then
    mongosh --eval "printjson(db.serverStatus())" > mongostat.start
    mongoimport -d test -c data_uuid --type=json --file ../../generator/20M_inserts.mongo
    mongosh --eval "printjson(db.serverStatus())" > mongostat.end
fi

pmm-admin annotate "end bench $1"

(date; date +%s) > end 
mysql -u dbbench -pdbbench -e 'show global status;' > mysql_status_end.out
du -s /mnt/data/* > du.end
grep vda /proc/diskstats > vda_stats.end
kill $vmstatpid
kill $iostatpid
       
