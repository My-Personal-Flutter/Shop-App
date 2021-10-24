import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = "/product-detail";

  const ProductDetailScreen({Key? key}) : super(key: key);

  // final Product? product;

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final product = Provider.of<ProductProvider>(
      context,
      listen: false,
    ).getProductById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title!),
      ),
    );
  }
}
