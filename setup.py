import os,json
try:
    BURROW_URL = os.environ["BURROW_URL"]
except KeyError:
    print
    print("please set BURROW_URL env as user provided variable")
    exit()

with open('/app/server/config/server_config.json') as data_file:
    data_item = json.load(data_file)
data_item["burrow"]["home"] = BURROW_URL +"/v3/kafka"
with open('/app/server/config/server_config.json', 'w') as outfile:
    json.dump(data_item, outfile,indent=4)