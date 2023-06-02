import 'package:flutter/material.dart';
import 'package:mixology_cbi/models/item.dart';
import 'package:mixology_cbi/views/detail_screen.dart';
import 'package:palette_generator/palette_generator.dart';

// Controller
class HomeController {
  final List<Item> items = [
    Item(
        title: 'Corona Extra',
        description:
            'A refreshing Mexican lager with a smooth, crisp taste and a touch of citrus.',
        image:
            'https://lapencavinos.com/wp-content/uploads/2019/10/corona-extra-355-ml-1.png',
        recipe: '''
Corona Extra Drink Recipe:

Ingredients:
- 1 bottle of Corona Extra
- 1 lime wedge

Instructions:
1. Take a chilled bottle of Corona Extra.
2. Open the bottle using a bottle opener.
3. Squeeze the juice of the lime wedge into the bottle.
4. Optionally, garnish the bottle with the lime wedge.
5. Enjoy your refreshing Corona Extra drink!

Note: You can also add salt to the rim of the bottle if desired.
'''),
    Item(
      title: 'Modelo Especial',
      description:
          'A classic Mexican beer with a rich, full-bodied flavor and a hint of sweetness.',
      image:
          'https://epadelivery.com.mx/images/thumbs/0000692_modelo-especial-355-ml-retornable_550.png',
      recipe: '''Modelo Especial Michelada Recipe:

Ingredients:
- 1 can or bottle of Modelo Especial
- 2 oz tomato juice
- 1/2 oz lime juice
- 1/2 oz hot sauce (such as Tabasco)
- Worcestershire sauce, to taste
- Tajin or salt, for rimming the glass
- Lime wedge, for garnish

Instructions:
1. Rim a glass with Tajin or salt by running a lime wedge around the rim and dipping it in the Tajin or salt.
2. Fill the glass halfway with ice.
3. Add tomato juice, lime juice, hot sauce, and Worcestershire sauce to the glass.
4. Stir well to combine the ingredients.
5. Open a can or bottle of Modelo Especial and pour it into the glass.
6. Gently stir to mix the beer with the other ingredients.
7. Garnish with a lime wedge.
8. Serve and enjoy your flavorful Modelo Especial Michelada!

Note: You can adjust the quantities of hot sauce, lime juice, and Worcestershire sauce according to your taste preferences.
''',
    ),
    Item(
      title: 'Pacifico',
      description:
          'A well-balanced Mexican lager with a clean, refreshing taste and a touch of maltiness.',
      image:
          'https://www.elpasospirits.com/cdn-cgi/image/quality%3D100/assets/images/cerveza-pacifico-clara-355ml.png',
      recipe:
          '''Certainly! Here's a recipe for a refreshing drink featuring Pacifico beer:

Title: Pacifico Paloma

Ingredients:
- 2 oz Pacifico beer
- 2 oz grapefruit juice
- 1 oz fresh lime juice
- 1 oz agave syrup
- Salt for rimming (optional)
- Grapefruit slice for garnish
- Ice cubes

Instructions:
1. Rim a glass with salt (optional) by running a lime wedge along the rim and dipping it in salt.
2. Fill the glass with ice cubes.
3. In a shaker, combine grapefruit juice, lime juice, and agave syrup.
4. Shake well to mix the ingredients.
5. Strain the mixture into the prepared glass over the ice.
6. Top it off with Pacifico beer.
7. Garnish with a slice of grapefruit.
8. Stir gently to combine the flavors.
9. Serve and enjoy the Pacifico Paloma!

This drink combines the crispness of Pacifico beer with the tangy flavors of grapefruit and lime, along with a touch of sweetness from agave syrup. It's a refreshing and citrusy beverage perfect for warm days or any time you want a taste of Mexico. Cheers!''',
    ),
    // Add more beers here...
  ];

  Map<int, PaletteGenerator> _colorPalettes = {};

  Future<void> generateColorPalette(int index) async {
    if (!_colorPalettes.containsKey(index)) {
      final item = items[index];
      final paletteGenerator =
          await PaletteGenerator.fromImageProvider(NetworkImage(item.image));
      _colorPalettes[index] = paletteGenerator;
    }
  }

  void onTapItem(BuildContext context, int index) async {
    final item = items[index];
    await generateColorPalette(index);
    final backgroundColor =
        _colorPalettes[index]?.dominantColor?.color ?? Colors.white;
    final textColor = _getTextColor(backgroundColor);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailView(
          backgroundColor: backgroundColor,
          textColor: textColor,
          item: item,
        ),
      ),
    );
  }

  Color _getTextColor(Color backgroundColor) {
    final isDark = backgroundColor.computeLuminance() < 0.5;
    final textColor = isDark ? Colors.white : Colors.black;
    return textColor;
  }
}
