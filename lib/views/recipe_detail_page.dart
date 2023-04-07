import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../model/recipe_model.dart';
import '../provider/recipe_provider.dart';
import '../utils/double_utils.dart';
import '../widgets/app_bar_animation.dart';

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
    RecipeProvider provider = context.watch<RecipeProvider>();
    bool isFavorite = provider.isFavorite(recipe);
    return Scaffold(
      body: CustomScrollView(
        controller: _controller,
        slivers: [
          SliverAppBar(
            actions: [
              AppBarAnimation(
                offset: _offset,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: IconButton(
                      onPressed: () async {},
                      icon: const Icon(
                        FontAwesomeIcons.solidHeart,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
            title: AppBarAnimation(
              offset: _offset,
              child: Text(
                recipe.label,
                style: const TextStyle(color: Colors.white),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
            leading: AppBarAnimation(
              offset: _offset,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
              ),
            ),
            expandedHeight: 300,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              title: Opacity(
                opacity: DoubleUtils.oneToZero(_offset, end: 200),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 20),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      recipe.label,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: IconButton(
                        onPressed: () {
                          if (isFavorite) {
                            provider.removeFavorite(recipe);
                          } else {
                            provider.addFavorite(recipe);
                          }
                        },
                        icon: Icon(
                          isFavorite
                              ? FontAwesomeIcons.solidHeart
                              : FontAwesomeIcons.heart,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 1000),
            ]),
          ),
        ],
      ),
    );
  }
}
