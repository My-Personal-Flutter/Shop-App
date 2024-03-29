import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helpers/custom_route.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 240,
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              alignment: Alignment.center,
              color: Theme.of(context).primaryColor,
              child: const Text(
                "Hello Friend!",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 40,
                ),
              ),
            ),
            const Divider(
              height: 1,
            ),
            ListTile(
              leading: const Icon(
                Icons.shop,
                size: 22,
                color: Colors.black,
              ),
              title: const Text(
                "Shop",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
            const Divider(
              height: 0.1,
            ),
            ListTile(
              leading: const Icon(
                Icons.payment,
                size: 22,
                color: Colors.black,
              ),
              title: const Text(
                "Orders",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(OrdersScreen.routeName);
                // Navigator.of(context).pushReplacement(
                //   CustomRoute(
                //     widgetBuilder: (ctx) => OrdersScreen(),
                //   ),
                // );
              },
            ),
            const Divider(
              height: 0.1,
            ),
            ListTile(
              leading: const Icon(
                Icons.edit,
                size: 22,
                color: Colors.black,
              ),
              title: const Text(
                "Manage Products",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(UserProductsScreen.routeName);
              },
            ),
            const Divider(
              height: 0.1,
            ),
            ListTile(
              leading: const Icon(
                Icons.exit_to_app,
                size: 22,
                color: Colors.black,
              ),
              title: const Text(
                "Logout",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed("/");
                Provider.of<AuthProvider>(context, listen: false).logout();
              },
            ),
            const Divider(
              height: 0.1,
            ),
          ],
        ),
      ),
    );
  }
}
