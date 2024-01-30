import 'dart:convert';
import 'dart:io';
import 'package:geocoding/geocoding.dart';
import 'package:int_health/models/gps_data.dart';
import 'package:share/share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../api/api_client.dart';
import '../models/country.dart';
import '../models/travel_plan.dart';
import '../models/warning.dart';

class DataProvider with ChangeNotifier {
  final ApiClient apiClient;

  DataProvider(this.apiClient);

  Country? selectedCountry;
  List<Country>? allCountries;
  List<Warning>? allWarnings;
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  final List<TravelPlan> _travelPlans = [];
  List<TravelPlan> get travelPlans => _travelPlans;

  void addTravelPlan(TravelPlan travelPlan) {
    _travelPlans.add(travelPlan);
    notifyListeners();
  }

  void removeTravelPlan(TravelPlan travelPlan) {
    _travelPlans.remove(travelPlan);
    notifyListeners();
  }

  Future<bool> saveTravelPlans() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/travel_plans.json');

    try {
      final String encodedData =
          json.encode(_travelPlans.map((plan) => plan.toJson()).toList());
      await file.writeAsString(encodedData);
      return true;
    } catch (e) {
      print('Fehler beim Speichern der Reisepläne: $e');
      return false;
    }
  }

  //TODO
  Future<void> loadTravelPlans() async {}

  Future<void> shareAllData(BuildContext context) async {
    final directory = await getApplicationDocumentsDirectory();
    final gpsFileText = File('${directory.path}/gps_data.txt');
    final gpsFileJson = File('${directory.path}/gps_data.json');
    final travelPlanFileJson = File('${directory.path}/travel_plans.json');
    final travelPlanFileText = File('${directory.path}/travel_plans.txt');

    // GPS-Daten als Text
    String gpsShareText = "GPS-Daten:\n\n";
    List<GpsData> gpsDataList = await fetchGpsData();
    for (var data in gpsDataList) {
      String address =
          await getAddressFromLatLng(data.latitude, data.longitude);
      gpsShareText += "Datum: ${data.timestamp}, Ort: $address\n";
    }
    await gpsFileText.writeAsString(gpsShareText);

    String gpsShareJson =
        json.encode(gpsDataList.map((data) => data.toJson()).toList());
    await gpsFileJson.writeAsString(gpsShareJson);

    String travelPlanJson =
        json.encode(_travelPlans.map((plan) => plan.toJson()).toList());
    await travelPlanFileJson.writeAsString(travelPlanJson);

    String travelPlanText = "Reisepläne:\n\n";
    for (var plan in _travelPlans) {
      travelPlanText +=
          "Land: ${plan.countryName}, Von: ${plan.startDate}, Bis: ${plan.endDate}\n";
    }
    await travelPlanFileText.writeAsString(travelPlanText);

    _showShareDialog(context, gpsFileText.path, gpsFileJson.path,
        travelPlanFileText.path, travelPlanFileJson.path);
  }

  void _showShareDialog(BuildContext context, String gpsTextPath,
      String gpsJsonPath, String travelTextPath, String travelJsonPath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Teilen als"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: const Text("GPS-Daten (Text)"),
                onTap: () {
                  Navigator.of(context).pop();
                  Share.shareFiles([gpsTextPath]);
                },
              ),
              ListTile(
                title: const Text("GPS-Daten (JSON)"),
                onTap: () {
                  Navigator.of(context).pop();
                  Share.shareFiles([gpsJsonPath]);
                },
              ),
              ListTile(
                title: const Text("Reisepläne (Text)"),
                onTap: () {
                  Navigator.of(context).pop();
                  Share.shareFiles([travelTextPath]);
                },
              ),
              ListTile(
                title: const Text("Reisepläne (JSON)"),
                onTap: () {
                  Navigator.of(context).pop();
                  Share.shareFiles([travelJsonPath]);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> shareTravelPlans() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/travel_plans.json');

    try {
      final String encodedData =
          json.encode(_travelPlans.map((plan) => plan.toJson()).toList());
      await file.writeAsString(encodedData);

      Share.shareFiles([file.path], text: 'Reiseverlauf');
    } catch (e) {
      print('Error sharing travel plans: $e');
    }
  }

  Future<void> shareGpsData(List<GpsData> gpsDataList) async {
    String shareText = "Mein Reiseverlauf:\n\n";
    for (var data in gpsDataList) {
      shareText +=
          "Datum: ${data.timestamp}, Ort: ${await getAddressFromLatLng(data.latitude, data.longitude)}\n";
    }
    Share.share(shareText);
  }

  Future<String> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      Placemark place = placemarks[0];
      String locality = place.locality ?? 'Unbekannt';
      String country = place.country ?? 'Unbekannt';
      return '$locality, $country';
    } catch (e) {
      return 'Unbekannter Ort';
    }
  }

  Future<bool> login(String username, String password,
      [Position? position]) async {
    Map<String, dynamic> loginData = {
      'username': username,
      'password': password,
    };
    if (position != null) {
      loginData['gps_data'] = {
        'latitude': position.latitude,
        'longitude': position.longitude,
      };
    }
    bool success = await apiClient.login(loginData);
    _isLoggedIn = success;
    notifyListeners();
    return success;
  }

  Future<bool> register(
      String username, String password, String secretanswer) async {
    bool success = await apiClient.register(username, password, secretanswer);
    notifyListeners();
    return success;
  }

  Future<void> logout() async {
    bool success = await apiClient.logout();
    if (success) {
      _isLoggedIn = false;
      notifyListeners();
    }
  }

  Future<List<GpsData>> fetchGpsData() async {
    return await apiClient.getGpsData();
  }

  Future<void> sendGpsData(List<dynamic> gpsData) async {
    await apiClient.importGpsData(gpsData);
    notifyListeners();
  }

  void fetchCountry(String id) async {
    final countryData = await apiClient.fetchCountry(id);
    selectedCountry = Country.fromJson(countryData);
    notifyListeners();
  }

  Future<void> fetchAllCountries() async {
    allCountries = (await apiClient.getAllCountries()).cast<Country>();
    notifyListeners();
  }

  Future<void> searchCountryByName(String name) async {
    final countryData = await apiClient.searchCountryByName(name);
    selectedCountry = Country.fromJson(countryData);
    notifyListeners();
  }

  Future<void> fetchWarnings(int countryId) async {
    allWarnings = await apiClient.fetchWarnings(countryId);
    notifyListeners();
  }

  Future<void> updateWarnings() async {
    await apiClient.updateCountryWarnings();
    notifyListeners();
  }
}
