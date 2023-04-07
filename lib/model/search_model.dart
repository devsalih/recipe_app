class Search {
  String query, health, dishType, mealType;

  Search({
    this.query = '',
    this.health = '',
    this.dishType = '',
    this.mealType = '',
  });

  bool isEqual(Search search) {
    return query == search.query &&
        health == search.health &&
        dishType == search.dishType &&
        mealType == search.mealType;
  }
  int findIndex(List<Search> list) => list.indexWhere((s) => isEqual(s));
  bool isExist(List<Search> list) => findIndex(list) != -1;
}
