import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';

import '../model/recipe_model.dart';
import '../model/search_model.dart';

class RecipeService {
  final String _baseUrl = 'https://api.edamam.com/api/recipes/v2';
  final Dio _dio = Dio();
  late String? _nextUrl;

  String? get nextUrl => _nextUrl;

  Future<RecipeModel?> getMoreRecipes(String url) async {
    final response = await _dio.get(url);
    if (response.statusCode == 200) {
      final jsonBody = response.data;
      if (jsonBody is Map<String, dynamic>) {
        _nextUrl = jsonBody['_links']['next']?['href'];
        return RecipeModel.fromJson(jsonBody);
      }
    }
    return null;
  }

  Future<RecipeModel?> getRecipes(Search search) async {
    Map<String, dynamic> params = {
      'type': 'public',
      'app_id': dotenv.env['APP_ID'],
      'app_key': dotenv.env['APP_KEY'],
    };
    if (search.query.isNotEmpty) params['q'] = search.query;
    if (search.health != 'All') params['health'] = search.health;
    if (search.mealType != 'All') params['mealType'] = search.mealType;
    if (search.dishType != 'All') params['dishType'] = search.dishType;
    print(params);
    final response = await _dio.get(_baseUrl, queryParameters: params);

    if (response.statusCode == 200) {
      final jsonBody = response.data;
      if (jsonBody is Map<String, dynamic>) {
        _nextUrl = jsonBody['_links']['next']?['href'];
        return RecipeModel.fromJson(jsonBody);
      }
    }
    return null;
  }
}
