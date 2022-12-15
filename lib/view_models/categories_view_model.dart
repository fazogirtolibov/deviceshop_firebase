import 'package:default_project/data/models/category.dart';
import 'package:default_project/data/repositories/categories_repository.dart';
import 'package:flutter/cupertino.dart';

class CategoriesViewModel extends ChangeNotifier {
  final CategoryRepository categoryRepository;

  CategoriesViewModel({required this.categoryRepository});

  Stream<List<CategoryModel>> listenCategories() =>
      categoryRepository.getCategories();
}
