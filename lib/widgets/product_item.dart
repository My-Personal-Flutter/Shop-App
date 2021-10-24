import 'package:flutter/material.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key, @required this.product}) : super(key: key);

  final Product? product;

  @override
  Widget build(BuildContext context) {
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
              Image.network(
                product!.imageUrl!,
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
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        ProductDetailScreen.routeName,
                        arguments: product!.id,
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
            backgroundColor: Colors.black54,
            leading: IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () {},
              iconSize: 20,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text(
              product!.title!,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {},
              iconSize: 20,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ),
    );
  }
}
