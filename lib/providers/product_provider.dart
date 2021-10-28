import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class Product with ChangeNotifier {
  final String? id;
  final String? title;
  final String? description;
  final double? price;
  final String? imageUrl;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    @required this.title,
    this.isFavourite = false,
  });

  Future<void> toggleFaourite() async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    var url = Uri.parse(
        "https://shopapp-fe5db-default-rtdb.firebaseio.com/products/$id.json");
    try {
      await http.patch(
        url,
        body: json.encode(
          {
            "isFavourite": isFavourite,
          },
        ),
      );
    } catch (error) {
      isFavourite = oldStatus;
      notifyListeners();
    }
  }
}
