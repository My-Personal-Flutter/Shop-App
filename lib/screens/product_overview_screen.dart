import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Shop"),
        centerTitle: false,
        actions: [
          PopupMenuButton(
              color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.5),
              onSelected: (FilterOptions value) {
                setState(() {
                  if (value == FilterOptions.Favorites) {
                    _isFavorite = true;
                    print("fav" + _isFavorite.toString());
                  } else {
                    _isFavorite = false;
                    print("fav" + _isFavorite.toString());
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
                          )
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
                  ])
        ],
      ),
      body: ProductsGrid(
        isFavorite: _isFavorite,
      ),
    );
  }
}
