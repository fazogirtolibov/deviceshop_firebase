import 'package:default_project/ui/admin/category/all_categories_screen.dart';
import 'package:default_project/ui/admin/products/all_products_screen.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Page"),
        backgroundColor: const Color(0xff2A2A2A),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text("Products"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AllProductsScreen()));
            },
          ),
          ListTile(
            title: const Text("Categories"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AllCategoriesScreen()));
            },
          ),
        ],
      ),
    );
  }
}
