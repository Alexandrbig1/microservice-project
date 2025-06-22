from fastapi import FastAPI
from pymongo import MongoClient
import os

app = FastAPI()

# Get MongoDB URI from environment variable
MONGO_URI = os.environ.get("MONGO_URI", "mongodb://localhost:27017/mydatabase")
client = MongoClient(MONGO_URI)
db = client.get_database()  # Uses the database from the URI

@app.get("/")
def read_root():
    return {"message": "FastAPI is running!"}

@app.get("/test-mongo")
def test_mongo():
    # Test MongoDB connection and fetch data from a sample collection
    try:
        sample_collection = db.get_collection("sample_collection")
        sample_data = sample_collection.find_one()  # Fetch one document for testing
        return {"message": "MongoDB connection successful!", "data": sample_data}
    except Exception as e:
        return {"error": str(e)}