import 'package:flutter/cupertino.dart';

import '../data/models/category.dart';
import '../data/repositories/categories_repository.dart';

class CategoriesViewModel extends ChangeNotifier {
  final CategoryRepository categoryRepository;

  CategoriesViewModel({required this.categoryRepository}){
    listenCategories();
  }

//  List<CategoryModel> categories = [];

  Stream<List<CategoryModel>> listenCategories() =>
      categoryRepository.getCategories();
}
