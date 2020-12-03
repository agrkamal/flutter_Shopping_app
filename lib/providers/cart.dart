import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;
  final String imageUrl;

  CartItem({
    this.id,
    this.title,
    this.price,
    this.imageUrl,
    this.quantity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  // int get quantity {
  //   _items;

  // }

  int get itemCount {
    return _items.length;
  }

  int get quantity {
    var totalQuantity = 0;
    _items.values.forEach((item) {
      totalQuantity += item.quantity;
    });
    return totalQuantity;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, item) {
      total += item.quantity * item.price;
    });
    return total;
  }

  void addItem(String title, double price, String id, String imageUrl) {
    if (_items.containsKey(id)) {
      _items.update(
        id,
        (item) => CartItem(
          id: item.id,
          price: item.price,
          title: item.title,
          imageUrl: item.imageUrl,
          quantity: item.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        id,
        () => CartItem(
          id: DateTime.now().toString(),
          price: price,
          title: title,
          imageUrl: imageUrl,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeSingleItem(String id) {
    if (!_items.containsKey(id)) {
      return;
    }
    if (_items[id].quantity > 1) {
      _items.update(
        id,
        (item) => CartItem(
          id: item.id,
          title: item.title,
          price: item.price,
          imageUrl: item.imageUrl,
          quantity: item.quantity - 1,
        ),
      );
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
