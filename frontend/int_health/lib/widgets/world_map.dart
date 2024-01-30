import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:int_health/providers/data_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../models/gps_data.dart';

class WorldMap extends StatefulWidget {
  const WorldMap({Key? key}) : super(key: key);

  @override
  WorldMapState createState() => WorldMapState();
}

class WorldMapState extends State<WorldMap> {
  List<Marker> markers = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserGpsData();
  }

  void _loadUserGpsData() async {
    final isLoggedIn =
        Provider.of<DataProvider>(context, listen: false).isLoggedIn;
    if (isLoggedIn) {
      try {
        List<GpsData> userGpsData =
            await Provider.of<DataProvider>(context, listen: false)
                .fetchGpsData();
        setState(() {
          markers = userGpsData
              .map((data) => Marker(
                    width: 80.0,
                    height: 80.0,
                    point: LatLng(data.latitude, data.longitude),
                    builder: (ctx) =>
                        const Icon(Icons.location_on, color: Colors.red),
                  ))
              .toList();
        });
      } catch (e) {
        setState(() {
          errorMessage = "Fehler beim Laden der GPS-Daten: $e";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = const Color.fromARGB(255, 72, 74, 77);
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('World Map'),
        backgroundColor: backgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => dataProvider.shareAllData(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(20.0, 0.0),
                zoom: 1.5,
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayerOptions(markers: markers),
              ],
            ),
          ),
          if (errorMessage != null)
            Positioned(
              top: 20,
              left: 20,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.redAccent,
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
