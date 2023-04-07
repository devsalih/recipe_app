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

class RecipesPage extends StatefulWidget {
  const RecipesPage({Key? key}) : super(key: key);

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  final ScrollController controller = ScrollController();
  double _offset = 0;

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
                onPressed: () {},
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
                  ? EmptyRow(
                      hasBackground: true,
                      title: provider.isSearching
                          ? 'Searching...'
                          : 'Load more recipes',
                      subtitle: provider.isSearching
                          ? 'Please wait'
                          : 'Tap to load more recipes',
                      icon: provider.isSearching
                          ? FontAwesomeIcons.spinner
                          : FontAwesomeIcons.plus,
                      onTap: provider.getMoreRecipes,
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
                if (provider.isSearching && recipes.isEmpty)
                  const EmptyRow(
                    title: 'Searching...',
                    subtitle: 'Please wait',
                    icon: FontAwesomeIcons.spinner,
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
      ],
    );
  }
}
