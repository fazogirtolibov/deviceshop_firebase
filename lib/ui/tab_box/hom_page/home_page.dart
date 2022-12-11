import 'package:default_project/data/models/category.dart';
import 'package:default_project/view_models/categories_view_model.dart';
import 'package:default_project/view_models/products_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: const Color(0xff2A2A2A),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: StreamBuilder<List<CategoryModel>>(
              stream: Provider.of<CategoriesViewModel>(context, listen: false)
                  .listenCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData) {
                  List<CategoryModel> categories = snapshot.data!;
                  return ListView(
                    children: [
                      ListTile(
                        title: Text("All"),
                        onTap: () {
                          Provider.of<ProductViewModel>(
                            context,
                            listen: false,
                          ).listenProducts('');
                        },
                      ),
                      ...List.generate(
                        categories.length,
                        (index) => ListTile(
                          title: Text(categories[index].categoryName),
                          onTap: () {
                            Provider.of<ProductViewModel>(
                              context,
                              listen: false,
                            ).listenProducts(categories[index].categoryId);
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }
              },
            ),
          ),
          Expanded(child: Consumer<ProductViewModel>(
            builder: (context, productViewModel, child) {
              return ListView(
                children:
                    List.generate(productViewModel.products.length, (index) {
                  var product = productViewModel.products[index];
                  return ListTile(
                    title: Text(product.productName),
                    onTap: () {},
                  );
                }),
              );
            },
          ))
        ],
      ),
    );
  }
}
