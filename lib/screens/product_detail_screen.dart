import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/products_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = "/product-detail";

  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  var quantity = 0;
  var check = false;

  @override
  void initState() {}

  @override
  void didChangeDependencies() {
    if (check == false) {
      final productId = ModalRoute.of(context)!.settings.arguments as String;
      if (Provider.of<CartProvider>(context, listen: false)
          .findByProductId(productId)) {
        quantity = Provider.of<CartProvider>(context, listen: false)
            .getProductQuantity(productId);
      }
    }
    check = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final product = Provider.of<ProductsProvider>(
      context,
      listen: false,
    ).getProductById(productId);
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(product.title!),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 300,
              child: product.imageUrl!.startsWith("http")
                  ? Image.network(
                      product.imageUrl!,
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Image.asset(
                          "assets/images/no_connection.png",
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.file(
                      File(product.imageUrl!),
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Image.asset(
                          "assets/images/no_connection.png",
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
            ),
            const SizedBox(
              height: 24,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$${product.price}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  quantity > 0
                      ? Row(
                          children: [
                            RawMaterialButton(
                              onPressed: () {
                                setState(() {
                                  cart.deleteItem(product.id!);
                                  quantity = quantity - 1;
                                });
                              },
                              elevation: 2.0,
                              fillColor: Colors.white,
                              child: const Icon(
                                Icons.remove,
                                size: 24.0,
                              ),
                              shape: CircleBorder(),
                            ),
                            Text(quantity.toString()),
                            RawMaterialButton(
                              onPressed: () {
                                setState(() {
                                  cart.addItem(product);
                                  quantity = quantity + 1;
                                });
                              },
                              elevation: 2.0,
                              fillColor: Colors.white,
                              child: const Icon(
                                Icons.add,
                                size: 24.0,
                              ),
                              shape: CircleBorder(),
                            ),
                          ],
                        )
                      : ElevatedButton(
                          onPressed: () {
                            setState(() {
                              cart.addItem(product);
                              quantity = quantity + 1;
                            });
                          },
                          child: Text("Add to Cart"),
                        )
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              width: double.infinity,
              child: Text(
                product.description!,
                softWrap: true,
                style: TextStyle(
                  color: Colors.grey[700],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
