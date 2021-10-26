import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import '../providers/cart_provider.dart' as CI show CartItem;

class CartItem extends StatelessWidget {
  const CartItem({
    Key? key,
    @required this.itemId,
    @required this.cartItem,
  }) : super(key: key);

  final CI.CartItem? cartItem;
  final String? itemId;

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductsProvider>(context, listen: false);
    final imageUrl = product.getProductById(itemId!).imageUrl;

    return Dismissible(
      key: ValueKey(cartItem!.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<CartProvider>(context, listen: false).deleteItem(itemId!);
      },
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              "Are you sure ?",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              "Do you want to remove the item from the cart?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red.withOpacity(0.8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
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
      },
      background: Container(
        color: Theme.of(context).errorColor.withOpacity(0.85),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
      ),
      child: Card(
          elevation: 2.5,
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3),
          ),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(6.0), //or 15.0
              child: SizedBox(
                height: 70.0,
                width: 70.0,
                child: Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text(cartItem!.title!),
            subtitle: Text(
                "Total: \$ ${(cartItem!.price! * cartItem!.quantity!).toStringAsFixed(2)}"),
            trailing: Text("${cartItem!.quantity} x"),
          )),
    );
  }
}
