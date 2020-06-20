import os

from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_debugtoolbar import DebugToolbarExtension
from flask_cors import CORS
from flask_migrate import Migrate
from flask_bcrypt import Bcrypt

# instantiate the db
db = SQLAlchemy()
# instantiate the debug toolbar
toolbar = DebugToolbarExtension()
cors = CORS()
migrate = Migrate()
bcrypt = Bcrypt()

"""
Here we are using the Application Factory pattern.
See: https://flask.palletsprojects.com/en/1.1.x/patterns/appfactories/
"""


def create_app(script_info=None):

    # instantiate the app
    app = Flask(__name__)

    # set config
    app_settings = os.getenv("APP_SETTINGS")
    app.config.from_object(app_settings)

    # set up extensions
    db.init_app(app)
    toolbar.init_app(app)
    cors.init_app(app)
    migrate.init_app(app, db)
    bcrypt.init_app(app)

    # register blueprints
    from project.api.users import users_blueprint

    app.register_blueprint(users_blueprint)

    # shell context for flask cli
    # This is used to register the app and db
    # to the shell (no need to import app and
    # db to the shell anymore).
    # See: https://flask.palletsprojects.com/en/1.1.x/api/#flask.Flask.shell_context_processor
    @app.shell_context_processor
    def ctx():
        return {"app": app, "db": db}

    return app
