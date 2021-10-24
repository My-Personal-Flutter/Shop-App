import 'package:flutter/material.dart';
import 'package:shop_app/providers/product_provider.dart';

class CartItem {
  final String? id;
  final String? title;
  final int? quantity;
  final double? price;

  CartItem({
    @required this.id,
    @required this.price,
    @required this.quantity,
    @required this.title,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem>? _items;

  Map<String, CartItem> get items {
    return {..._items!};
  }

  void addItem(Product product) {
    if (_items!.containsKey(product.id)) {
      _items!.update(
        product.id!,
        (value) => CartItem(
          id: value.id,
          price: value.price,
          quantity: value.quantity! + 1,
          title: value.title,
        ),
      );
    } else {
      _items!.putIfAbsent(
          product.id!,
          () => CartItem(
                id: DateTime.now().toString(),
                price: product.price,
                quantity: 1,
                title: product.title,
              ));
    }
  }
}
