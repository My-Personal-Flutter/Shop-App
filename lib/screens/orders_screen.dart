import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders_provider.dart' show OrdersProvider;
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future? _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture =
        Provider.of<OrdersProvider>(context, listen: false).fetchAndSetOrders();
  }

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<OrdersProvider>(context, listen: false)
        .fetchAndSetOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(
        key: UniqueKey(),
      ),
      appBar: AppBar(
        title: const Text("My Orders"),
        centerTitle: false,
      ),
      body: FutureBuilder(
          future: _ordersFuture,
          builder: (ctx, snapshotData) {
            if (snapshotData.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (snapshotData.error != null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "An error occured while fetching data!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                );
              } else {
                return RefreshIndicator(
                  onRefresh: () => _refreshProducts(ctx),
                  child: Consumer<OrdersProvider>(
                    builder: (ctx, orderData, child) => Container(
                        padding: const EdgeInsets.all(16),
                        child: ListView.builder(
                          itemBuilder: (ctx, index) =>
                              OrderItem(order: orderData.orders[index]),
                          itemCount: orderData.orders.length,
                        )),
                  ),
                );
              }
            }
          }),
    );
  }
}
