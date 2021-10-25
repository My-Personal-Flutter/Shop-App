import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products_provider.dart';
import '../providers/cart.dart' as CI show CartItem;

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
        Provider.of<Cart>(context, listen: false).deleteItem(itemId!);
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
        padding: EdgeInsets.only(right: 16),
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
            subtitle:
                Text("Total: \$ ${(cartItem!.price! * cartItem!.quantity!)}"),
            trailing: Text("${cartItem!.quantity} x"),
          )),
    );
  }
}
