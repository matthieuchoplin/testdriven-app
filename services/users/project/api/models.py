from sqlalchemy.sql import func

from project import db


class User(db.Model):

    __tablename__ = "users"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)  # type: ignore
    username = db.Column(db.String(128), nullable=False)  # type: ignore
    email = db.Column(db.String(128), nullable=False)  # type: ignore
    active = db.Column(db.Boolean(), default=True, nullable=False)  # type: ignore
    created_date = db.Column(db.DateTime, default=func.now(), nullable=False)  # type: ignore

    def __init__(self, username, email):
        self.username = username
        self.email = email

    def to_json(self):
        return {
            "id": self.id,
            "username": self.username,
            "email": self.email,
            "active": self.active,
        }
