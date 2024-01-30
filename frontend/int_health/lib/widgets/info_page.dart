import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});
  
  final String appVersion = "1.0.0";
  
  @override
  Widget build(BuildContext context) {
    Color backgroundColor = const Color.fromARGB(255, 72, 74, 77);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Über die App'),
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('intHealth App',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('Version: $appVersion'),
            const SizedBox(height: 8),
            const Text('Diese App bietet folgende Funktionen:'),
            const SizedBox(height: 8),
            const Text('- Landesspezifische Reiseinformationen'),
            const Text('- Manuelle Speicherung und Verwaltung von Reiseplänen'),
            const Text('- Export- und Teilen-Funktion für erstellte Reisepläne'),
            const Text('- Benutzerkonto-Verwaltung'),
            const Text('- Standortbezogene Dienste für personalisierte Reiseverläufe'),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            const Text('Wichtige Informationen:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Standortdaten: Bei der Anmeldung werden Standortdaten genutzt, um personalisierte Reiseverläufe zu erstellen. Diese Funktion ist nur nach erfolgreicher Registrierung und Anmeldung zugänglich.'),
          ],
        ),
      ),
    );
  }
}
