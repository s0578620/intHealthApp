import 'package:flutter/material.dart';
import 'package:int_health/providers/data_provider.dart';
import 'package:int_health/widgets/info_page.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  void _logout() async {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    await dataProvider.logout();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Erfolgreich abgemeldet')),
    );

    // back to Home Screen
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    Color backgroundColor = const Color.fromARGB(255, 72, 74, 77);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Einstellungen"),
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              if (dataProvider.isLoggedIn)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: _logout,
                  child: const Text(
                    "Abmelden",
                    style: TextStyle(
                        color: Colors.red),
                  ),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const InfoPage(),
                  ));
                },
                child: const Icon(
                  Icons.info_outlined, 
                  color: Colors.white, 
                ),
              ),
              // Andere Einstellungselemente
            ],
          ),
        ),
      ),
    );
  }
}
