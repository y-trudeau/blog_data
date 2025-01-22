import uuid

for l in range(1,100000000):
    print ("insert into data_uuid (a,b,c) values ('" + str(uuid.uuid4()) + "','" + str(uuid.uuid4()) + "','" + str(uuid.uuid4()) + "');")
