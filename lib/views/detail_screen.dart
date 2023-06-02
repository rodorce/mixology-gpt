import 'package:flutter/material.dart';
import 'package:mixology_cbi/models/item.dart';
import 'package:mixology_cbi/providers/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//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
class DetailView extends StatefulWidget {
  final Color backgroundColor;
  final Color textColor;
  final Item item;

  DetailView({
    required this.backgroundColor,
    required this.textColor,
    required this.item,
  });

  @override
  _DetailView createState() => _DetailView();
}

class _DetailView extends State<DetailView> {
  TextEditingController customIngredientsController = TextEditingController();
  String customIngredients = '';
  String generatedRecipe = '';

  Future<void> generateNewRecipe() async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer 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', // Replace with your actual API key
      },
      body: jsonEncode({
        "model": "text-davinci-003",
        'prompt':
            'Create a new drink with ${widget.item.title} and $customIngredients',
        "max_tokens": 500,
        "temperature": 0
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        generatedRecipe = data['choices'][0]['text'];
      });
    }
    print(generatedRecipe);
  }

  void acceptIngredients() {
    setState(() {
      customIngredients = customIngredientsController.text;
    });
    generateNewRecipe();
    Navigator.pop(context);
  }

  void cancelIngredients() {
    customIngredientsController.text = '';
    Navigator.pop(context);
  }

  void openInputDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Custom Ingredients'),
          content: TextField(
            controller: customIngredientsController,
            decoration: InputDecoration(
              hintText: 'Enter custom ingredients',
            ),
          ),
          actions: [
            TextButton(
              onPressed: acceptIngredients,
              child: Text('Accept'),
            ),
            TextButton(
              onPressed: cancelIngredients,
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final settings = settingsProvider.settings;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: settings.backgroundColor,
        elevation: 0,
        title: SizedBox(
          height: kToolbarHeight,
          child: Image.network(
            settings.imageUrl,
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: Container(
        color: widget.backgroundColor,
        padding: EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  widget.item.image,
                  height: 150,
                  width: 150,
                ),
                SizedBox(width: 40.0),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: widget.textColor,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        widget.item.description,
                        style: TextStyle(
                          fontSize: 18,
                          color: widget.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 40.0),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  generatedRecipe.isNotEmpty
                      ? generatedRecipe
                      : widget.item.recipe,
                  style: TextStyle(
                    fontSize: 18,
                    color: widget.textColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, bottom: 16.0),
          child: ElevatedButton(
            onPressed: openInputDialog,
            child: Text('Generate New Recipe'),
          ),
        ),
      ),
    );
  }
}
