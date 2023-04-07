import '../model/search_model.dart';

class StringUtils {
  static String emptyCheck(String value, {String empty = 'All'}) {
    return value.isEmpty ? empty : value;
  }

  static String filters(Search search) {
    List<String> filters = [];
    if (search.health.isNotEmpty) filters.add('Health: ${search.health}');
    if (search.dishType.isNotEmpty) filters.add('Dish: ${search.dishType}');
    if (search.mealType.isNotEmpty) filters.add('Meal: ${search.mealType}');
    return filters.isEmpty ? 'No filters' : filters.join(', ');
  }
}
