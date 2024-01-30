import 'dart:convert';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:http/http.dart' as http;
import 'package:int_health/models/country.dart';
import 'package:int_health/models/warning.dart';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import '../models/gps_data.dart';

class ApiClient {
  final String baseUrl;
  final Dio dio;
  final CookieJar cookieJar;

  ApiClient(this.baseUrl)
      : dio = Dio(),
        cookieJar = CookieJar() {
    dio.interceptors.add(CookieManager(cookieJar));
  }

  Future<Map<String, dynamic>> fetchCountry(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/countries/$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load country');
    }
  }

  Future<List<Country>> getAllCountries() async {
    final response = await http.get(Uri.parse('$baseUrl/getListOfCountrys'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map<Country>((json) => Country.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load countries');
    }
  }

  Future<List<Warning>> fetchWarnings(int countryId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/getWarningsOfCountry/$countryId'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map<Warning>((json) => Warning.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load warnings');
    }
  }

  Future<List<String>> fetchWarningDiff(int countryId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/getWarningDiff/$countryId'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['diff'];
        return data.cast<String>();
      } else {
        throw Exception('Failed to load warning differences');
      }
    } catch (e) {
      throw Exception('Error fetching warning differences: $e');
    }
  }

  Future<Map<String, dynamic>> searchCountryByName(String countryName) async {
    final response = await http
        .get(Uri.parse('$baseUrl/countries?countryname=$countryName'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        return data[0];
      } else {
        throw Exception('Country not found');
      }
    } else {
      throw Exception('Failed to search country');
    }
  }

  Future<void> updateCountryWarnings() async {
    final response =
        await http.get(Uri.parse('$baseUrl/updateCountryWarnings'));
    if (response.statusCode != 200) {
      throw Exception('Failed to update country warnings');
    }
  }

  Future<bool> login(Map<String, dynamic> loginData) async {
    final response = await dio.post(
      '$baseUrl/login',
      data: json.encode(loginData),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> register(
      String username, String password, String secretanswer) async {
    final response = await dio.post(
      '$baseUrl/register',
      data: {
        'username': username,
        'password': password,
        'secretanswer': secretanswer,
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> logout() async {
    final response = await dio.get('$baseUrl/logout');
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<GpsData>> getGpsData() async {
    final response = await dio.get('$baseUrl/get_gps_data');
    if (response.statusCode == 200) {
      List<dynamic> gpsDataList = response.data['gps_data'];
      return gpsDataList.map((data) => GpsData.fromJson(data)).toList();
    } else {
      throw Exception('Failed to get GPS data');
    }
  }

  Future<void> importGpsData(List<dynamic> gpsData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/import_gps_data'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'gps_data': gpsData}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to import GPS data');
    }
  }
}
