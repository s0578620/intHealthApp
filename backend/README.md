# reisevorsorge_app


## Overview
Dieses Projekt bietet eine Flask-basierte Backend-API zum Abrufen, Aktualisieren und Verwalten von Reisewarnungen, Benutzerregistrierungen und Anmeldefunktionen. Es integriert MongoDB für die Datenspeicherung, Flask-Login für die Benutzerauthentifizierung und APScheduler für geplante Aufgaben.

## Funktionen
**Reisewarnungen:** Abrufen und Aktualisieren von Reisewarnungen aus einer externen Quelle.<br>
**Benutzerverwaltung:** Benutzer registrieren, Anmeldungen verarbeiten und Benutzersitzungen verwalten.<br>
**Geplante Aktualisierungen:** Automatische tägliche Aktualisierung von Reisewarnungen mit APScheduler.<br>
**Datenverwaltung:** Speichern und Abrufen von Ländern, Warnungen und Benutzerdaten aus MongoDB.<br>

## Requirements
Dieses Projekt wurde mit Python 3.9 implementiert. Die benötigten *Packages* befinden sich in der *backen/requirements.txt*<br>

## Installation
1. Klonen Sie das Repository auf Ihren lokalen Computer.<br>
2. Navigieren Sie in das Verzeichnis backend/ des geklonten Projekts.<br>
3. Installieren Sie die erforderlichen Python-Pakete mit dem Befehl pip install -r requirements.txt. Diese Datei listet alle Abhängigkeiten auf, die für das Projekt benötigt werden.<br>
4. Richten Sie Umgebungsvariablen für die MongoDB-Verbindung (MONGO_URI) und den Flask-Geheimschlüssel (SECRET_KEY) ein (backend/.env).<br>

## Projektstruktur
backend/api/<br>
├── __init__.py             # Initialisiert die Flask-App mit Konfigurationen und geplanten Aufgaben<br>
├── extensions.py           # Flask-Erweiterungen, einschließlich PyMongo-Setup<br>
├── forms.py                # WTForms-Definitionen für die Datenvalidierung<br>
├── models.py               # Benutzermodell und zugehörige Funktionen<br>
├── routing.py              # Flask-Routen für API-Endpunkte<br>
├── scraper.py              # Hilfsprogramm zum Scrapen von HTML-Inhalten<br>
├── settings.py             # Konfigurationseinstellungen, einschließlich Umgebungsvariablen<br>
└── TravelWarningFetcher.py # Ruft Reisewarnungen ab und verarbeitet diese<br>

## Usage
Um die Flask-Anwendung zu starten:<br>
1. Navigieren Sie zum Stammverzeichnis des Projekts.<br>
2. Führen Sie flask run oder python -m flask run aus, um den Server zu starten.<br>
3. Greifen Sie über HTTP-Anfragen auf die bereitgestellten Endpunkte zu.<br>

## Endpoints
1. **GET /getListOfCountrys:** Abrufen einer Liste von Ländern aus der Datenbank.<br>
2. **GET /getWarningsOfCountry/<id_number>:** Warnungen für ein bestimmtes Land anhand seiner ID abrufen.<br>
3. **GET /updateCountryWarnings:** Manuell eine Aktualisierung der Länderwarnungen auslösen.<br>
4. **POST /register:** Einen neuen Benutzer mit Benutzername, Passwort und Geheimantwort registrieren.<br>
5. **POST /login:** Einen vorhandenen Benutzer mit Benutzername und Passwort anmelden.<br>
6. **GET /logout:** Den aktuellen Benutzer abmelden.<br>
7. **POST /change_password:** Das Passwort für den angemeldeten Benutzer ändern.<br>
8. **POST /reset_password:** Das Passwort eines Benutzers mit seiner Geheimantwort zurücksetzen.<br>
9. **GET /get_gps_data:** GPS-Daten für den angemeldeten Benutzer abrufen.<br>
10. **POST /import_gps_data:** GPS-Daten für den angemeldeten Benutzer importieren.<br>
11. **POST /addCountryToTravelPlan:** Ein Land zum Reiseplan des angemeldeten Benutzers hinzufügen.<br>
12. **GET /getTravelPlanning:** Den Reiseplan des angemeldeten Benutzers abrufen.<br>
13. **DELETE /removeCountryFromTravelPlan:** Ein Land aus dem Reiseplan des angemeldeten Benutzers entfernen.<br>

## Scheduled Tasks
The application is configured to automatically update travel warnings every day at midnight using APScheduler.

## Security
1. Passwörter werden mit den Sicherheitsfunktionen von *Werkzeug* gehasht.<br>
2. *Flask-Login* verwaltet die Benutzerauthentifizierung und Sessions<br>

## Data Storage
Verwendete MongoDB-Sammlungen:
1. **users:** Speichert Benutzerinformationen, einschließlich gehashter Passwörter und GPS-Daten.<br>
2. **countrys:** Enthält Informationen über Länder.<br>
3. **warnings:** Speichert Reisewarnungen, einschließlich historischer Änderungen.<br>

Stellen Sie sicher, dass MongoDB läuft und über die in den Umgebungsvariablen angegebene MONGO_URI zugänglich ist.<br>