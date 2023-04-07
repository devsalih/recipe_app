import 'package:flutter/material.dart';

import '../model/search_model.dart';

class SearchProvider extends ChangeNotifier {
  final List<String> query = [];
  final List<List<String>> filters = [];
  Search _search = Search();
  bool _showFilter = false;

  Search get search => _search;

  bool get showFilter => _showFilter;

  set search(Search value) {
    _search = value;
    notifyListeners();
  }

  set showFilter(bool value) {
    _showFilter = value;
    notifyListeners();
  }

  void clearHistory() {
    query.clear();
    filters.clear();
    notifyListeners();
  }

  List<Search> get history {
    return List.generate(query.length, (index) {
      return Search(
        query: query[index],
        health: filters[index][0],
        dishType: filters[index][1],
        mealType: filters[index][2],
      );
    });
  }

  void addSearch() {
    removeSearch(search);
    query.add(search.query);
    filters.add([search.health, search.dishType, search.mealType]);
    notifyListeners();
  }

  void removeSearch(Search search) {
    int index = history.indexWhere((s) => s.isEqual(search));
    if (index == -1) return;
    query.removeAt(index);
    filters.removeAt(index);
    notifyListeners();
  }
}
