import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:shop_app/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductProvider>(context);
    final productList = productsData.items;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return SafeArea(
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: (ctx, index) => ProductItem(
          product: productList[index],
        ),
        itemCount: productList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 3 / 2,
          crossAxisCount: isPortrait ? 1 : 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
      ),
    );
  }
}
