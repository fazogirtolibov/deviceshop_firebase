import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:default_project/utils/my_utils.dart';
import 'package:easy_localization/easy_localization.dart';

import '../models/category.dart';

class CategoryRepository {
  final FirebaseFirestore _firestore;

  CategoryRepository({required FirebaseFirestore firebaseFirestore})
      : _firestore = firebaseFirestore;

  Stream<List<CategoryModel>> getCategories() =>
      _firestore.collection("categories").snapshots().map(
            (event1) => event1.docs
                .map((doc) => CategoryModel.fromJson(doc.data()))
                .toList(),
          );

  Future<void> addCategory({required CategoryModel categoryModel}) async {
    try {
      DocumentReference newCategory =
          await _firestore.collection('categories').add(categoryModel.toJson());
      await _firestore
          .collection('categories')
          .doc(newCategory.id)
          .update({'categoryId': newCategory.id});
      MyUtils.getMyToast(message: 'Category successfully added!');
    } on FirebaseException catch (error) {
      MyUtils.getMyToast(message: error.message.toString());
    }
  }

  Future<void> deleteCategory({required String docId}) async {
    try {
      await _firestore.collection("categories").doc(docId).delete();
      MyUtils.getMyToast(message: "Kategorya muvaffaqiyatli o'chirildi!");
    } on FirebaseException catch (er) {
      MyUtils.getMyToast(message: er.message.toString());
    }
  }

  Future<void> updateCategory({required CategoryModel categoryModel}) async {
    try {
      await _firestore
          .collection("categories")
          .doc(categoryModel.categoryId)
          .update(categoryModel.toJson());

      MyUtils.getMyToast(message: "Kategorya muvaffaqiyatli yangilandi!");
    } on FirebaseException catch (er) {
      MyUtils.getMyToast(message: er.message.toString());
    }
  }
}
