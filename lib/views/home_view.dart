import 'package:flutter/material.dart';
import 'package:mixology_cbi/controllers/home_controller.dart';
import 'package:mixology_cbi/models/item.dart';
import 'package:mixology_cbi/providers/settings_provider.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  final HomeController controller;

  HomeView({required this.controller});
  String _searchText = '';

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String _searchText = '';
  List<Item> _filteredItems = [];
  final List<Widget> _views = [HomeView(controller: HomeController())];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.controller.items;
  }

  Map<int, PaletteGenerator> _colorPalettes = {};

  Future<void> _generateColorPalette(int index) async {
    if (!_colorPalettes.containsKey(index)) {
      final item = widget.controller.items[index];
      final paletteGenerator =
          await PaletteGenerator.fromImageProvider(NetworkImage(item.image));
      setState(() {
        _colorPalettes[index] = paletteGenerator;
      });
    }
  }

  Color _getBackgroundColor(int index) {
    final palette = _colorPalettes[index];
    final backgroundColor = palette?.dominantColor?.color ?? Colors.white;
    return backgroundColor;
  }

  Color _getTextColor(Color backgroundColor) {
    final isDark = backgroundColor.computeLuminance() < 0.5;
    final textColor = isDark ? Colors.white : Colors.black;
    return textColor;
  }

  void _filterItems(String searchText) {
    setState(() {
      _searchText = searchText;
      _filteredItems = widget.controller.items.where((item) {
        final title = item.title.toLowerCase();
        return title.contains(searchText.toLowerCase());
      }).toList();
      _filteredItems.sort((a, b) {
        final aTitle = a.title.toLowerCase();
        final bTitle = b.title.toLowerCase();
        final aContains = aTitle.contains(searchText.toLowerCase());
        final bContains = bTitle.contains(searchText.toLowerCase());
        if (aContains && !bContains) {
          return -1;
        } else if (!aContains && bContains) {
          return 1;
        }
        return aTitle.compareTo(bTitle);
      });
      if (_filteredItems.isNotEmpty) {
        final matchingItemIndex =
            widget.controller.items.indexOf(_filteredItems[0]);
        if (matchingItemIndex != -1) {
          final matchingItem = _filteredItems.removeAt(0);
          _filteredItems.insert(0, matchingItem);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final settings = settingsProvider.settings;

    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(
              color: Colors.black), // Set the color of the icon to black
          backgroundColor: settings
              .backgroundColor, // Set the app bar background color to transparent
          elevation: 0, // Remove the shadow effect
          title: SizedBox(
              // Add a SizedBox with the desired image in the center
              height:
                  kToolbarHeight, // Set the height to match the app bar height
              child: Image.network(
                settings.imageUrl,
                fit: BoxFit.contain,
              ))),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search by Drink',
              ),
              onChanged: _filterItems,
            ),
          ),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(8.0),
              itemCount: _filteredItems.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 2 / 3),
              itemBuilder: (context, index) {
                _generateColorPalette(index);
                final backgroundColor = _getBackgroundColor(index);
                final textColor = _getTextColor(backgroundColor);
                final item = _filteredItems[index];
                if (_searchText.isNotEmpty) {
                  final title = item.title.toLowerCase();
                  if (!title.contains(_searchText.toLowerCase())) {
                    return const SizedBox.shrink();
                  }
                }
                return GestureDetector(
                  onTap: () => widget.controller.onTapItem(context, index),
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      children: [
                        Image.network(
                          item.image,
                          height: 100,
                          width: 100,
                        ),
                        const SizedBox(height: 8.0),
                        Flexible(
                            child: Text(
                          item.title,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor),
                          textAlign: TextAlign.center,
                        )),
                        const SizedBox(height: 8.0),
                        Expanded(
                            child: Text(
                          item.description,
                          style: TextStyle(fontSize: 14, color: textColor),
                        )),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
