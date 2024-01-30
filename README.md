# Reisevorsorge App (intHealth) - Gesamtprojekt
## Überblick

Die Reisevorsorge App (intHealth) ist eine umfassende Lösung für Reisende und medizinisches Personal, die aktuelle Reisewarnungen, medizinische Ratschläge und GPS-Tracking-Funktionen für eine sichere und informierte Reiseplanung bietet. Das Projekt ist in zwei Hauptkomponenten unterteilt: das Backend, entwickelt mit Flask und MongoDB, und das Frontend, realisiert mit Flutter. Diese Komponenten arbeiten zusammen, um eine reibungslose und interaktive Benutzererfahrung zu gewährleisten.
## Hauptfunktionen

1. **Reisewarnungen:** Aktuelle Informationen und Warnungen zu Reisezielen.
2. **Benutzerverwaltung:** Registrierung, Anmeldung und Profilverwaltung.
3. **Reiseplanung:** Erstellung und Verwaltung von individuellen Reiseplänen.
4. **GPS-Tracking:** Aufzeichnung und Visualisierung von Reiserouten für eingeloggte Nutzer.
5. **Datenschutz:** Sichere Handhabung und Speicherung von Benutzerdaten.

## Technologien

1. **Backend:** Python, Flask, MongoDB
2. **Frontend:** Flutter, Dart

## Installation und Konfiguration

Klonen sie das Repository
### Backend:
1. Navigieren Sie in das backend/ Verzeichnis.
2. Installation der Abhängigkeiten mit ``pip install -r requirements.txt``.
3. Einrichten der Umgebungsvariablen für MongoDB und Flask ``.env``.
4. Starten der Flask-Anwendung ``flask run``.

### Frontend:
1. Wechseln in das frontend/int_health/ Verzeichnis.
2. Installieren der Flutter-Abhängigkeiten mit ``flutter pub get``.
3. Starten der App mit ``flutter run``.

## Projektstruktur

1. **Backend:** Enthält die Flask-basierte API, Modelle, Routen und Hilfsprogramme für die Verwaltung von Reisewarnungen, Benutzerdaten und geplanten Aufgaben.
2. **Frontend:** Umfasst die Flutter-basierte Benutzeroberfläche mit Screens für die Ländersuche, Reisewarnungen, Reiseplanung und Benutzerverwaltung.

## Nutzung
Nach der Installation und Konfiguration können Nutzer die App starten und sich registrieren oder anmelden, um Zugriff auf personalisierte Funktionen wie Reisepläne und GPS-Tracking zu erhalten. Reisewarnungen und Länderinformationen sind für alle Nutzer zugänglich.

## Sicherheit
Das Projekt implementiert Best Practices für die Sicherheit, einschließlich Passworthashing, Session-Management und sichere API-Kommunikation, um den Schutz der Benutzerdaten zu gewährleisten.

## Datenintegration
Das Frontend kommuniziert mit dem Backend, um aktuelle Daten zu Reisewarnungen, Benutzerprofilen und Reiseplänen zu beziehen und zu aktualisieren.
