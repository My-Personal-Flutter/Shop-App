import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/products_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = "/product-detail";

  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  var quantity = 0;
  var check = false;

  @override
  void initState() {}

  @override
  void didChangeDependencies() {
    if (check == false) {
      final productId = ModalRoute.of(context)!.settings.arguments as String;
      if (Provider.of<CartProvider>(context, listen: false)
          .findByProductId(productId)) {
        quantity = Provider.of<CartProvider>(context, listen: false)
            .getProductQuantity(productId);
      }
    }
    check = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final product = Provider.of<ProductsProvider>(
      context,
      listen: false,
    ).getProductById(productId);
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: false,
      //   title: Text(product.title!),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 333,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                margin: EdgeInsets.only(right: 8),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).primaryColor.withOpacity(0.75),
                ),
                child: Text(
                  product.title as String,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.fade,
                  //  textAlign: TextAlign.right,
                ),
              ),
              centerTitle: false,
              background: product.imageUrl!.startsWith("http")
                  ? Hero(
                      tag: product.id!,
                      child: Image.network(
                        product.imageUrl!,
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return Image.asset(
                            "assets/images/file_not_found.png",
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    )
                  : Hero(
                      tag: product.id!,
                      child: Image.file(
                        File(product.imageUrl!),
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return Image.asset(
                            "assets/images/file_not_found.png",
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 18,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "\$${product.price}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          quantity > 0
                              ? Row(
                                  children: [
                                    RawMaterialButton(
                                      onPressed: () {
                                        setState(() {
                                          cart.deleteItem(product.id!);
                                          quantity = quantity - 1;
                                        });
                                      },
                                      elevation: 2.0,
                                      fillColor: Colors.white,
                                      child: const Icon(
                                        Icons.remove,
                                        size: 24.0,
                                      ),
                                      shape: CircleBorder(),
                                    ),
                                    Text(quantity.toString()),
                                    RawMaterialButton(
                                      onPressed: () {
                                        setState(() {
                                          cart.addItem(product);
                                          quantity = quantity + 1;
                                        });
                                      },
                                      elevation: 2.0,
                                      fillColor: Colors.white,
                                      child: const Icon(
                                        Icons.add,
                                        size: 24.0,
                                      ),
                                      shape: CircleBorder(),
                                    ),
                                  ],
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      cart.addItem(product);
                                      quantity = quantity + 1;
                                    });
                                  },
                                  child: Text("Add to Cart"),
                                )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: double.infinity,
                      child: Text(
                        product.description!,
                        softWrap: true,
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Explanation",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of de Finibus Bonorum et Malorum (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, Lorem ipsum dolor sit amet.., comes from a line in section 1.10.32.The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from de Finibus Bonorum et Malorum by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shop_app/providers/cart_provider.dart';
// import 'package:shop_app/providers/products_provider.dart';

// class ProductDetailScreen extends StatefulWidget {
//   static const routeName = "/product-detail";

//   const ProductDetailScreen({Key? key}) : super(key: key);

//   @override
//   State<ProductDetailScreen> createState() => _ProductDetailScreenState();
// }

// class _ProductDetailScreenState extends State<ProductDetailScreen> {
//   var quantity = 0;
//   var check = false;

//   @override
//   void initState() {}

//   @override
//   void didChangeDependencies() {
//     if (check == false) {
//       final productId = ModalRoute.of(context)!.settings.arguments as String;
//       if (Provider.of<CartProvider>(context, listen: false)
//           .findByProductId(productId)) {
//         quantity = Provider.of<CartProvider>(context, listen: false)
//             .getProductQuantity(productId);
//       }
//     }
//     check = true;
//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final productId = ModalRoute.of(context)!.settings.arguments as String;
//     final product = Provider.of<ProductsProvider>(
//       context,
//       listen: false,
//     ).getProductById(productId);
//     final cart = Provider.of<CartProvider>(context, listen: false);

//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: false,
//         title: Text(product.title!),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               width: double.infinity,
//               height: 300,
//               child: product.imageUrl!.startsWith("http")
//                   ? Hero(
//                       tag: product.id!,
//                       child: Image.network(
//                         product.imageUrl!,
//                         filterQuality: FilterQuality.high,
//                         fit: BoxFit.cover,
//                         errorBuilder: (BuildContext context, Object exception,
//                             StackTrace? stackTrace) {
//                           return Image.asset(
//                             "assets/images/file_not_found.png",
//                             height: 200,
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                           );
//                         },
//                       ),
//                     )
//                   : Hero(
//                       tag: product.id!,
//                       child: Image.file(
//                         File(product.imageUrl!),
//                         height: 200,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                         errorBuilder: (BuildContext context, Object exception,
//                             StackTrace? stackTrace) {
//                           return Image.asset(
//                             "assets/images/file_not_found.png",
//                             height: 200,
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                           );
//                         },
//                       ),
//                     ),
//             ),
//             const SizedBox(
//               height: 24,
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "\$${product.price}",
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   quantity > 0
//                       ? Row(
//                           children: [
//                             RawMaterialButton(
//                               onPressed: () {
//                                 setState(() {
//                                   cart.deleteItem(product.id!);
//                                   quantity = quantity - 1;
//                                 });
//                               },
//                               elevation: 2.0,
//                               fillColor: Colors.white,
//                               child: const Icon(
//                                 Icons.remove,
//                                 size: 24.0,
//                               ),
//                               shape: CircleBorder(),
//                             ),
//                             Text(quantity.toString()),
//                             RawMaterialButton(
//                               onPressed: () {
//                                 setState(() {
//                                   cart.addItem(product);
//                                   quantity = quantity + 1;
//                                 });
//                               },
//                               elevation: 2.0,
//                               fillColor: Colors.white,
//                               child: const Icon(
//                                 Icons.add,
//                                 size: 24.0,
//                               ),
//                               shape: CircleBorder(),
//                             ),
//                           ],
//                         )
//                       : ElevatedButton(
//                           onPressed: () {
//                             setState(() {
//                               cart.addItem(product);
//                               quantity = quantity + 1;
//                             });
//                           },
//                           child: Text("Add to Cart"),
//                         )
//                 ],
//               ),
//             ),
//             const SizedBox(
//               height: 8,
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//               ),
//               width: double.infinity,
//               child: Text(
//                 product.description!,
//                 softWrap: true,
//                 style: TextStyle(
//                   color: Colors.grey[700],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
