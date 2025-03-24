import uuid

for l in range(1,20000000):
    print ("db.data_uuid.insert({ id: " + str(l) + ", a: '"  + str(uuid.uuid4()) + "', b: '" + str(uuid.uuid4()) + "', c: '" + str(uuid.uuid4()) + "'})")
