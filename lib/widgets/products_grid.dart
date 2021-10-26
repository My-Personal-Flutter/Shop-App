import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({Key? key, @required this.isFavorite}) : super(key: key);

  final bool? isFavorite;

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final productList =
        isFavorite! ? productsData.favoriteItems : productsData.items;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    // productList.forEach((element) {
    //   print(element.id.toString());
    // });

    return SafeArea(
      child: productList.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "No Items yet - start adding some!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          : GridView.builder(
              key: UniqueKey(),
              padding: const EdgeInsets.all(16),
              itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                value: productList[index],
                child: const ProductItem(),
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
