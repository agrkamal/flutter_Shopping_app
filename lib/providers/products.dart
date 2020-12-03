import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _products = [
    // Product(
    //   id: 'p1',
    //   title: 'Blue Chair',
    //   description: 'A blue chair - it is pretty comfrtable!',
    //   price: 2999,
    //   imageUrl:
    //       'https://atlas-content-cdn.pixelsquid.com/stock-images/armchair-arm-chair-6360XZ2-600.jpg',
    //   isFav: false,
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Canon Camera',
    //   description: 'Canon camera with super zoom lens.',
    //   price: 5999,
    //   imageUrl:
    //       'https://ph.canon/media/migration/shared/live/products/EN/powershotg1markiii-large1.png',
    //   isFav: false,
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Shampoo',
    //   description: 'The Men Company Combo of Shampoo and Hair Oil.',
    //   price: 199,
    //   imageUrl:
    //       'https://img.pngio.com/argania-hair-oil-and-shampoo-set-the-man-company-product-png-1000_1000.png',
    //   isFav: false,
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'Boston',
    //   description: 'Combo of shampoo, conditioner, hair wax.',
    //   price: 999,
    //   imageUrl:
    //       'https://i.ya-webdesign.com/images/vector-designer-creative-14.png',
    //   isFav: false,
    // ),
  ];

  final String userId;
  final String token;
  Products(this._products, this.userId, this.token);

  List<Product> get products {
    return [..._products];
  }

  List<Product> get favProd {
    return _products.where((prod) => prod.isFav).toList();
  }

  Product findById(String id) {
    return _products.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProduct([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://justsellapp.firebaseio.com/justsellapp/products.json?auth=$token&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url =
          'https://justsellapp.firebaseio.com/userFav/$userId.json?auth=$token';
      final favResponse = await http.get(url);
      final favData = json.decode(favResponse.body);
      print(json.decode(response.body).toString());
      final List<Product> loadedproduct = [];
      extractedData.forEach((prodId, prod) {
        loadedproduct.add(Product(
          id: prodId,
          title: prod['title'],
          description: prod['description'],
          price: prod['price'],
          isFav: favData == null ? false : favData[prodId] ?? false,
          imageUrl: prod['imageUrl'],
        ));
      });
      print(userId);
      _products = loadedproduct;
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://justsellapp.firebaseio.com/justsellapp/products.json?auth=$token';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFav,
          'creatorId': userId,
        }),
      );
      final newProd = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _products.add(newProd);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _products.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://justsellapp.firebaseio.com/justsellapp/products/$id.json?auth=$token';
      await http.patch(
        url,
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price,
        }),
      );
      _products[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('Can\'t update product');
      return;
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://justsellapp.firebaseio.com/justsellapp/products/$id.json?auth=$token';
    final prodIndex = _products.indexWhere((element) => element.id == id);
    var prod = _products[prodIndex];

    _products.removeAt(prodIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      print(response.statusCode);
      _products.insert(prodIndex, prod);
      notifyListeners();
      throw HttpException('Can\'t Delete Product');
    }
    prod = null;
  }
}
