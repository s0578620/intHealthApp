import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'api/api_client.dart';
import 'providers/data_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<ApiClient>(
          //create: (_) => ApiClient('http://127.0.0.1:5000'),  // Apple 
          create: (_) => ApiClient('http://10.0.2.2:5000'),     // Android
        ),
        ChangeNotifierProvider(
          create: (context) => DataProvider(context.read<ApiClient>()),
        ),
      ],
      child: const MaterialApp(
        home: HomeScreen(),
      ),
    ),
  );
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    Provider.of<DataProvider>(context, listen: false).fetchAllCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('intHealth'),
      ),
      body: const Center(
        child: Text('Welcome to intHealth!'),
      ),
    );
  }
}
