import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final authData = Provider.of<AuthProvider>(context, listen: false);
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
        child: GridTile(
          child: Stack(
            children: [
              product.imageUrl!.startsWith("http")
                  ? SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: Hero(
                        tag: product.id!,
                        child: FadeInImage.assetNetwork(
                          image: product.imageUrl!,
                          placeholder: "assets/images/avatar-black.gif",
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  // Image.network(
                  //     product.imageUrl!,
                  //     height: 200,
                  //     width: double.infinity,
                  //     fit: BoxFit.cover,
                  //     errorBuilder: (BuildContext context, Object exception,
                  //         StackTrace? stackTrace) {
                  //       return Image.asset(
                  //         "assets/images/file_not_found.png",
                  //         height: 200,
                  //         width: double.infinity,
                  //         fit: BoxFit.cover,
                  //       );
                  //     },
                  //   )
                  : SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: Hero(
                        tag: product.id!,
                        child: FadeInImage(
                            fit: BoxFit.cover,
                            placeholder: const AssetImage(
                                "assets/images/avatar-black.gif"),
                            image: Image.file(
                              File(product.imageUrl!),
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return Image.asset(
                                  "assets/images/file_not_found.png",
                                  fit: BoxFit.cover,
                                );
                              },
                            ).image),
                      ),
                    )

              // Image.file(
              //     File(product.imageUrl!),
              //     height: 200,
              //     width: double.infinity,
              //     fit: BoxFit.cover,
              //     errorBuilder: (BuildContext context, Object exception,
              //         StackTrace? stackTrace) {
              //       return Image.asset(
              //         "assets/images/file_not_found.png",
              //         height: 200,
              //         width: double.infinity,
              //         fit: BoxFit.cover,
              //       );
              //     },
              //   ),
              ,
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        ProductDetailScreen.routeName,
                        arguments: product.id,
                      );
                    },
                    splashColor:
                        Theme.of(context).primaryColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              )
            ],
          ),
          footer: GridTileBar(
              backgroundColor: Colors.black87.withOpacity(0.8),
              leading: Consumer<Product>(
                builder: (ctx, product, child) => IconButton(
                  icon: product.isFavourite
                      ? const Icon(Icons.favorite)
                      : const Icon(
                          Icons.favorite_outline_outlined,
                        ),
                  onPressed: () {
                    product.toggleFaourite(authData.token!, authData.userId!);
                  },
                  iconSize: 20,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              title: Text(
                "${product.title!}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: "Lato",
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              trailing: Consumer<CartProvider>(
                builder: (ctx, cart, ch) => IconButton(
                  icon: cart.findItemByProductId(product)
                      ? const Icon(Icons.shopping_cart)
                      : const Icon(Icons.shopping_cart_outlined),
                  onPressed: () {
                    //print(product.id);
                    cart.addItem(product);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Added product to cart!",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        elevation: 6,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 10),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                        action: SnackBarAction(
                            label: "UNDO",
                            textColor:
                                Theme.of(context).colorScheme.onSecondary,
                            onPressed: () {
                              cart.removeSingleItem(product.id!);
                            }),
                      ),
                    );
                  },
                  iconSize: 20,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )),
        ),
      ),
    );
  }
}
