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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    Provider.of<OrdersProvider>(context, listen: false)
        .fetchAndSetOrders()
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<OrdersProvider>(context, listen: false)
        .fetchAndSetOrders();
  }

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
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SafeArea(
                child: orderData.orders.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            "No orders yet - start ordering some!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontSize: 18,
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
      ),
    );
  }
}
