import 'package:flutter/material.dart';
import 'package:int_health/providers/data_provider.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _passwordResetController = TextEditingController();
  bool _isLoading = false;

  void _register() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorDialog('Passwörter stimmen nicht überein');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    bool isSuccess = await dataProvider.register(_usernameController.text,
        _passwordController.text, _passwordResetController.text);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erfolgreich registriert')),
        );
        // user gets back to Login Screen
        Navigator.of(context).pop();
      } else {
        _showErrorDialog('Registrierung fehlgeschlagen');
      }
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
        title: const Text("Registrieren"),
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
                  TextField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(
                        labelText: 'Passwort wiederholen'),
                    obscureText: true,
                  ),
                  TextField(
                    controller: _passwordResetController,
                    decoration:
                        const InputDecoration(labelText: 'Reset Password Code'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 11),
                  ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Icon(
                      Icons.app_registration_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
