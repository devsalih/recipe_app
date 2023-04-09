import 'package:flutter/material.dart';

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
      body: CustomScrollView(
        controller: _controller,
        slivers: [
          RecipeAppBar(recipe: recipe, offset: _offset, isSliver: true),
          SliverList(
            delegate: SliverChildListDelegate([
              RecipeAppBar(recipe: recipe, offset: _offset),
              const SizedBox(height: 1000),
            ]),
          ),
        ],
      ),
    );
  }
}
