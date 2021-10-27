import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/add_edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  const UserProductItem({Key? key, @required this.product}) : super(key: key);

  final Product? product;

  void checkToDelete(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          product.title!,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          "Do you want to delete the item permanently ?",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.red.withOpacity(0.8),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text(
              "No",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.green[400],
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            ),
            onPressed: () {
              Provider.of<ProductsProvider>(context, listen: false)
                  .deleteProduct(product.id!);
              Navigator.of(context).pop(true);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    "Product deleted successfully!",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  elevation: 6,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2)));
            },
            child: const Text(
              "Yes",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
      child: ListTile(
        title: Text(product!.title!),
        leading: CircleAvatar(
          backgroundImage: product!.imageUrl!.startsWith("http")
              ? NetworkImage(product!.imageUrl!)
              : ExactAssetImage(product!.imageUrl!) as ImageProvider,
        ),
        trailing: SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    AddEditProductScreen.routeName,
                    arguments: product!.id,
                  );
                },
                icon: const Icon(Icons.edit),
                color: Theme.of(context).primaryColor,
              ),
              IconButton(
                onPressed: () {
                  checkToDelete(context, product!);
                },
                icon: const Icon(Icons.delete),
                color: Theme.of(context).errorColor.withOpacity(0.85),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
