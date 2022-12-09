import 'package:default_project/data/models/product_model.dart';
import 'package:default_project/ui/admin/products/add_product_screen.dart';
import 'package:default_project/ui/admin/products/update_product_screen.dart';
import 'package:default_project/view_models/products_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../view_models/categories_view_model.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({Key? key}) : super(key: key);

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products Admin"),
        backgroundColor: const Color(0xff2A2A2A),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddProductScreen()));
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: StreamBuilder<List<ProductModel>>(
        stream: Provider.of<ProductViewModel>(context, listen: false)
            .listenProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            List<ProductModel> products = snapshot.data!;
            return ListView(
              children: List.generate(products.length, (index) {
                ProductModel product = products[index];
                return ListTile(
                  title: Text(product.productName),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateProductScreen(
                                    productModel: product,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit_note_rounded)),
                        IconButton(
                            onPressed: () {
                              Provider.of<ProductViewModel>(context,
                                      listen: false)
                                  .deleteProduct(product.productId);

                              print("DELETING ID:${product.productId}");
                            },
                            icon: const Icon(Icons.delete_outline_rounded)),
                      ],
                    ),
                  ),
                );
              }),
            );
          } else {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
        },
      ),
    );
  }
}
