import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../model/recipe_model.dart';
import '../widgets/recipe_app_bar.dart';

class RecipeDetailPage extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailPage({Key? key, required this.recipe}) : super(key: key);

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  final ScrollController _controller = ScrollController();
  double _offset = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() => _offset = _controller.offset));
  }

  @override
  Widget build(BuildContext context) {
    Recipe recipe = widget.recipe;
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _controller,
            slivers: [
              RecipeAppBar(recipe: recipe, offset: _offset, isSliver: true),
              SliverList(
                delegate: SliverChildListDelegate([
                  RecipeAppBar(recipe: recipe, offset: _offset),
                  buildNavigation(recipe),
                  buildIngredients(recipe),
                  buildWrap(recipe.dietLabels, 'Diet', Colors.green),
                  buildWrap(recipe.healthLabels, 'Health', Colors.red),
                  buildWrap(recipe.cautions, 'Cautions', Colors.orange),
                  buildWrap(recipe.cuisineType, 'Cuisine', Colors.blue),
                  buildWrap(recipe.mealType, 'Meal', Colors.purple),
                  buildWrap(recipe.dishType, 'Dish', Colors.pink),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 10),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildNavigation(Recipe recipe) {
    return ListTile(
      title: const Text(
        'Visit the source website',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: const Text(
        'For more information and instructions',
        style: TextStyle(color: Colors.grey, fontSize: 12),
      ),
      trailing: TextButton(
        onPressed: () {},
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${recipe.source} '),
            const Icon(FontAwesomeIcons.link, size: 14),
          ],
        ),
      ),
    );
  }

  Widget buildIngredients(Recipe recipe) {
    return Column(
      children: [
        ExpansionTile(
          initiallyExpanded: true,
          title: Row(
            children: [
              const Text(
                'Ingredients',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                '${recipe.ingredients.length} items',
                style: const TextStyle(color: Colors.grey),
              )
            ],
          ),
          children: [
            for (var ingredient in recipe.ingredients)
              ListTile(
                leading: ingredient.image == null
                    ? const Icon(Icons.food_bank)
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          ingredient.image!,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              alignment: Alignment.center,
                              width: 55,
                              child: const CircularProgressIndicator(),
                            );
                          },
                        ),
                      ),
                title: Text(ingredient.food),
                subtitle: Text(ingredient.text),
              ),
          ],
        ),
      ],
    );
  }

  Widget buildWrap(List<String> list, String title, Color color) {
    if (list.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        ExpansionTile(
          title: Text(
            '$title (${list.length})',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          expandedAlignment: Alignment.centerLeft,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: -10,
                children: [
                  for (var text in list)
                    Chip(
                      label: Text(text.isEmpty ? 'None' : text),
                      backgroundColor: color,
                      labelStyle: const TextStyle(color: Colors.white),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
