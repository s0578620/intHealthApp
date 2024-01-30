import 'package:flutter/material.dart';
import 'package:int_health/models/travel_plan.dart';
import 'package:int_health/providers/data_provider.dart';
import 'package:provider/provider.dart';

class TravelPlanScreen extends StatefulWidget {
  const TravelPlanScreen({Key? key}) : super(key: key);

  @override
  TravelPlanScreenState createState() => TravelPlanScreenState();
}

class TravelPlanScreenState extends State<TravelPlanScreen> {
  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    List<TravelPlan> travelPlans = dataProvider.travelPlans;
    Color backgroundColor = const Color.fromARGB(255, 72, 74, 77);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mein Reiseverlauf'),
        backgroundColor: backgroundColor,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              dataProvider.shareTravelPlans();
            },
          ),
        ],
      ),
      body: travelPlans.isEmpty
          ? const Center(child: Text('Keine Reisepläne hinzugefügt.'))
          : ListView.builder(
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
    );
  }
}
