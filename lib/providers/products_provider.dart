import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:io' as io;

import '../main.dart';

class ProductsProvider with ChangeNotifier {
  final String? authToken;
  final String? userId;
  List<Product>? itemsProducts;

  ProductsProvider({this.authToken, this.itemsProducts, this.userId});

  List<Product> get items {
    return [...itemsProducts!];
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    var filteringString =
        filterByUser ? 'orderBy="userId"&equalTo="$userId"' : '';
    final url = Uri.parse(
        'https://shopapp-fe5db-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filteringString');
    try {
      final response = await http.get(url);
      print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if (extractedData != null) {
        var url = Uri.parse(
            "https://shopapp-fe5db-default-rtdb.firebaseio.com/userFavourites/$userId.json?auth=$authToken");

        final favouriteResponse = await http.get(url);
        final favouriteData = json.decode(favouriteResponse.body);

        extractedData.forEach((prodId, prodData) {
          if (prodData["userId"] == userId) {
            loadedProducts.insert(
              0,
              Product(
                id: prodId,
                description: prodData['description'],
                imageUrl: prodData['imageUrl'],
                price: prodData['price'],
                title: prodData['title'],
                isFavourite: favouriteData == null
                    ? false
                    : favouriteData[prodId] ?? false,
              ),
            );
          } else if (prodData['online']) {
            loadedProducts.insert(
              0,
              Product(
                id: prodId,
                description: prodData['description'],
                imageUrl: prodData['imageUrl'],
                price: prodData['price'],
                title: prodData['title'],
                isFavourite: favouriteData == null
                    ? false
                    : favouriteData[prodId] ?? false,
              ),
            );
          }
        });
        itemsProducts = loadedProducts;
      }
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        "https://shopapp-fe5db-default-rtdb.firebaseio.com/products.json?auth=$authToken");
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            "description": product.description,
            "imageUrl": product.imageUrl,
            "price": product.price,
            "title": product.title,
            "online": product.imageUrl!.startsWith("http") ? true : false,
            "userId": userId,
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
      itemsProducts!.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  List<Product> get favoriteItems {
    return itemsProducts!.where((element) => element.isFavourite).toList();
  }

  Product getProductById(String id) {
    return itemsProducts!.firstWhere((element) => element.id == id);
  }

  Future<void> updateProduct(Product product, String seletecGroupValue) async {
    final prodIndex =
        itemsProducts!.indexWhere((element) => product.id == element.id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          "https://shopapp-fe5db-default-rtdb.firebaseio.com/products/${product.id}.json?auth=$authToken");
      await http.patch(url,
          body: json.encode({
            "description": product.description,
            "imageUrl": product.imageUrl,
            "price": product.price,
            "title": product.title,
            "online": seletecGroupValue == "Online" ? true : false,
            "userId": MyApp.userId,
          }));
      itemsProducts![prodIndex] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String productId) async {
    var url = Uri.parse(
        "https://shopapp-fe5db-default-rtdb.firebaseio.com/products/$productId.json?auth=$authToken");

    final existingProductIndex =
        itemsProducts!.indexWhere((element) => element.id == productId);
    Product? existingProduct = itemsProducts![existingProductIndex];

    itemsProducts!.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url).catchError((error) {
      itemsProducts!.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("could not delete");
    });

    // final res = await http.get(url).then((response) {
    //   print(json.decode(response.body));
    //   print(response.statusCode);
    //   if (json.decode(response.body) != null) {
    //     check = true;
    //   }
    // });
    // if (check) {
    //   _items.insert(existingProductIndex, existingProduct);
    //   notifyListeners();
    //   throw HttpException("could not delete");
    // }
    // return;
  }
}
