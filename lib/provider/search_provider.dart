import 'package:flutter/material.dart';

import '../model/search_model.dart';
import '../utils/string_utils.dart';

class SearchProvider extends ChangeNotifier {
  final List<Search> _history = [];
  bool _showFilter = false;
  String _query = '', _health = '', _dishType = '', _mealType = '';

  String get query => _query;

  String get health => StringUtils.emptyCheck(_health);

  String get dishType => StringUtils.emptyCheck(_dishType);

  String get mealType => StringUtils.emptyCheck(_mealType);

  int get filterCount => [health, dishType, mealType]
      .where((element) => element != 'All')
      .length;

  set query(String value) {
    _query = value;
    notifyListeners();
  }

  set health(String value) {
    _health = value;
    notifyListeners();
  }

  set dishType(String value) {
    _dishType = value;
    notifyListeners();
  }

  set mealType(String value) {
    _mealType = value;
    notifyListeners();
  }

  Search get search => Search(
        query: query,
        health: health,
        dishType: dishType,
        mealType: mealType,
      );

  void clearFilters() {
    health = '';
    dishType = '';
    mealType = '';
  }

  List<Search> get history => _history;

  void addSearch() {
    removeSearch(search);
    _history.insert(0, search);
    notifyListeners();
  }

  void removeSearch(Search search) {
    int index = history.indexWhere((s) => s.isEqual(search));
    if (index == -1) return;
    _history.removeAt(index);
    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
    notifyListeners();
  }

  List<String> get healthLabels => [
        'All',
        'alcohol-cocktail',
        'alcohol-free',
        'celery-free',
        'crustacean-free',
        'dairy-free',
        'DASH',
        'egg-free',
        'fish-free',
        'fodmap-free',
        'gluten-free',
        'immuno-supportive',
        'keto-friendly',
        'kidney-friendly',
        'kosher',
        'low-fat-abs',
        'low-potassium',
        'low-sugar',
        'lupine-free',
        'Mediterranean',
        'mollusk-free',
        'mustard-free',
        'no-oil-added',
        'paleo',
        'peanut-free',
        'pescatarian',
        'pork-free',
        'red-meat-free',
        'sesame-free',
        'shellfish-free',
        'soy-free',
        'sugar-conscious',
        'sulfite-free',
        'tree-nut-free',
        'vegan',
        'vegetarian',
        'wheat-free',
      ];

  List<String> get dishTypes => [
        'All',
        'Bread',
        'Cereals',
        'Desserts',
        'Drinks',
        'Pancake',
        'Preps',
        'Preserve',
        'Salad',
        'Sandwiches',
        'Soup',
        'Starter',
        'Sweets'
      ];

  List<String> get mealTypes =>
      ['All', 'Breakfast', 'Dinner', 'Lunch', 'Snack', 'Teatime'];

  bool get showFilter => _showFilter;

  set showFilter(bool value) {
    _showFilter = value;
    notifyListeners();
  }

  void closeFilter() {
    _showFilter = false;
    notifyListeners();
  }

  void openFilter() {
    _showFilter = true;
    notifyListeners();
  }

  void toggleFilter() {
    _showFilter = !_showFilter;
    notifyListeners();
  }
}
