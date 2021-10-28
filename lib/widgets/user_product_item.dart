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
    final _snackbar = ScaffoldMessenger.of(context);
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
            onPressed: () async {
              try {
                Navigator.of(ctx).pop(true);
                await Provider.of<ProductsProvider>(context, listen: false)
                    .deleteProduct(product.id!);
                _snackbar.hideCurrentSnackBar();
                _snackbar.showSnackBar(const SnackBar(
                    content: Text(
                      "Product deleted successfully!",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Colors.lightGreen,
                    elevation: 6,
                    margin: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 2)));
              } catch (error) {
                //Navigator.of(ctx).pop(true);
                ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
                ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                    content: const Text(
                      "Deleting Failed!",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Theme.of(ctx).colorScheme.error,
                    elevation: 6,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 10),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2)));
              }
              // await Provider.of<ProductsProvider>(context, listen: false)
              //     .deleteProduct(product.id!)
              //     .then((value) {
              //   Navigator.of(ctx).pop(true);
              // }).catchError((error) {});
              // Navigator.of(ctx).pop(true);
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
              : Image.file(
                  File(product!.imageUrl!),
                  fit: BoxFit.cover,
                ).image,
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
