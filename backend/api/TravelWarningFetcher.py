from deutschland import travelwarning
from deutschland.travelwarning.api import default_api
from .scraper import scrape_content_between_h2_tags
from bson import ObjectId
from datetime import datetime
from .extensions import mongo
from bs4 import BeautifulSoup, NavigableString
import difflib

class TravelWarningFetcher:
    def __init__(self):
        self.configuration = travelwarning.Configuration(
            host="https://www.auswaertiges-amt.de/opendata"
        )
        self.api_client = travelwarning.ApiClient(self.configuration)
        self.api_instance = default_api.DefaultApi(self.api_client)
    
    def calculate_diff(old_text, new_text):
        d = difflib.Differ()
        diff = list(d.compare(old_text, new_text))
        result = ""
        for token in diff:
            if token.startswith('+ '):
                result += f"<span style='color: green;'>{token[2:]}</span>"
            elif token.startswith('- '):
                result += f"<span style='color: red;'>{token[2:]}</span>"
            else:
                result += token[2:]
        return result
    
    def fetch_travel_warnings(self):
        try:
            api_response = self.api_instance.get_travelwarning()
            return api_response.to_dict().get('response', {})
        except travelwarning.ApiException as e:
            print("Exception when calling DefaultApi->get_travelwarning: %s\n" % e)
            return {}

    def get_country_id_name_list(self):
        response_dict = self.fetch_travel_warnings()
        country_id_name_list = []

        for response_id, response_info in response_dict.items():
            if isinstance(response_info, dict):
                country_id_name_list.append({'id': response_id, 'countryName': response_info.get('countryName')})

        return country_id_name_list

    def insert_countries_into_db(self, mongo_db):
        country_id_name_list = self.get_country_id_name_list()

        for item in country_id_name_list:
            self.insert_country(mongo_db, item['id'], item['countryName'])

    @staticmethod
    def insert_country(mongo_db, id_number, country_name):
        country_collection = mongo_db.countrys
        country_collection.insert_one({
            'id_number': id_number,
            'country_name': country_name
        })
        print(f"ID: {id_number}, Ländername: {country_name}")

    # Warnings
    def fetch_and_insert_warnings(self, mongo_db):
        country_id_name_list = self.get_country_id_name_list()
        for item in country_id_name_list:
            country_id = item['id']
            with self.api_client as api_client:
                api_instance = default_api.DefaultApi(api_client)
                try:
                    api_response = api_instance.get_single_travelwarning(int(country_id))
                    response_data = api_response.to_dict()
                    content = response_data['response'][str(country_id)]['content']
                    self.insert_warning_into_db(mongo_db, country_id, content)
                except travelwarning.ApiException as e:
                    print("Exception when calling DefaultApi->get_single_travelwarning: %s\n" % e)

    @staticmethod
    def insert_warning_into_db(mongo_db, country_id, content):
        warnings_collection = mongo_db.warnings

        def scraper(content):
            extracted_content = scrape_content_between_h2_tags(content, 'Gesundheit', 'Länderinfos zu Ihrem Reiseland')
            return {'warning_text': extracted_content}

        scraped_data = scraper(content)

        warnings_collection.insert_one({
            'country_id': country_id,
            'upload_date': datetime.utcnow(),
            **scraped_data
        })

        print(f"Inserted warning for country ID: {country_id}")
    
    def update_country_warnings(self, mongo_db):
        country_id_name_list = self.get_country_id_name_list()

        warnings_collection = mongo_db.warnings

        for item in country_id_name_list:
            country_id = item['id']
            print(f"Comparing Warning for ID: {country_id}")

            with self.api_client as api_client:
                api_instance = default_api.DefaultApi(api_client)
                try:
                    api_response = api_instance.get_single_travelwarning(int(country_id))
                    response_data = api_response.to_dict()
                    new_content = response_data['response'][str(country_id)]['content']

                    extracted_content = scrape_content_between_h2_tags(new_content, 'Gesundheit', 'Länderinfos zu Ihrem Reiseland')

                    current_warning = warnings_collection.find_one({'country_id': country_id})

                    if current_warning:
                        if current_warning['warning_text'] != extracted_content:
                            print('updating...')
                            if 'history' not in current_warning:
                                print('history')
                                current_warning['history'] = []
                            current_warning['history'].append({
                                'date': datetime.utcnow(),
                                'text': current_warning['warning_text']
                            })

                            warnings_collection.update_one(
                                {'_id': current_warning['_id']},
                                {'$set': {
                                    'warning_text': extracted_content,
                                    'history': current_warning['history']
                                }}
                            )
                            print(f"Warning for ID: {country_id} updated.")
                    else:
                        print('keine gefunden')
                        warnings_collection.insert_one({
                            'country_id': country_id,
                            'warning_text': extracted_content,
                            'history': []
                        })
                except travelwarning.ApiException as e:
                    print("Exception when calling DefaultApi->get_single_travelwarning: %s\n" % e)

    print("Warnings updated successfully!")