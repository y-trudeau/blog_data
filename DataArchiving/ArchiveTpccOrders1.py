import sys
import json
import MySQLdb
from datetime import datetime

# This script is designed to capture the output of Maxwell (stdout), filter
# the event for the table tpcc.orders1 and apply only the insert and update event
# to the table tpccArchive.orders1.

DEBUG = 0

def debug_print(msg):
    if DEBUG > 0:
        print('DEBUG ' + datetime.now().isoformat(timespec='seconds') + ': ' + msg)


#(dbName,tableName) = sys.argv[1].split('.')
dbName = 'tpcc'
tableName = 'orders1'
destDbName = 'tpccArchive'

debug_print('dbName = ' + dbName + ' tableName = ' + tableName)

conn = MySQLdb.connect(host='127.0.0.1',user='archiver',passwd='tpcc',db='tpccArchive')
cursor = conn.cursor()

sql = 'begin;'
for line in sys.stdin:
    j = json.loads(line)
    if j['database'] == dbName and j['table'] == tableName:
        debug_print(line)
        if j['type'] == 'insert':
            # Let's build an replace into statement
            sql += 'insert ignore into ' + destDbName + '.' + tableName
            sql += ' set o_id = ' + str(j['data']['o_id'])
            sql += ', o_d_id = ' + str(j['data']['o_d_id'])
            sql += ', o_w_id = ' + str(j['data']['o_w_id'])
            if j['data']['o_c_id'] is not None:
                sql += ', o_c_id = ' + str(j['data']['o_c_id'])
            else:
                sql += ', o_c_id = NULL'
            if j['data']['o_entry_d'] is not None:
                sql += ", o_entry_d = '" + j['data']['o_entry_d'] + "'"
            else:
                sql += ', o_entry_d = NULL'
            if j['data']['o_carrier_id'] is not None:
                sql += ', o_carrier_id = ' + str(j['data']['o_carrier_id'])
            else:
                sql += ', o_carrier_id = NULL'
            if j['data']['o_ol_cnt'] is not None:
                sql += ', o_ol_cnt = ' + str(j['data']['o_ol_cnt'])
            else:
                sql += ', o_ol_cnt = NULL'
            if j['data']['o_all_local'] is not None:
                sql += ', o_all_local = ' + str(j['data']['o_all_local'])
            else:
                sql += ', o_all_local = NULL'
            sql += ';'
        elif j['type'] == 'update':
            sql += 'update '  + destDbName + '.' + tableName
            sql += ' set o_id = ' + str(j['data']['o_id'])
            sql += ', o_d_id = ' + str(j['data']['o_d_id'])
            sql += ', o_w_id = ' + str(j['data']['o_w_id'])
            if j['data']['o_c_id'] is not None:
                sql += ', o_c_id = ' + str(j['data']['o_c_id'])
            else:
                sql += ', o_c_id = NULL'
            if j['data']['o_entry_d'] is not None:
                sql += ", o_entry_d = '" + j['data']['o_entry_d'] + "'"
            else:
                sql += ', o_entry_d = NULL'
            if j['data']['o_carrier_id'] is not None:
                sql += ', o_carrier_id = ' + str(j['data']['o_carrier_id'])
            else:
                sql += ', o_carrier_id = NULL'
            if j['data']['o_ol_cnt'] is not None:
                sql += ', o_ol_cnt = ' + str(j['data']['o_ol_cnt'])
            else:
                sql += ', o_ol_cnt = NULL'
            if j['data']['o_all_local'] is not None:
                sql += ', o_all_local = ' + str(j['data']['o_all_local'])
            else:
                sql += ', o_all_local = NULL'
            sql += ' where o_id = ' + str(j['data']['o_id'])
            sql += ' and o_d_id = ' + str(j['data']['o_d_id'])
            sql += ' and o_w_id = ' + str(j['data']['o_w_id'])
            sql += ';'
    if 'commit' in j.keys():
        debug_print('commit in j.keys')
        if j['commit']:
            debug_print('commit is true')
            sql += 'commit;'
            debug_print(sql)
            cursor.execute(sql) # would need to handle errors and reconnect
            sql = 'begin;'
    debug_print(sql)
