import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:shop_app/screens/add_edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  const UserProductItem({Key? key, @required this.product}) : super(key: key);

  final Product? product;

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
                onPressed: () {},
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
