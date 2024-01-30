from wtforms import FieldList, Form, FormField, IntegerField, StringField, validators

class WarningForm(Form):
    id_number = IntegerField('ID-Nummer', validators=[validators.InputRequired(message="The unique identifier for the warning is required.")])
    name = StringField('Name', validators=[validators.InputRequired(message="The name of the warning is required.")])
    description = StringField('Beschreibung', validators=[validators.InputRequired(message="A description of the warning is required.")])

class CountryForm(Form):
    id_number = IntegerField('ID-Nummer', validators=[validators.InputRequired(message="The unique identifier for the country is required.")])
    countryname = StringField('Ländername', validators=[validators.InputRequired(message="The name of the country is required.")])
