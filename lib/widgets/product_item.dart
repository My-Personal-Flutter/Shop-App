import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

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
                product.imageUrl!,
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
              backgroundColor: Colors.black54,
              leading: Consumer<Product>(
                builder: (ctx, product, child) => IconButton(
                  icon: product.isFavourite
                      ? const Icon(Icons.favorite)
                      : const Icon(
                          Icons.favorite_outline_outlined,
                        ),
                  onPressed: () {
                    product.toggleFaourite();
                  },
                  iconSize: 20,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              title: Text(
                product.title!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: "Lato",
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              trailing: Consumer<Cart>(
                builder: (ctx, cart, ch) => IconButton(
                  icon: cart.findItemByProductId(product)
                      ? const Icon(Icons.shopping_cart)
                      : const Icon(Icons.shopping_cart_outlined),
                  onPressed: () {
                    cart.addItem(product);
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
