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
  final List<String> dietLabels, healthLabels, cautions;
  final List<String> cuisineType, mealType, dishType;
  final List<Ingredient> ingredients;
  final double calories, totalWeight, totalTime;

  const Recipe({
    required this.label,
    required this.image,
    required this.source,
    required this.thumbnail,
    required this.id,
    required this.url,
    required this.shareAs,
    this.dietLabels = const [],
    this.healthLabels = const [],
    this.cautions = const [],
    this.ingredients = const [],
    this.cuisineType = const [],
    this.mealType = const [],
    this.dishType = const [],
    required this.calories,
    required this.totalWeight,
    required this.totalTime,
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
      dietLabels: json['dietLabels'].cast<String>(),
      healthLabels: json['healthLabels'].cast<String>(),
      cautions: json['cautions'].cast<String>(),
      cuisineType: json['cuisineType'].cast<String>(),
      mealType: json['mealType'].cast<String>(),
      dishType: json['dishType'].cast<String>(),
      ingredients: Ingredient.ingredientsFromJson(json['ingredients']),
      calories: json['calories'],
      totalWeight: json['totalWeight'].toDouble(),
      totalTime: json['totalTime'] ?? 0,
    );
  }
}

class Ingredient {
  final String text, food, foodCategory, foodId;
  final String? measure, image;
  final double weight, quantity;

  const Ingredient({
    required this.text,
    required this.weight,
    required this.quantity,
    required this.food,
    required this.foodCategory,
    required this.foodId,
    this.measure,
    this.image,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      text: json['text'],
      weight: json['weight'],
      image: json['image'],
      quantity: json['quantity'],
      measure: json['measure'],
      food: json['food'],
      foodCategory: json['foodCategory'],
      foodId: json['foodId'],
    );
  }

  static List<Ingredient> ingredientsFromJson(List json) {
    return json.map((ingredient) => Ingredient.fromJson(ingredient)).toList();
  }
}

class Digest {
  final String label, tag, schemaOrgTag;
  final double total, daily;
  final bool hasRDI;
  final List<Sub> sub;

  const Digest({
    required this.label,
    required this.tag,
    required this.schemaOrgTag,
    required this.total,
    required this.hasRDI,
    required this.sub,
    required this.daily,
  });

  factory Digest.fromJson(Map<String, dynamic> json) {
    return Digest(
      label: json['label'],
      tag: json['tag'],
      schemaOrgTag: json['schemaOrgTag'],
      total: json['total'],
      hasRDI: json['hasRDI'],
      sub: Sub.subFromJson(json['sub']),
      daily: json['daily'],
    );
  }

  static List<Digest> digestFromJson(List json) {
    return json.map((digest) => Digest.fromJson(digest)).toList();
  }
}

class Sub {
  final String label, tag, schemaOrgTag, unit;
  final double total, daily;
  final bool hasRDI;

  const Sub({
    required this.label,
    required this.tag,
    required this.schemaOrgTag,
    required this.total,
    required this.hasRDI,
    required this.daily,
    required this.unit,
  });

  factory Sub.fromJson(Map<String, dynamic> json) {
    return Sub(
      label: json['label'],
      tag: json['tag'],
      schemaOrgTag: json['schemaOrgTag'],
      total: json['total'],
      hasRDI: json['hasRDI'],
      daily: json['daily'],
      unit: json['unit'],
    );
  }

  static List<Sub> subFromJson(List json) {
    return json.map((sub) => Sub.fromJson(sub)).toList();
  }
}