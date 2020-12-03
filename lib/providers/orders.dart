import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final List<CartItem> products;
  final DateTime dateTime;
  final double amount;

  OrderItem({
    @required this.id,
    @required this.dateTime,
    @required this.amount,
    @required this.products,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  String token;
  String userId;

  Orders(this.token, this.userId, this._orders);

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://justsellapp.firebaseio.com/justsellapp/orders/$userId.json?auth=$token';
    try {
      final response = await http.get(url);
      final List<OrderItem> loadedOrders = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(
          OrderItem(
            id: orderId,
            dateTime: DateTime.parse(orderData['dateTime']),
            amount: orderData['amount'],
            products: (orderData['products'] as List<dynamic>)
                .map<CartItem>(
                  (item) => CartItem(
                    id: item['id'],
                    title: item['title'],
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
    } catch (error) {
      print(error);
    }
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addorder(double amount, List<CartItem> products) async {
    final url =
        'https://justsellapp.firebaseio.com/justsellapp/orders/$userId.json?auth=$token';
    try {
      final timeStamp = DateTime.now();
      final response = await http.post(
        url,
        body: json.encode(
          {
            'amount': amount,
            'dateTime': timeStamp.toIso8601String(),
            'products': products
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'price': cp.price,
                      'quantity': cp.quantity,
                    })
                .toList(),
          },
        ),
      );
      // _orders.insert(
      //     0,
      //     OrderItem(
      //       id: json.decode(response.body)['name'],
      //       dateTime: DateTime.now(),
      //       amount: amount,
      //       products: products,
      //     ));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
