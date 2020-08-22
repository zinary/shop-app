import 'dart:convert';

import 'package:flutter/material.dart';
import './cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.dateTime,
      @required this.products});
}

class Order with ChangeNotifier {
  final String authToken;
  final String userId;
  List<OrderItem> _orders = [];
  Order(this.authToken, this.userId, this._orders);
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final firebaseUrl =
        'https://flutter-shop-app-dc0ce.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(firebaseUrl);
    print(response.body);
    List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  title: item['title'],
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();

    notifyListeners();
  }

  Future<void> addItem(List<CartItem> cartItems, double total) async {
    final dateNow = DateTime.now();
    final firebaseUrl =
        'https://flutter-shop-app-dc0ce.firebaseio.com/orders/$userId.json?auth=$authToken';

    final response = await http.post(
      firebaseUrl,
      body: json.encode(
        {
          'amount': total,
          'dateTime': dateNow.toIso8601String(),
          'products': cartItems
              .map((prod) => {
                    'id': prod.id,
                    'title': prod.title,
                    'price': prod.price,
                    'quantity': prod.quantity
                  })
              .toList()
        },
      ),
    );

    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            dateTime: dateNow,
            products: cartItems));

    notifyListeners();
  }
}
