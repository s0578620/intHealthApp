import 'package:flutter/material.dart';
import 'package:int_health/models/gps_data.dart';
import 'package:int_health/models/travel_plan.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = const Color.fromARGB(255, 72, 74, 77);
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    List<TravelPlan> travelPlans = dataProvider.travelPlans;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mein Profil'),
        backgroundColor: backgroundColor,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              await dataProvider.fetchGpsData();
              dataProvider.shareAllData(context);
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'GPS-Daten',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          FutureBuilder<List<GpsData>>(
            future: dataProvider.fetchGpsData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Fehler: ${snapshot.error}');
              } else if (snapshot.hasData) {
                final gpsData = snapshot.data!;
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: gpsData.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.location_on),
                      title: Text('Datum: ${gpsData[index].timestamp}'),
                      subtitle: FutureBuilder<String>(
                        future: dataProvider.getAddressFromLatLng(
                            gpsData[index].latitude, gpsData[index].longitude),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text('Ort wird geladen...');
                          } else if (snapshot.hasError) {
                            return const Text(
                                'Ort konnte nicht geladen werden');
                          } else {
                            return Text('Ort: ${snapshot.data}');
                          }
                        },
                      ),
                    );
                  },
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Keine GPS-Daten vorhanden'),
                );
              }
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Reiseplan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: travelPlans.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.flight_takeoff),
                title: Text(travelPlans[index].countryName),
                subtitle: Text(
                  '${travelPlans[index].startDate} - ${travelPlans[index].endDate}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    dataProvider.removeTravelPlan(travelPlans[index]);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
