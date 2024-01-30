# Reisevorsorge App (intHealth) - Frontend

## Überblick
Das Frontend der Reisevorsorge App (intHealth), realisiert mit Flutter, dient als intuitive Benutzeroberfläche zur Interaktion mit dem Backend-Service und ermöglicht es Nutzern, essenzielle Reiseinformationen zu erhalten und Reisepläne mit medizinischem Fokus zu verwalten. Für eingeloggte Nutzer erweitert sich das Spektrum um GPS-basiertes Tracking der Reiserouten und um eine visuell ansprechende Darstellung der Reisedaten. Diese Funktionen sind insbesondere für Nutzer konzipiert, die Wert auf eine präzise Planung, Dokumentation und Analyse ihrer Reisen legen.

## Funktionen
**Reisewarnungen:** Anzeigen aktueller Reisewarnungen und -empfehlungen für ein ausgewähltes Land.<br>
**Reiseplanverwaltung:** Unterstützung für Ärzte und Reisende zur Erstellung und Verwaltung von Reiseplänen aus medizinischen Gründen.<br>

## Erweiterte Funktionen
**GPS-Tracking:** Nach Einverständnis können eingeloggte Nutzer ihren Reiseverlauf durch GPS-Tracking des Endgeräts automatisch aufzeichnen lassen.<br>
**Anzeige des Reiseverlaufs auf der Weltkarte:** Eingeloggte Nutzer können ihren Reiseverlauf auf einer Weltkarte visualisieren.<br>
**Export von Reiseplänen und GPS-Daten:** Nutzer haben die Möglichkeit, ihre Reisepläne und GPS-Daten als .txt- oder .json-Datei zu exportieren.<br>

## Datenschutz und Einwilligung
Die App fordert das ausdrückliche Einverständnis der Nutzer an, bevor GPS-Daten genutzt oder aufgezeichnet werden. Alle gesammelten Daten werden vertraulich behandelt und sicher gespeichert, um die Privatsphäre der Nutzer zu schützen.

## Anforderungen
Die Frontend-Anwendung wurde mit Flutter entwickelt. Die genauen Versionsanforderungen und Abhängigkeiten finden sich in der Datei *frontend/int_health/pubspec.yaml*.

## Installation
1. Klonen Sie das Repository.<br>
2. Wechseln Sie in das Frontend-Verzeichnis: `cd reisevorsorge-app/frontend/int_health`.<br>
3. Installieren Sie die notwendigen Flutter-Abhängigkeiten mit dem Befehl `flutter pub get`.<br>
4. Starten Sie die App mit `flutter run`.<br>


## Projektstruktur

  - **api/**:
    - `api_client.dart`: Verwaltet API-Aufrufe zum Backend.
  - **models/**:
    - `country.dart`: Datenmodell für länderspezifische Informationen.
    - `gps_data.dart`: Datenmodell für GPS-Tracking-Informationen.
    - `travel_plan.dart`: Datenmodell für Reisepläne der Nutzer.
    - `warning.dart`: Datenmodell für Reisewarnungen.
  - **providers/**:
    - `data_provider.dart`: Verwaltet Zustand und Daten für die Anwendung.
  - **screens/**:
    - `country_screen.dart`: UI-Bildschirm zur Anzeige länderspezifischer Informationen.
    - `home_screen.dart`: Der Hauptbildschirm der App.
    - `login_screen.dart`: UI für die Anmeldefunktionalität des Nutzers.
    - `profile_screen.dart`: UI für Nutzerprofildetails.
    - `registration_screen.dart`: UI für die Registrierung neuer Nutzer.
    - `settings_screen.dart`: UI für App-Einstellungen.
    - `travelplan_screen.dart`: UI für das Verwalten und Anzeigen von Reiseplänen.
  - **widgets/**:
    - `info_page.dart`: Widget zur Informationsanzeige.
    - `search_bar.dart`: Widget für die Suchfunktionalität.
    - `world_map.dart`: Widget zur Anzeige der Weltkarte.
- `main.dart`: Einstiegspunkt der Flutter-Anwendung.

## Nutzung
Nach der Installation können Nutzer die App starten und mit den Funktionen zur Ländersuche und Anzeige von Reisewarnungen interagieren. Die Verbindung zum Backend erfolgt automatisch, sofern dieses konfiguriert und online ist.

## Sicherheit und Datenschutz
Die App gewährleistet den Schutz sensibler Benutzerdaten und kommuniziert sicher mit dem Backend-Dienst. Authentifizierungs- und Autorisierungsfunktionen sind in Zusammenarbeit mit dem Backend implementiert.

## Datenintegration
Die Frontend-App bezieht ihre Daten über RESTful-API-Aufrufe vom Backend. Dies gewährleistet aktuelle Informationen und eine nahtlose Benutzererfahrung.

Stellen Sie sicher, dass das Backend richtig konfiguriert und erreichbar ist, um die vollständige Funktionalität der App zu gewährleisten.