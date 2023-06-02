import 'package:flutter/material.dart';
import 'package:mixology_cbi/models/item.dart';
import 'package:mixology_cbi/views/detail_screen.dart';
import 'package:palette_generator/palette_generator.dart';

// Controller
class WinesController {
  final List<Item> items = [
    Item(
      title: 'Robert Mondavi Private Selection Chardonnay',
      description:
          'A classic California Chardonnay with rich flavors of tropical fruit and vanilla.',
      image:
          'https://www.totalwine.com/dynamic/490x/media/sys_master/twmmedia/hfa/hd6/16704564035614.png',
      recipe: '''
Title: Mondavi Chardonnay Delight

Ingredients:

4 oz Robert Mondavi Private Selection Chardonnay
1 oz peach schnapps
1 oz fresh lemon juice
1/2 oz simple syrup
Peach slices for garnish
Ice cubes
Instructions:

In a cocktail shaker, combine Robert Mondavi Private Selection Chardonnay, peach schnapps, fresh lemon juice, and simple syrup.
Add a handful of ice cubes to the shaker and shake vigorously for about 10 seconds.
Strain the mixture into a chilled glass filled with ice cubes.
Garnish with a slice of fresh peach.
Serve and enjoy!
This recipe creates a refreshing and fruity drink that complements the flavors of the Robert Mondavi Private Selection Chardonnay. Adjust the proportions of the ingredients to suit your taste preferences. Cheers!






''',
    ),
    Item(
      title: 'Kim Crawford Sauvignon Blanc',
      description:
          'A vibrant and refreshing New Zealand Sauvignon Blanc with notes of citrus and tropical fruits.',
      image:
          'https://cdn.shopify.com/s/files/1/0589/1067/1057/products/sauvignon-blanc-1.00bca0b.png?v=1631900797',
      recipe:
          '''Certainly! Here's a recipe for a drink featuring Kim Crawford Sauvignon Blanc:

Title: Crawford Sauvignon Blanc Spritzer

Ingredients:
- 4 oz Kim Crawford Sauvignon Blanc
- 2 oz club soda
- 1 oz elderflower liqueur
- Fresh lime slices for garnish
- Ice cubes

Instructions:
1. Fill a glass with ice cubes.
2. Pour Kim Crawford Sauvignon Blanc into the glass.
3. Add elderflower liqueur and stir gently to combine.
4. Top it off with club soda.
5. Garnish with fresh lime slices.
6. Give it a light stir and serve chilled.

This recipe creates a light and refreshing spritzer that enhances the flavors of Kim Crawford Sauvignon Blanc. Feel free to adjust the proportions of the ingredients to suit your taste preferences. Enjoy!''',
    ),
    Item(
      title: 'Meiomi Pinot Noir',
      description:
          'A smooth and velvety California Pinot Noir with flavors of ripe berries and a touch of spice.',
      image:
          'https://cdn.shopify.com/s/files/1/0894/5744/products/MeiomiPinotNoir.png?v=1522122520',
      recipe:
          '''Certainly! Here's a recipe for a drink featuring Meiomi Pinot Noir:

Title: Meiomi Blackberry Smash

Ingredients:
- 4 oz Meiomi Pinot Noir
- 1 oz blackberry liqueur
- 1 oz fresh lemon juice
- 1 oz simple syrup
- 4-5 fresh blackberries
- Fresh mint leaves for garnish
- Ice cubes

Instructions:
1. In a mixing glass, muddle the fresh blackberries.
2. Add Meiomi Pinot Noir, blackberry liqueur, fresh lemon juice, and simple syrup to the mixing glass.
3. Fill the glass with ice cubes and shake well to combine the ingredients.
4. Strain the mixture into a glass filled with fresh ice cubes.
5. Garnish with fresh mint leaves.
6. Serve and enjoy the Meiomi Blackberry Smash!

This recipe combines the rich flavors of Meiomi Pinot Noir with the sweetness of blackberries and the refreshing kick of lemon juice. Adjust the sweetness level by adding more or less simple syrup according to your taste. Cheers!''',
    ),
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
