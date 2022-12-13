import 'package:default_project/data/models/category.dart';
import 'package:default_project/data/services/file_uploader.dart';
import 'package:default_project/utils/color.dart';
import 'package:default_project/utils/my_utils.dart';
import 'package:default_project/utils/style.dart';
import 'package:default_project/view_models/categories_view_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

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
final ImagePicker _picker = ImagePicker();
String imageUrl = "";

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
                    if (imageUrl.isNotEmpty)
                      Image.network(
                        imageUrl,
                        width: 200,
                        height: 120,
                      ),
                    for (int index = 0; index < 3; index++)
                      const ListTile(
                        title: Text("photo"),
                      ),
                    IconButton(
                        onPressed: () {
                          _showPicker(context);
                        },
                        icon: Icon(Icons.upload))
                  ],
                )),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2A2A2A)),
              onPressed: () {
                if (imageUrl.isEmpty) {
                  MyUtils.getMyToast(message: "Image tanla!!!!");
                  return;
                }
                if (formKey.currentState!.validate()) {
                  CategoryModel categoryModel = CategoryModel(
                    categoryId: "",
                    categoryName: categoryName,
                    description: description,
                    imageUrl: imageUrl,
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

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text("Gallery"),
                    onTap: () {
                      _getFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    _getFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  _getFromGallery() async {
    XFile? pickedFile = await _picker.pickImage(
      maxWidth: 1000,
      maxHeight: 1000,
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      if (!mounted) return;
      imageUrl = await FileUploader.imageUploader(pickedFile);
      setState(() {});
    }
  }

  _getFromCamera() async {
    XFile? pickedFile = await _picker.pickImage(
      maxWidth: 1920,
      maxHeight: 2000,
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      if (!mounted) return;
      imageUrl = await FileUploader.imageUploader(pickedFile);
      setState(() {});
    }
  }
}
