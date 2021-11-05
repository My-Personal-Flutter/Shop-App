import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helpers/custom_route.dart';
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
import 'package:shop_app/screens/splash_screen.dart';
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
                userId: authObject.userId,
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
        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
          update: (context, authObject, previous) {
            return OrdersProvider(
                authToken: authObject.token,
                userId: authObject.userId,
                itemsOrders:
                    previous!.itemsOrders == null ? [] : previous.itemsOrders);
          },
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
                  //onSecondary: Colors.black,
                ),
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: CustomPageTransitionBuilder(),
                  TargetPlatform.iOS: CustomPageTransitionBuilder(),
                })),
            initialRoute: '/',
            routes: {
              '/': (ctx) => authData.isAuthenticated
                  ? const ProductOverviewScreen()
                  : FutureBuilder(
                      // this if for next time when user open app
                      future: authData.tryAutoLogin(),
                      builder: (ctx, snapshotResultData) =>
                          snapshotResultData.connectionState ==
                                  ConnectionState.waiting
                              ? const SplashScreen()
                              : const AuthScreen(),
                    ),
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
