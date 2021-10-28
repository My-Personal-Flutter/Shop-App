import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:io' as io;

import '../main.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse(
        "https://shopapp-fe5db-default-rtdb.firebaseio.com/products.json");
    try {
      final response = await http.get(url);
      print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        if (prodData['userId'] == MyApp.userId) {
          loadedProducts.insert(
            0,
            Product(
                id: prodId,
                description: prodData['description'],
                imageUrl: prodData['imageUrl'],
                price: prodData['price'],
                title: prodData['title'],
                isFavourite: prodData['isFavourite']),
          );
        } else if (prodData['online'] == true) {
          loadedProducts.insert(
            0,
            Product(
                id: prodId,
                description: prodData['description'],
                imageUrl: prodData['imageUrl'],
                price: prodData['price'],
                title: prodData['title'],
                isFavourite: prodData['isFavourite']),
          );
        }
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        "https://shopapp-fe5db-default-rtdb.firebaseio.com/products.json");
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            "description": product.description,
            "imageUrl": product.imageUrl,
            "price": product.price,
            "title": product.title,
            "isFavourite": product.isFavourite,
            "online": product.imageUrl!.startsWith("http") ? true : false,
            "userId": MyApp.userId,
          },
        ),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
        title: product.title,
      );
      _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavourite).toList();
  }

  Product getProductById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> updateProduct(Product product, String seletecGroupValue) async {
    final prodIndex = _items.indexWhere((element) => product.id == element.id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          "https://shopapp-fe5db-default-rtdb.firebaseio.com/products/${product.id}.json");
      await http.patch(url,
          body: json.encode({
            "description": product.description,
            "imageUrl": product.imageUrl,
            "price": product.price,
            "title": product.title,
            "online": seletecGroupValue == "Online" ? true : false,
            "userId": MyApp.userId,
          }));
      _items[prodIndex] = product;
      notifyListeners();
    }
  }

  void deleteProduct(String productId) {
    _items.removeWhere((element) => element.id == productId);
    notifyListeners();
  }
}
