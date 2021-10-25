import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart' show Cart;
import 'package:shop_app/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart";

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("My Cart"),
        centerTitle: false,
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(16),
        child: isPortrait
            ? Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (ctx, index) {
                        return CartItem(
                          itemId: cart.items.keys.toList()[index],
                          cartItem: cart.items.values.toList()[index],
                        );
                      },
                      itemCount: cart.items.length,
                    ),
                  ),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Items",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Chip(
                                  label: Text(
                                    "\$ ${cart.totalAmount}",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .primaryTextTheme
                                          .headline6!
                                          .color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Discounts",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Chip(
                                  label: Text(
                                    "- \$ 0.0",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .primaryTextTheme
                                          .headline6!
                                          .color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Divider(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Chip(
                                label: Text(
                                  "\$ ${cart.totalAmount}",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .primaryTextTheme
                                        .headline6!
                                        .color,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                backgroundColor: Theme.of(context).primaryColor,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  "Checkout",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .primaryTextTheme
                                          .headline6!
                                          .color,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                style: ButtonStyle(
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                          EdgeInsets.symmetric(
                                              horizontal: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              vertical: 12)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (ctx, index) {
                        return CartItem(
                          itemId: cart.items.keys.toList()[index],
                          cartItem: cart.items.values.toList()[index],
                        );
                      },
                      itemCount: cart.items.length,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 3.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Items",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Chip(
                                  label: Text(
                                    "\$ ${cart.totalAmount}",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .primaryTextTheme
                                          .headline6!
                                          .color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Discounts",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Chip(
                                  label: Text(
                                    "- \$ 0.0",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .primaryTextTheme
                                          .headline6!
                                          .color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const Divider(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Chip(
                                  label: Text(
                                    "\$ ${cart.totalAmount}",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .primaryTextTheme
                                          .headline6!
                                          .color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {},
                                  child: Text(
                                    "Checkout",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .primaryTextTheme
                                            .headline6!
                                            .color,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  style: ButtonStyle(
                                    padding:
                                        MaterialStateProperty.all<EdgeInsets>(
                                            EdgeInsets.symmetric(
                                                horizontal: isPortrait
                                                    ? MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        4
                                                    : MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        10,
                                                vertical: 12)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
