import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../model/recipe_model.dart';
import '../provider/recipe_provider.dart';
import '../utils/double_utils.dart';

class RecipeAppBar extends StatelessWidget {
  final Recipe recipe;
  final double offset;
  final bool isSliver;

  const RecipeAppBar({
    Key? key,
    required this.recipe,
    this.offset = 0,
    this.isSliver = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isSliver) {
      return Row(
        children: [
          buildBackButton(context),
          Expanded(child: buildTitle()),
          buildFavoriteButton(context),
        ],
      );
    }
    return SliverAppBar(
      actions: [buildFavoriteButton(context)],
      title: buildTitle(),
      leading: buildBackButton(context),
      expandedHeight: 300,
      pinned: true,
      stretch: true,
      flexibleSpace: buildFlexibleSpace(),
    );
  }

  Widget buildBackButton(BuildContext context) {
    return translateAndFade(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.orange,
          child: IconButton(
            onPressed: Navigator.of(context).pop,
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget buildTitle() {
    return translateAndFade(
      Text(
        recipe.label,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isSliver ? Colors.white : Colors.black,
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget buildFavoriteButton(BuildContext context) {
    RecipeProvider provider = context.watch<RecipeProvider>();
    bool isFavorite = provider.isFavorite(recipe);
    return translateAndFade(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.orange,
          child: IconButton(
            onPressed: () => provider.toggleFavorite(recipe),
            icon: Icon(
              isFavorite ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  FlexibleSpaceBar buildFlexibleSpace() {
    return FlexibleSpaceBar(
      stretchModes: const [StretchMode.zoomBackground],
      title: Opacity(
        opacity: DoubleUtils.oneToZero(offset, end: 200),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Recipe from ${recipe.source}',
            style: const TextStyle(color: Colors.white, fontSize: 8),
          ),
        ),
      ),
      background: Image.network(
        recipe.image,
        width: 55,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            alignment: Alignment.center,
            width: 55,
            child: const CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget translateAndFade(Widget child) {
    double opacity = DoubleUtils.zeroToOne(offset, start: 270, end: 320);
    double offsetY = DoubleUtils.oneToZero(offset, start: 250, end: 300);
    if (!isSliver) return child;
    return Transform.translate(
      offset: Offset(0, offsetY * 50),
      child: Opacity(opacity: opacity, child: child),
    );
  }
}
