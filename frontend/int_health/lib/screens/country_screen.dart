// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:int_health/api/api_client.dart';
import 'package:int_health/models/country.dart';
import 'package:int_health/models/travel_plan.dart';
import 'package:int_health/models/warning.dart';
import 'package:int_health/providers/data_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class CountryScreen extends StatefulWidget {
  final Country country;

  const CountryScreen({super.key, required this.country});

  @override
  CountryScreenState createState() => CountryScreenState();
}

class CountryScreenState extends State<CountryScreen> {
  List<Warning>? warnings;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchWarnings());
  }

  Future<void> _fetchWarnings() async {
    try {
      final apiClient = Provider.of<ApiClient>(context, listen: false);
      int countryId = widget.country.id;
      List<Warning> fetchedWarnings = await apiClient.fetchWarnings(countryId);
      setState(() {
        warnings = fetchedWarnings;
      });
    } catch (e) {
      debugPrint('Error fetching warnings: $e');
    }
  }


  void addCountryToTravelPlan() async {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    DateTimeRange? dateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(255, 72, 74, 77),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: const Color.fromARGB(255, 72, 74, 77),
          ),
          child: child!,
        );
      },
    );

    if (dateRange != null) {
      final travelPlan = TravelPlan(
        countryName: widget.country.countryName,
        startDate: dateRange.start,
        endDate: dateRange.end,
      );

      dataProvider.addTravelPlan(travelPlan);
    }
  }

    void _showDifferences() async {
  try {
    final apiClient = Provider.of<ApiClient>(context, listen: false);
    int countryId = widget.country.id;
    List<String> diffLines = await apiClient.fetchWarningDiff(countryId);

    // Verarbeiten der diffLines und Erzeugen von HTML-Code
    String diffHtml = diffLines.map((line) {
      if (line.startsWith('-')) {
        return '<span style="color: red;">${line.substring(1)}</span>';
      } else if (line.startsWith('+')) {
        return '<span style="color: green;">${line.substring(1)}</span>';
      } else {
        return line;
      }
    }).join('<br>');

    // Anzeigen der Differenzen in einem Dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Textänderungen'),
          content: SingleChildScrollView(
            child: SizedBox(
              width: double.maxFinite,
              child: Html(
                data: diffHtml,
                onLinkTap: (url, _, __) async {
                  if (url != null && await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url));
                  }
                },
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Schließen'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  } catch (e) {
    debugPrint('Fehler beim Abrufen der Differenzen: $e');
  }
}

  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.country.countryName),
        backgroundColor: const Color.fromARGB(255, 72, 74, 77),
        actions: [
          IconButton(
            icon: const Icon(Icons.compare_arrows),
            onPressed: _showDifferences,
            tooltip: 'Differenzen anzeigen',
          ),
        ],
      ),
      body: warnings == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: warnings!.length,
              itemBuilder: (context, index) {
                final warning = warnings![index];
                return ListTile(
                  title: Html(
                    data: warning.warningText,
                    onLinkTap: (url, _, __) async {
                      if (url != null && await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url));
                      }
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: addCountryToTravelPlan,
        backgroundColor: const Color.fromARGB(255, 72, 74, 77),
        tooltip: 'Hinzufügen zum Reiseverlauf',
        child: const Icon(Icons.add),
      ),
    );
  }
}

