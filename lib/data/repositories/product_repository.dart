import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product_model.dart';

class ProductRepository {
  final FirebaseFirestore _firestore;

  ProductRepository({required FirebaseFirestore firebaseFirestore})
      : _firestore = firebaseFirestore;

  Stream<List<ProductModel>> getProducts({required String categoryId}) async* {
    if (categoryId.isEmpty) {
      yield* _firestore.collection("products").snapshots().map(
            (querySnapshot) => querySnapshot.docs
                .map((doc) => ProductModel.fromJson(doc.data()))
                .toList(),
          );
    } else {
      yield* _firestore
          .collection("products")
          .where("categoryId", isEqualTo: categoryId)
          .snapshots()
          .map(
            (querySnapshot) => querySnapshot.docs
                .map((doc) => ProductModel.fromJson(doc.data()))
                .toList(),
          );
    }
  }
}
