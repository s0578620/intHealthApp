from .extensions import mongo
from flask_login import UserMixin
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import datetime
from bson import ObjectId

class User(UserMixin):
    def __init__(self, username, user_type, password_hash, gps_data=None, _id=None,travel_planning=None, secret_answer=None):
        self.username = username
        self.user_type = user_type
        self.password_hash = password_hash
        self.gps_data = gps_data or []
        self.travel_planning = travel_planning or []
        self._id = _id

    @staticmethod
    def get(user_id):
        user_data = mongo.db.users.find_one({"_id": ObjectId(user_id)})
        if not user_data:
            return None
        return User(**user_data)

    @staticmethod
    def authenticate(username, password):
        user_data = mongo.db.users.find_one({"username": username})
        if user_data and check_password_hash(user_data['password_hash'], password):
            return User(**user_data)
        return None

    @staticmethod
    def create(username, password, secret_answer):
        if mongo.db.users.find_one({"username": username}):
            return None

        password_hash = generate_password_hash(password)
        secret_answer_hash = generate_password_hash(secret_answer)
        user_type = "user"
        result = mongo.db.users.insert_one({
            "username": username,
            "user_type": user_type,
            "password_hash": password_hash,
            "secret_answer": secret_answer_hash
        })
        return User(username, user_type, password_hash, _id=result.inserted_id)
        
    def get_id(self):
        return str(self._id)
    
    def add_gps_data(self, gps_data):
        gps_data_with_date = {
            'coordinates': gps_data,
            'date': datetime.utcnow()
        }
        mongo.db.users.update_one(
            {"_id": self._id},
            {"$push": {"gps_data": gps_data_with_date}}
        )

    def set_password(self, new_password):
        self.password_hash = generate_password_hash(new_password)
        mongo.db.users.update_one(
            {"_id": self._id},
            {"$set": {"password_hash": self.password_hash}}
        )
    
    @staticmethod
    def verify_secret_answer(username, secret_answer):
        user_data = mongo.db.users.find_one({"username": username})
        if user_data and check_password_hash(user_data['secret_answer'], secret_answer):
            return True
        return False

    @staticmethod
    def reset_password(username, new_password):
        new_password_hash = generate_password_hash(new_password)
        mongo.db.users.update_one(
            {"username": username},
            {"$set": {"password_hash": new_password_hash}}
        )