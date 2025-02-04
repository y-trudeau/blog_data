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

    #head -n 20000000 ../../generator/100M_inserts.sql | mysql -u dbbench -pdbbench dbbench
    cat ../../generator/5M_updates.sql | mysql -u dbbench -pdbbench dbbench
    while true; do
        dirty=$(mysql -BN -e "show global status like 'Innodb_buffer_pool_pages_dirty';" | cut -f2)
        if [ "$dirty" -gt 0 ] || [ -f stop_collect ]; then
            sleep 5 
        else
            break
        fi
    done
else
    # Pg

    (cat ../../generator/5M_updates.sql) | psql dbbench pmm -q -f -
    sleep 30
    pmm-admin annotate "vacuum $1"
    grep vda /proc/diskstats > vda_stats.vacuum
    psql dbbench pmm -q -c 'vacuum;'
fi


pmm-admin annotate "end bench $1"

(date; date +%s) > end 
mysql -u dbbench -pdbbench -e 'show global status;' > mysql_status_end.out
du -s /mnt/data/* > du.end
grep vda /proc/diskstats > vda_stats.end
kill $vmstatpid
kill $iostatpid
       
