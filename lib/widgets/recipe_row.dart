import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/recipe_model.dart';
import '../views/recipe_detail_page.dart';

class RecipeRow extends StatelessWidget {
  final Widget? trailing;
  final Recipe recipe;

  const RecipeRow({
    Key? key,
    required this.recipe,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w600);
    const subtitleStyle = TextStyle(fontSize: 12, fontWeight: FontWeight.w300);

    Widget builder(context) => RecipeDetailPage(recipe: recipe);
    navigate() => Navigator.push(context, MaterialPageRoute(builder: builder));

    return CupertinoListTile(
      onTap: trailing == null ? navigate : null,
      title: Text(recipe.label, style: titleStyle, maxLines: 2),
      subtitle: Text('Source: ${recipe.source}', style: subtitleStyle),
      trailing: trailing,
      leadingSize: 55,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          key: ValueKey(recipe.thumbnail),
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
      ),
    );
  }
}
