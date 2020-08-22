import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/my_http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String imageUrl;
  final String description;
  final double price;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.imageUrl,
      @required this.price,
      this.isFavorite = false});

  Future<void> toggleFavorite(
      String productId, String userId, String authToken) async {
    var oldIsFavorite = isFavorite;

    void revertFavoriteStatus() {
      isFavorite = oldIsFavorite;
      notifyListeners();
      throw MyHttpException('cant change favorite');
    }

    isFavorite = !isFavorite;
    notifyListeners();

    var fireBaseUrl =
        'https://flutter-shop-app-dc0ce.firebaseio.com/userFavorites/$userId/$productId.json?auth=$authToken';

    try {
      final response = await http.put(
        fireBaseUrl,
        body: json.encode(
          isFavorite,
        ),
      );

      if (response.statusCode >= 400) {
        revertFavoriteStatus();
      }
    } catch (error) {
      print('error');
      print(error);
      revertFavoriteStatus();
    }
    oldIsFavorite = null;
  }
}
