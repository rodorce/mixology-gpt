import 'package:flutter/material.dart';
import 'package:mixology_cbi/controllers/home_controller.dart';
import 'package:mixology_cbi/controllers/wines_controller.dart';
import 'package:mixology_cbi/views/home_view.dart';
import 'package:mixology_cbi/views/wines_view.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _currentIndex = 0;
  List<Widget> _views = [];

  @override
  void initState() {
    super.initState();
    _views = [
      HomeView(controller: HomeController()),
      WinesView(controller: WinesController()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _views,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.local_drink),
            label: 'Beers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_bar),
            label: 'Wines',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
