import 'dart:convert';
import 'package:flutter/material.dart';
import './product.dart';
import 'package:http/http.dart' as http;
import '../models/my_http_exception.dart';

class Products with ChangeNotifier {
  final String authToken;
  final String userId;
  List<Product> _items = [];
  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  Product findItemById(String id) {
    return items.firstWhere((item) => item.id == id);
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var fireBaseUrl =
        'https://flutter-shop-app-dc0ce.firebaseio.com/products.json?auth=$authToken&$filterString';
    final response = await http.get(fireBaseUrl);

    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    fireBaseUrl =
        'https://flutter-shop-app-dc0ce.firebaseio.com/userFavorites/$userId.json?auth=$authToken';

    final favoriteResponse = await http.get(fireBaseUrl);
    final favoriteData = json.decode(favoriteResponse.body);

    final List<Product> loadedProducts = [];

    extractedData.forEach((productId, productData) {
      loadedProducts.add(
        Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          imageUrl: productData['imageUrl'],
          isFavorite:
              favoriteData == null ? false : favoriteData[productId] ?? false,
          price: productData['price'],
        ),
      );
    });
    _items = loadedProducts;
    notifyListeners();
  }

  Future<void> addItem(Product product) async {
    final fireBaseUrl =
        'https://flutter-shop-app-dc0ce.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        fireBaseUrl,
        body: json.encode({
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'creatorId': userId
        }),
      );

      _items.add(
        Product(
            id: json.decode(response.body)['name'],
            title: product.title,
            description: product.description,
            imageUrl: product.imageUrl,
            price: product.price),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateItems(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    final fireBaseUrl =
        'https://flutter-shop-app-dc0ce.firebaseio.com/products/$id.json?auth=$authToken';
    if (prodIndex >= 0) {
      await http.patch(fireBaseUrl,
          body: json.encode({
            'title': newProduct.title,
            'price': newProduct.price,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteItem(String id) async {
    final fireBaseUrl =
        'https://flutter-shop-app-dc0ce.firebaseio.com/products/$id.json?auth=$authToken';
    final existingIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingIndex];
    _items.removeAt(existingIndex);
    notifyListeners();
    final response = await http.delete(fireBaseUrl);
    if (response.statusCode >= 400) {
      _items.insert(existingIndex, existingProduct);
      notifyListeners();

      throw MyHttpException('Cant delete the product');
    }
    existingProduct = null;
  }
}
