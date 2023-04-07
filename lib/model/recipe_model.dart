class RecipeModel {
  final List<Recipe> recipes;

  RecipeModel({required this.recipes});

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    var list = json['hits'] as List;
    List<Recipe> recipesList = list.map((json) {
      return Recipe.fromJson(json['recipe']);
    }).toList();
    return RecipeModel(recipes: recipesList);
  }
}

class Recipe {
  final String label, image, source, thumbnail, id, url, shareAs;

  const Recipe({
    required this.label,
    required this.image,
    required this.source,
    required this.thumbnail,
    required this.id,
    required this.url,
    required this.shareAs,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      label: json['label'],
      image: json['image'],
      source: json['source'],
      thumbnail: json['images']['THUMBNAIL']['url'],
      id: json['uri'].split('recipe_').last,
      url: json['url'],
      shareAs: json['shareAs'],
    );
  }
}