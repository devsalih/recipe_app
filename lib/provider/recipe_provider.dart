import 'package:flutter/material.dart';

import '../model/recipe_model.dart';
import '../model/search_model.dart';
import '../services/recipe_service.dart';

class RecipeProvider with ChangeNotifier {
  final RecipeService recipeService = RecipeService();
  final List<Recipe> _recipes = [];
  final List<Recipe> _favorites = [];
  Recipe? _randomRecipe;
  bool _isSearching = false;
  bool _noResult = false;
  String? _nextUrl;

  bool get isSearching => _isSearching;
  bool get noResult => _noResult;
  String? get nextUrl => _nextUrl;
  Recipe get randomRecipe => _randomRecipe!;

  set noResult(bool value) {
    _noResult = value;
    notifyListeners();
  }

  set isSearching(bool value) {
    _isSearching = value;
    notifyListeners();
  }

  set randomRecipe(Recipe value) {
    _randomRecipe = value;
    notifyListeners();
  }

  List<Recipe> get recipes => _recipes;
  List<Recipe> get favorites => _favorites;

  Future<void> getMoreRecipes() async {
    if(_nextUrl == null) return;
    isSearching = true;
    RecipeModel? model = await recipeService.getMoreRecipes(_nextUrl!);
    addRecipes(model?.recipes);
    _nextUrl = recipeService.nextUrl;
    isSearching = false;
    notifyListeners();
  }

  Future<void> getRecipes(Search search) async {
    clearRecipes();
    isSearching = true;
    noResult = false;
    RecipeModel? model = await recipeService.getRecipes(search);
    addRecipes(model?.recipes);
    _nextUrl = recipeService.nextUrl;
    if(recipes.isEmpty) noResult = true;
    isSearching = false;
    notifyListeners();
  }

  Future<void> getRandomRecipe(String mealType) async {
    isSearching = true;
    Recipe? recipe = await recipeService.getRandomRecipe(mealType);
    if(recipe == null) return getRandomRecipe(mealType);
    randomRecipe = recipe;
    isSearching = false;
    notifyListeners();
  }

  void addRecipes(List<Recipe>? recipes) {
    if(recipes == null) return;
    _recipes.addAll(recipes);
    isSearching = false;
    notifyListeners();
  }

  void clearRecipes() {
    _recipes.clear();
    notifyListeners();
  }

  void addFavorite(Recipe recipe) {
    _favorites.add(recipe);
    notifyListeners();
  }

  void removeFavorite(Recipe recipe) {
    _favorites.remove(recipe);
    notifyListeners();
  }

  void toggleFavorite(Recipe recipe) {
    if(isFavorite(recipe)) {
      removeFavorite(recipe);
    } else {
      addFavorite(recipe);
    }
  }

  bool isFavorite(Recipe recipe) => _favorites.contains(recipe);
}