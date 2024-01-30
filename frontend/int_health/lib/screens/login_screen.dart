import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:int_health/providers/data_provider.dart';
import 'package:provider/provider.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

void _login() async {
  setState(() {
    _isLoading = true;
  });

  Position? currentPosition;

  LocationPermission permission = await Geolocator.requestPermission();
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    // Berechtigung verweigert oder dauerhaft verweigert
    _showErrorDialog("Standortberechtigung wurde verweigert. Bitte erlauben Sie den Zugriff, um fortzufahren.");
    setState(() {
      _isLoading = false;
    });
    return; // Stop further execution if permission is denied
  }

  try {
    currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  } catch (e) {
    _showErrorDialog("Fehler beim Abrufen des Standorts: $e");
    setState(() {
      _isLoading = false;
    });
    return; // Stop further execution if location can't be obtained
  }

  try {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    
    bool isSuccess = await dataProvider.login(
      _usernameController.text,
      _passwordController.text,
      currentPosition,
    );

    if (isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erfolgreich angemeldet')),
      );
      Navigator.of(context).pop(); // Or navigate to the home screen
    } else {
      _showErrorDialog('Login fehlgeschlagen');
    }
  } on DioError catch (e) {
    if (e.response?.statusCode == 401) {
      // Handle 401 error specifically
      _showErrorDialog('Nicht autorisiert. Bitte überprüfen Sie Ihre Anmeldedaten.');
    } else {
      _showErrorDialog('Ein Fehler ist aufgetreten: ${e.message}');
    }
  } catch (e) {
    _showErrorDialog('Ein unerwarteter Fehler ist aufgetreten: $e');
  }

  if (mounted) {
    setState(() {
      _isLoading = false;
    });
  }
}


  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ein Fehler ist aufgetreten'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = const Color.fromARGB(255, 72, 74, 77);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: <Widget>[
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: 'Username'),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Passwort'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 11),
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Icon(
                      Icons.login_outlined, // Das Login-Symbol
                      color: Colors.white, // Farbe des Symbols
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegistrationScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Noch keinen Account? Registrieren',
                      style: TextStyle(color: Colors.black,),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
