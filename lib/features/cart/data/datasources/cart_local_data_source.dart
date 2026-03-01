import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item_model.dart';

abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<void> saveCartItems(List<CartItemModel> items);
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String cartKey = 'CACHED_CART';

  CartLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<CartItemModel>> getCartItems() async {
    final jsonString = sharedPreferences.getString(cartKey);
    if (jsonString != null) {
      final List decodedJson = json.decode(jsonString);
      return decodedJson.map((item) => CartItemModel.fromJson(item)).toList();
    }
    return [];
  }

  @override
  Future<void> saveCartItems(List<CartItemModel> items) async {
    final jsonString = json.encode(items.map((item) => item.toJson()).toList());
    await sharedPreferences.setString(cartKey, jsonString);
  }
}
