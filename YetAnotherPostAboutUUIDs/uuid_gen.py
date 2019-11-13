import uuid

for l in range(1,10000000):
    print "insert into data_uuid (id) values (f_uuid_to_id('" + str(uuid.uuid4()) + "'));"
    #print "insert into data_uuid (id) values (left(to_base64(unhex(replace('" + str(uuid.uuid4()) + "','-',''))),22));"
    #print "insert into data_uuid (id) values ('" + str(uuid.uuid4()) + "');"
    #print "insert into data_uuid (id) values (unhex(replace('" + str(uuid.uuid4()) + "','-','')));"
    #print "insert into data_uuid_bin16 (id) values (unhex(concat(hex(cast(unix_timestamp()/600 as unsigned) mod pow(2,16)),left(replace('" + str(uuid.uuid4()) + "','-',''),28))));"
