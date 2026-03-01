import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../home/data/models/product_model.dart';

abstract class FavoriteLocalDataSource {
  Future<List<ProductModel>> getFavorites();
  Future<void> saveFavorites(List<ProductModel> products);
}

class FavoriteLocalDataSourceImpl implements FavoriteLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String favoritesKey = 'CACHED_FAVORITES';

  FavoriteLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<ProductModel>> getFavorites() async {
    final jsonString = sharedPreferences.getString(favoritesKey);
    if (jsonString != null) {
      final List decodedJson = json.decode(jsonString);
      return decodedJson.map((item) => ProductModel.fromJson(item)).toList();
    }
    return [];
  }

  @override
  Future<void> saveFavorites(List<ProductModel> products) async {
    final jsonString =
        json.encode(products.map((item) => item.toJson()).toList());
    await sharedPreferences.setString(favoritesKey, jsonString);
  }
}
