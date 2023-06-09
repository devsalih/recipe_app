import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../model/recipe_model.dart';
import '../provider/recipe_provider.dart';
import '../widgets/empty_row.dart';
import '../widgets/filter_button.dart';
import '../widgets/page_title.dart';
import '../widgets/recipe_row.dart';
import '../widgets/scrollable_box.dart';
import '../widgets/search_bar.dart';
import 'recipe_detail_page.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({Key? key}) : super(key: key);

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  final ScrollController controller = ScrollController();
  double _offset = 0;
  bool _showMenu = false;

  @override
  void initState() {
    super.initState();
    controller.addListener(() => setState(() => _offset = controller.offset));
  }

  @override
  Widget build(BuildContext context) {
    RecipeProvider provider = context.watch<RecipeProvider>();
    List<Recipe> recipes = provider.recipes;
    return Stack(
      children: [
        Column(
          children: [
            PageTitle(
              title: 'Recipe App',
              subtitle: 'Find your favorite recipes',
              icon: FontAwesomeIcons.utensils,
              trailing: IconButton(
                onPressed: () => setState(() => _showMenu = true),
                icon: const Icon(FontAwesomeIcons.dice),
              ),
            ),
            const SearchBar(),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _offset > 20 ? 1 : 0,
              child: Container(height: 2, color: Colors.orange),
            ),
            ScrollableBox(
              color: Colors.orange,
              controller: controller,
              offset: _offset,
              floatingActionButton: const FilterButton(),
              bottom: provider.nextUrl != null && recipes.isNotEmpty
                  ? Opacity(
                      opacity: provider.isSearching ? 0 : 1,
                      child: EmptyRow(
                        hasBackground: true,
                        title: 'Load more recipes',
                        subtitle: 'Tap to load more recipes',
                        icon: FontAwesomeIcons.plus,
                        onTap: provider.getMoreRecipes,
                      ),
                    )
                  : null,
              children: [
                if (recipes.isEmpty &&
                    !provider.isSearching &&
                    !provider.noResult)
                  const EmptyRow(
                    title: 'Search for recipes',
                    subtitle: 'Type in the search bar above',
                    icon: FontAwesomeIcons.arrowUp,
                  ),
                if (provider.noResult)
                  const EmptyRow(
                    title: 'No recipes found',
                    subtitle: 'Try searching for something else',
                    icon: FontAwesomeIcons.magnifyingGlass,
                  ),
                ...List.generate(
                  recipes.length,
                  (index) => RecipeRow(recipe: recipes[index]),
                ),
              ],
            ),
          ],
        ),
        if (provider.isSearching)
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Searching for recipes...'),
                ],
              ),
            ),
          ),
        IgnorePointer(
          ignoring: !_showMenu,
          child: Stack(
            children: [
              GestureDetector(
                onTap: () => setState(() => _showMenu = false),
                child: Container(color: Colors.transparent),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _showMenu ? 1 : 0,
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 200),
                  scale: _showMenu ? 1 : 1.1,
                  child: RandomRecipeMenu(onTap: (String mealType) async {
                    setState(() => _showMenu = false);
                    await provider.getRandomRecipe(mealType).then((value) {
                      Recipe recipe = provider.randomRecipe;
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return RecipeDetailPage(recipe: recipe);
                        }),
                      );
                    });
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RandomRecipeMenu extends StatefulWidget {
  final void Function(String mealType) onTap;

  const RandomRecipeMenu({Key? key, required this.onTap}) : super(key: key);

  @override
  State<RandomRecipeMenu> createState() => _RandomRecipeMenuState();
}

class _RandomRecipeMenuState extends State<RandomRecipeMenu> {
  String _value = 'Dinner';

  @override
  Widget build(BuildContext context) {
    RecipeProvider provider = context.watch<RecipeProvider>();
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: 250,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Get a random recipe',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              ...['Breakfast', 'Lunch', 'Dinner', 'Snack', 'Teatime'].map((e) {
                return RadioMenuButton(
                  value: e,
                  groupValue: _value,
                  onChanged: (value) =>
                      setState(() => _value = value as String),
                  child: Text(e),
                );
              }).toList(),
              const Divider(),
              ElevatedButton(
                onPressed: () => widget.onTap(_value),
                child: const Text('Get Random Recipe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
