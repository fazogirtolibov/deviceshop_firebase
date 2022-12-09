import 'package:default_project/data/models/category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/color.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style.dart';
import '../../../view_models/categories_view_model.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({Key? key}) : super(key: key);

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

final formKey = GlobalKey<FormState>();
final nameController = TextEditingController();
final descController = TextEditingController();
String categoryName = '';
String description = '';
String createdAt = DateTime.now().toString();
String imgUrl =
    'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.wired.co.uk%2Farticle%2Fcode-breaker-1&psig=AOvVaw3nVDklSAyKaQ5rvU-h-0Lw&ust=1670589660048000&source=images&cd=vfe&ved=0CBAQjRxqFwoTCKCP1c2F6vsCFQAAAAAdAAAAABAD';

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(" Add Category"),
        backgroundColor: const Color(0xff2A2A2A),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      onChanged: (value) {
                        categoryName = value;
                      },
                      validator: (value) {
                        if (value == null || value.length < 4) {
                          return 'Please enter at least 6 letters';
                        }
                        return null;
                      },
                      controller: nameController,
                      textInputAction: TextInputAction.next,
                      style: MyTextStyle.sfProRegular.copyWith(
                        color: MyColors.black,
                        fontSize: 17,
                      ),
                      decoration: getInputDecoration(label: "Category Name"),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      onChanged: (value) {
                        description = value;
                      },
                      validator: (value) {
                        if (value == null || value.length < 10) {
                          return 'Please enter at least 10 letters';
                        }
                        return null;
                      },
                      controller: descController,
                      textInputAction: TextInputAction.next,
                      style: MyTextStyle.sfProRegular.copyWith(
                        color: MyColors.black,
                        fontSize: 17,
                      ),
                      decoration: getInputDecoration(label: "Description"),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff2A2A2A)),
                      onPressed: () {},
                      child: const Text('Choose image'),
                    ),
                  ],
                )),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2A2A2A)),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  CategoryModel categoryModel = CategoryModel(
                    categoryId: "",
                    categoryName: categoryName,
                    description: description,
                    imageUrl: imgUrl,
                    createdAt: createdAt,
                  );

                  Provider.of<CategoriesViewModel>(context, listen: false)
                      .addCategory(categoryModel);
                }
                Navigator.pop(context);
              },
              child: const Text('Submit'),
            )
          ],
        ),
      ),
    );
  }
}
