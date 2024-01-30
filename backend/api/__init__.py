from flask import Flask
from flask_cors import CORS
from .extensions import mongo
from .routing import routing
from apscheduler.schedulers.background import BackgroundScheduler
from .routing import update_country_warnings
from flask_login import LoginManager
from .models import User

def create_app(config_object='api.settings'):
    app = Flask(__name__)
    CORS(app)
    app.config.from_object(config_object)
    app.secret_key = app.config['SECRET_KEY']

    mongo.init_app(app)
    app.register_blueprint(routing)

    scheduler = BackgroundScheduler()
    scheduler.add_job(func=update_country_warnings, trigger='cron', hour=0)
    scheduler.start()

    login_manager = LoginManager()
    login_manager.init_app(app)

    @login_manager.user_loader
    def load_user(user_id):
        return User.get(user_id)
    
    return app
