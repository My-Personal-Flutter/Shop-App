import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

import 'add_edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = "/user-products";

  const UserProductsScreen({Key? key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Products"),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                AddEditProductScreen.routeName,
                arguments: null,
              );
            },
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      drawer: AppDrawer(
        key: UniqueKey(),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: ListView.builder(
              itemCount: productsData.items.length,
              itemBuilder: (ctx, index) => Column(
                children: [
                  UserProductItem(
                    product: productsData.items[index],
                  ),
                  const SizedBox(
                    height: 2,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(
            AddEditProductScreen.routeName,
            arguments: null,
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
