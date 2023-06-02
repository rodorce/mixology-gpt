import 'package:flutter/material.dart';
import 'package:mixology_cbi/controllers/home_controller.dart';
import 'package:mixology_cbi/providers/settings_provider.dart';
import 'package:mixology_cbi/views/main_view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => SettingsProvider(), // Create an instance of SettingsProvider
    child: MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  final HomeController controller = HomeController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Table View',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainView(),
    );
  }
}
