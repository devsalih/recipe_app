import '../model/search_model.dart';

class StringUtils {
  static String emptyCheck(String value, {String empty = 'All'}) {
    return value.isEmpty ? empty : value;
  }

  static String filters(Search search) {
    List<String> filters = [];
    if (search.health != 'All') filters.add('Health: ${search.health}');
    if (search.dishType != 'All') filters.add('Dish: ${search.dishType}');
    if (search.mealType != 'All') filters.add('Meal: ${search.mealType}');
    return 'Filters: ${filters.isEmpty ? 'none' : filters.join(' | ')}';
  }

  static String capitalize(String value) {
    return value[0].toUpperCase() + value.substring(1);
  }
}
