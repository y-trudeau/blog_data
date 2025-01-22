import uuid
import random

# The Pg serial was not rewinded after a truncate, so limiting the range from 1921465 to 20M-1
for l in range(1,5000000):

    print ("update data_uuid set status = status + 1 where id = " + str(random.randint(1921465,19999999)) +";")
