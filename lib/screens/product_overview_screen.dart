import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/products_grid.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _isFavorite = false;
  var _isLoading = false;

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts();
  }

  @override
  void initState() {
    super.initState();
    // 1st way
    setState(() {
      _isLoading = true;
    });
    Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts()
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
    //
    //  2nd way
    // Future.delayed(Duration.zero).then((value) {
    //   Provider.of<ProductsProvider>(context, listen: false)
    //       .fetchAndSetProducts();
    // });
  }

  @override
  void didChangeDependencies() {
    // it runs once
    // before the build method runs
    super.didChangeDependencies();
    // 3rd way
    // Provider.of<ProductsProvider>(context).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(
        key: UniqueKey(),
      ),
      appBar: AppBar(
        title: const Text("My Shop"),
        centerTitle: false,
        actions: [
          Consumer<CartProvider>(
            builder: (ctx, cart, ch) => Badge(
              child: IconButton(
                icon: cart.totalItems > 0
                    ? const Icon(Icons.shopping_cart)
                    : const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
              value: cart.totalItems.toString(),
            ),
          ),
          PopupMenuButton(
            color: Colors.black87.withOpacity(0.8),
            onSelected: (FilterOptions value) {
              setState(() {
                if (value == FilterOptions.Favorites) {
                  _isFavorite = true;
                } else {
                  _isFavorite = false;
                }
              });
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: FilterOptions.Favorites,
                child: Row(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Theme.of(context).primaryColor,
                      size: 18,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Favorites",
                      style: TextStyle(
                          fontFamily: "Lato",
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: FilterOptions.All,
                child: Row(
                  children: [
                    Icon(
                      Icons.grid_view,
                      color: Theme.of(context).primaryColor,
                      size: 18,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Show All",
                      style: TextStyle(
                        fontFamily: "Lato",
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ProductsGrid(
                isFavorite: _isFavorite,
              ),
      ),
    );
  }
}
