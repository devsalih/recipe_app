import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../provider/recipe_provider.dart';
import '../provider/search_provider.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Search for recipes',
          icon: Icon(FontAwesomeIcons.magnifyingGlass),
        ),
        onEditingComplete: () {
          context.read<SearchProvider>().search.query = controller.text;
          context.read<RecipeProvider>().getRecipes(context.read<SearchProvider>().search);
          context.read<SearchProvider>().addSearch();
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }
}
