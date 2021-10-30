import 'package:flutter/material.dart';
import 'package:shop_app/main.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String? id;
  final double? amount;
  final List<CartItem>? products;
  final DateTime? dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.dateTime,
    @required this.products,
  });
}

class OrdersProvider with ChangeNotifier {
  final String? authToken;
  List<OrderItem>? itemsOrders;

  OrdersProvider({this.authToken, this.itemsOrders});

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        "https://shopapp-fe5db-default-rtdb.firebaseio.com/orders.json?auth=$authToken");

    final response = await http.get(url);
    final List<OrderItem> loadedOrderedItems = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    if (extractedData != null) {
      extractedData.forEach(
        (key, value) {
          if (value['userId'] == MyApp.userId) {
            loadedOrderedItems.insert(
              0,
              OrderItem(
                id: key,
                amount: value['amount'],
                dateTime: DateTime.parse(value['dateTime']),
                products: (value['products'] as List<dynamic>)
                    .map((item) => CartItem(
                        id: item['id'],
                        price: item["price"],
                        quantity: item['quantity'],
                        title: item["title"]))
                    .toList(),
              ),
            );
          }
        },
      );
      itemsOrders = loadedOrderedItems;
      notifyListeners();
    }
  }

  List<OrderItem> get orders {
    return [...itemsOrders!];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        "https://shopapp-fe5db-default-rtdb.firebaseio.com/orders.json?auth=$authToken");
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        "userId": MyApp.userId,
        "amount": total,
        "dateTime": timestamp.toIso8601String(),
        'products': cartProducts
            .map((e) => {
                  "id": e.id,
                  "title": e.title,
                  "quantity": e.quantity,
                  "price": e.price,
                })
            .toList(),
      }),
    );
    itemsOrders!.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: DateTime.now(),
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
