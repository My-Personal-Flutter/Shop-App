import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/orders_provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/add_edit_product_screen.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/product_overview_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const userId = 137;

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          update: (context, authObject, ProductsProvider? previous) {
            return ProductsProvider(
                authToken: authObject.token,
                itemsProducts: previous!.itemsProducts == null
                    ? []
                    : previous.itemsProducts);
          },
          create: (ctx) {
            return ProductsProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (ctx) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => OrdersProvider(),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, authData, child) {
          return MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
              primarySwatch: Colors.cyan,
              fontFamily: 'Lato',
              canvasColor: Colors.grey[100],
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.cyan,
              ).copyWith(
                secondary: Colors.amber,
                onSecondary: Colors.black,
              ),
            ),
            initialRoute: '/',
            routes: {
              '/': (ctx) => authData.isAuthenticated
                  ? const ProductOverviewScreen()
                  : const AuthScreen(),
              ProductDetailScreen.routeName: (ctx) =>
                  const ProductDetailScreen(),
              CartScreen.routeName: (ctx) => const CartScreen(),
              OrdersScreen.routeName: (ctx) => const OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => const UserProductsScreen(),
              AddEditProductScreen.routeName: (ctx) =>
                  const AddEditProductScreen(),
            },
          );
        },
      ),
    );
  }
}
