import pprint
from flask import Blueprint, jsonify, request
from .TravelWarningFetcher import TravelWarningFetcher
from .extensions import mongo
from flask_login import login_user, logout_user, login_required, current_user
from .models import User
from bson import ObjectId
from datetime import datetime

routing = Blueprint('routing', __name__)

@routing.route('/getListOfCountrys', methods=['GET'])
def get_list_of_countries():
    country_collection = mongo.db.countrys
    countries = country_collection.find({}, {'_id': 0})
    return jsonify(list(countries))

@routing.route('/getWarningsOfCountry/<int:id_number>', methods=['GET'])
def get_warnings_of_country(id_number):
    warnings_collection = mongo.db.warnings
    warnings = warnings_collection.find({'country_id': str(id_number)}, {'_id': 0, 'warning_text': 1})
    return jsonify(list(warnings))

@routing.route('/updateCountryWarnings', methods=['GET', 'POST'])
def update_country_warnings():
    fetcher = TravelWarningFetcher()
    fetcher.update_country_warnings(mongo.db)
    return "Warnings updated successfully!"

@routing.route('/fetch_and_insert_countries')
def fetch_and_insert_countries():
    fetcher = TravelWarningFetcher()
    fetcher.insert_countries_into_db(mongo.db)
    return "Countries fetched and inserted successfully!"

@routing.route('/fetch_and_insert_warnings')
def fetch_and_insert_warnings():
    fetcher = TravelWarningFetcher()
    fetcher.fetch_and_insert_warnings(mongo.db)
    return "Warnings fetched and inserted successfully!"

@routing.route('/getWarningDiff/<country_id>', methods=['GET'])
def get_warning_diff(country_id):
    warnings_collection = mongo.db.warnings
    warning = warnings_collection.find_one({'country_id': country_id})

    if warning:
        current_text = warning['warning_text']
        last_change = warning['history'][-1] if warning['history'] else {'text': ''}
        old_text = last_change['text']

        diff = TravelWarningFetcher.calculate_diff(old_text, current_text)
        diff_lines = diff.split('\n')
        return jsonify({'diff': diff_lines})
    else:
        return jsonify({'message': 'Warning not found'}), 404

@routing.route('/register', methods=['POST'])
def register():
    data = request.json
    new_user = User.create(data['username'], data['password'], data['secretanswer'])

    if new_user is None:
        return jsonify({"message": "Username already exists"})
    
    return jsonify({"message": "User created successfully"})

@routing.route('/login', methods=['POST'])
def login():
    data = request.json
    user = User.authenticate(data['username'], data['password'])
    gps_data = data.get('gps_data') 
    if user:
        print(user.username)
        login_user(user)
        if gps_data:
            user.add_gps_data(gps_data)
        return jsonify({"message": "Logged in successfully"}), 200
    return jsonify({"message": "Invalid credentials"}), 401

@login_required
@routing.route('/logout', methods=['GET'])
def logout():
    username = current_user.username
    logout_user()
    return jsonify({"message": f"Logged out user {username} successfully"})

@routing.route('/change_password', methods=['POST'])
@login_required
def change_password():
    data = request.json
    old_password = data['old_password']
    new_password = data['new_password']

    user = User.authenticate(current_user.username, old_password)
    if user:
        user.set_password(new_password)
        return jsonify({"message": "Password changed successfully"})
    else:
        return jsonify({"message": "Incorrect old password"})
    
@routing.route('/reset_password', methods=['POST'])
def reset_password():
    data = request.json
    username = data['username']
    secret_answer = data['secret_answer']
    new_password = data['new_password']

    if User.verify_secret_answer(username, secret_answer):
        User.reset_password(username, new_password)
        return jsonify({"message": "Password reset successful"})
    else:
        return jsonify({"message": "Incorrect secret answer"})

@routing.route('/get_gps_data', methods=['GET'])
@login_required
def get_gps_data():
    user_id = current_user.get_id()
    user_data = mongo.db.users.find_one({"_id": ObjectId(user_id)})

    if not user_data:
        return jsonify({"message": "User not found"})

    gps_data = user_data.get("gps_data", [])
    return jsonify({"gps_data": gps_data})

@routing.route('/import_gps_data', methods=['POST'])
@login_required
def import_gps_data():
    user_id = current_user.get_id()
    data = request.json

    if 'gps_data' not in data:
        return jsonify({"message": "No GPS data provided"}), 400

    gps_data = data['gps_data']
    if not isinstance(gps_data, list):
        return jsonify({"message": "GPS data should be a list"}), 400

    mongo.db.users.update_one(
        {"_id": ObjectId(user_id)},
        {"$push": {"gps_data": {"$each": gps_data}}}
    )
    return jsonify({"message": "GPS data imported successfully"})

@routing.route('/addCountryToTravelPlan', methods=['POST'])
@login_required
def add_country_to_travel_plan():
    user_id = current_user.get_id()
    data = request.json
    country_id = data.get('country_id')

    if not country_id:
        return jsonify({"message": "Country ID is required"}), 400

    user_data = mongo.db.users.find_one({"_id": ObjectId(user_id)})

    if not user_data:
        return jsonify({"message": "User not found"}), 404

    if 'travel_planning' not in user_data:
        user_data['travel_planning'] = []

    if country_id not in user_data['travel_planning']:
        mongo.db.users.update_one(
            {"_id": ObjectId(user_id)},
            {"$push": {"travel_planning": country_id}}
        )
        return jsonify({"message": f"Country ID {country_id} added to travel plan"})
    else:
        return jsonify({"message": "Country already in travel plan"})


@routing.route('/getTravelPlanning', methods=['GET'])
@login_required
def get_travel_planning():
    user_id = current_user.get_id()
    user_data = mongo.db.users.find_one({"_id": ObjectId(user_id)})

    if not user_data:
        return jsonify({"message": "User not found"}), 404
    
    travel_planning = user_data.get("travel_planning", [])
    return jsonify({"travel_planning": travel_planning})


@routing.route('/removeCountryFromTravelPlan', methods=['DELETE'])
@login_required
def remove_country_from_travel_plan():
    user_id = current_user.get_id()
    data = request.json
    country_id = data.get('country_id')

    if not country_id:
        return jsonify({"message": "Country ID is required"}), 400

    mongo.db.users.update_one(
        {"_id": ObjectId(user_id)},
        {"$pull": {"travel_planning": country_id}}
    )
    
    return jsonify({"message": f"Country ID {country_id} removed from travel plan"})

