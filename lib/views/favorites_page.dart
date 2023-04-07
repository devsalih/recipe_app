import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../model/recipe_model.dart';
import '../provider/recipe_provider.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/dismiss_background.dart';
import '../widgets/empty_row.dart';
import '../widgets/page_title.dart';
import '../widgets/recipe_row.dart';
import '../widgets/scrollable_box.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final ScrollController controller = ScrollController();
  double _offset = 0;
  bool _isEditing = false;
  final List<Recipe> _selected = [];

  @override
  void initState() {
    super.initState();
    controller.addListener(() => setState(() => _offset = controller.offset));
  }

  @override
  Widget build(BuildContext context) {
    RecipeProvider provider = context.watch<RecipeProvider>();
    List<Recipe> favorites = provider.favorites;
    return Theme(
      data: ThemeData(primarySwatch: Colors.red),
      child: Column(
        children: [
          PageTitle(
            title: 'Favorite Recipes',
            subtitle: 'Your favorite recipes',
            icon: FontAwesomeIcons.solidHeart,
            trailing: favorites.isEmpty
                ? null
                : IconButton(
                    onPressed: toggleEdit,
                    icon: const Icon(FontAwesomeIcons.solidPenToSquare),
                  ),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: _offset > 20 ? 1 : 0,
            child: Container(height: 2, color: Colors.red),
          ),
          ScrollableBox(
            color: Colors.red,
            controller: controller,
            offset: _offset,
            top: deleteSelectedButton(),
            bottom: favorites.isEmpty || _isEditing
                ? null
                : const EmptyRow(
                    hasBackground: true,
                    title: 'Swipe to remove',
                    subtitle: 'Swipe left to remove from favorites',
                    icon: FontAwesomeIcons.arrowLeftLong,
                  ),
            children: [
              if (favorites.isEmpty)
                const EmptyRow(
                  title: 'No favorites yet',
                  subtitle: 'Add some recipes to your favorites',
                  icon: FontAwesomeIcons.heartCrack,
                ),
              ...favorites.reversed.map((recipe) {
                return Dismissible(
                  key: ValueKey(recipe.id),
                  direction: _isEditing
                      ? DismissDirection.none
                      : DismissDirection.endToStart,
                  background: const DismissBackground(),
                  onDismissed: (direction) => provider.removeFavorite(recipe),
                  confirmDismiss: (direction) => confirmDismiss(recipe),
                  child: RecipeRow(recipe: recipe, trailing: trailing(recipe)),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget? deleteSelectedButton() {
    if (!_isEditing) return null;
    return ElevatedButton(
      onPressed: _selected.isEmpty ? null : removeSelected,
      child: const Text('Remove selected'),
    );
  }

  void toggleEdit() {
    _selected.clear();
    setState(() => _isEditing = !_isEditing);
  }

  Widget? trailing(Recipe recipe) {
    if (!_isEditing) return null;
    return Checkbox(
      value: _selected.contains(recipe),
      onChanged: (value) {
        if (value ?? false) {
          setState(() => _selected.add(recipe));
        } else {
          setState(() => _selected.remove(recipe));
        }
      },
    );
  }

  Future<void> removeSelected() async {
    RecipeProvider provider = context.read<RecipeProvider>();
    bool? response = await showDialog(
      context: context,
      builder: (_) => ConfirmDialog(
        title: 'Remove selected recipes from favorites',
        content:
            'Are you sure you want to ${_selected.length} recipes from your favorites?',
      ),
    );
    if (response ?? false) {
      for (var recipe in _selected) {
        provider.removeFavorite(recipe);
      }
      setState(() {
        _selected.clear();
        _isEditing = false;
      });
    }
  }

  Future<bool?> confirmDismiss(Recipe recipe) async {
    return await showDialog(
      context: context,
      builder: (_) => ConfirmDialog(
        title: 'Remove from favorites',
        content:
            'Are you sure you want to remove "${recipe.label}" from your favorites?',
      ),
    );
  }
}
