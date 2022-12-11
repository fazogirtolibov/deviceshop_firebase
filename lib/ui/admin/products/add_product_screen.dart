import 'package:default_project/data/models/product_model.dart';
import 'package:default_project/view_models/categories_view_model.dart';
import 'package:default_project/view_models/products_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/category.dart';
import '../../../utils/my_utils.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController countController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<String> productImages = [
    "https://www.pngitem.com/pimgs/m/183-1831803_laptop-collection-png-transparent-png.png",
    "https://www.pngitem.com/pimgs/m/183-1831803_laptop-collection-png-transparent-png.png",
  ];
  String categoryId = "";
  CategoryModel? categoryModel;
  String createdAt = DateTime.now().toString();
  List<String> currencies = ["USD", "SO'M", "RUBL", "TENGE"];
  String selectedCurrency = "USD";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product screen"),
        backgroundColor: const Color(0xff2A2A2A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: countController,
                keyboardType: TextInputType.number,
                decoration: getInputDecoration(label: "Count"),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: getInputDecoration(label: "Price"),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                keyboardType: TextInputType.text,
                decoration: getInputDecoration(label: "Product Name"),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: TextField(
                  controller: descriptionController,
                  keyboardType: TextInputType.text,
                  maxLines: 20,
                  decoration: getInputDecoration(label: "Description"),
                ),
              ),
              const SizedBox(height: 20),
              ExpansionTile(
                title: Text(selectedCurrency.isEmpty
                    ? "Select  Currency"
                    : selectedCurrency),
                children: [
                  ...List.generate(
                      currencies.length,
                      (index) => ListTile(
                            title: Text(currencies[index]),
                            onTap: () {
                              setState(() {
                                selectedCurrency = currencies[index];
                              });
                            },
                          ))
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff2A2A2A)),
                onPressed: () {
                  selectCategory((selectedCategory) {
                    categoryModel = selectedCategory;
                    categoryId = categoryModel!.categoryId;
                    setState(() {});
                  });
                },
                child: Text(
                  categoryModel == null
                      ? "Select Category"
                      : categoryModel!.categoryName,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff2A2A2A)),
                onPressed: () {
                  ProductModel productModel = ProductModel(
                    count: int.parse(countController.text),
                    price: int.parse(priceController.text),
                    productImages: productImages,
                    categoryId: categoryId,
                    productId: "",
                    productName: nameController.text,
                    description: descriptionController.text,
                    createdAt: createdAt,
                    currency: selectedCurrency,
                  );

                  Provider.of<ProductViewModel>(context, listen: false)
                      .addProduct(productModel);
                  Navigator.pop(context);
                },
                child: const Text("Add Product"),
              )
            ],
          ),
        ),
      ),
    );
  }

  selectCategory(ValueChanged<CategoryModel> onCategorySelect) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              width: double.infinity,
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
                      children: List.generate(
                        categories.length,
                        (index) => ListTile(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Color(0xff2A2A2A), width: 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          title: Text(categories[index].categoryName),
                          onTap: () {
                            onCategorySelect.call(categories[index]);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  }
                },
              ),
            ),
          );
        });
  }
}
