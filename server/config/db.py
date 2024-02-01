from pymongo.mongo_client import MongoClient

uri=""
client = MongoClient(uri)

db = client.user_db
# user_collection = db["user_collection"]
# user_collection = db["user_sample_collection"]
user_collection = db["user_test_collection"]
