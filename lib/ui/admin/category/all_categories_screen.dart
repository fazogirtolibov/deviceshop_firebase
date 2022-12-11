import 'package:default_project/data/models/category.dart';
import 'package:default_project/ui/admin/category/add_category_screen.dart';
import 'package:default_project/ui/admin/category/update_category_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../view_models/categories_view_model.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({Key? key}) : super(key: key);

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories Admin"),
        backgroundColor: const Color(0xff2A2A2A),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddCategoryScreen()));
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: StreamBuilder<List<CategoryModel>>(
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
              children: List.generate(categories.length, (index) {
                CategoryModel category = categories[index];
                return ListTile(
                  title: Text(category.categoryName),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateCategoryScreen(
                                    categoryModel: category,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit_note_rounded)),
                        IconButton(
                            onPressed: () {
                              Provider.of<CategoriesViewModel>(context,
                                      listen: false)
                                  .deleteCategory(category.categoryId);

                              print("DELETING ID:${category.categoryId}");
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
