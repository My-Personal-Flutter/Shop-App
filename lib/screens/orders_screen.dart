import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders_provider.dart' show OrdersProvider;
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrdersProvider>(context);

    return Scaffold(
      drawer: AppDrawer(
        key: UniqueKey(),
      ),
      appBar: AppBar(
        title: const Text("My Orders"),
        centerTitle: false,
      ),
      body: SafeArea(
        child: orderData.orders.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "No orders yet - start ordering some!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              )
            : Container(
                padding: const EdgeInsets.all(16),
                child: ListView.builder(
                  itemBuilder: (ctx, index) =>
                      OrderItem(order: orderData.orders[index]),
                  itemCount: orderData.orders.length,
                ),
              ),
      ),
    );
  }
}
