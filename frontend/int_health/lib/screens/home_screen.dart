import 'package:flutter/material.dart';
import 'package:int_health/models/country.dart';
import 'package:int_health/screens/country_screen.dart';
import 'package:int_health/screens/login_screen.dart';
import 'package:int_health/screens/profile_screen.dart';
import 'package:int_health/screens/settings_screen.dart';
import 'package:int_health/screens/travelplan_screen.dart';
import '../widgets/search_bar.dart' as search_bar;
import '../widgets/world_map.dart' as world_map;
import 'package:int_health/providers/data_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String searchTerm = '';

  @override
  void initState() {
    super.initState();
    Provider.of<DataProvider>(context, listen: false).fetchAllCountries();
  }

  void updateSearchTerm(String newTerm) {
    setState(() {
      searchTerm = newTerm.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = const Color.fromARGB(255, 72, 74, 77);
    final dataProvider = Provider.of<DataProvider>(context);
    final List<Country>? allCountries = dataProvider.allCountries;
    allCountries?.sort((a, b) => a.countryName.compareTo(b.countryName));

    final isLoggedIn = dataProvider.isLoggedIn;
    final List<Country>? filteredCountries = allCountries
        ?.where(
            (country) => country.countryName.toLowerCase().contains(searchTerm))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('intHealth'),
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: Icon(isLoggedIn ? Icons.account_circle : Icons.travel_explore),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => isLoggedIn
                    ? const ProfileScreen()
                    : const TravelPlanScreen(),
              ),
            );
          },
        ),
        actions: <Widget>[
          // Settings-Button
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          search_bar.SearchBar(updateSearchTerm: updateSearchTerm),
          Expanded(
            child: filteredCountries == null
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredCountries.length,
                    itemBuilder: (context, index) {
                      final country = filteredCountries[index];
                      return ListTile(
                        title: Text(country.countryName),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CountryScreen(country: country),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // If user is logged in -> access to world map
          if (isLoggedIn) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const world_map.WorldMap(),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          }
        },
        tooltip: isLoggedIn ? 'Weltkarte anzeigen' : 'Zum Login',
        backgroundColor: backgroundColor,
        child: Icon(isLoggedIn ? Icons.public : Icons.login_outlined),
      ),
    );
  }
}
