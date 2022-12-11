import 'dart:async';

import 'package:flutter/material.dart';

import '../data/models/product_model.dart';
import '../data/repositories/product_repository.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductRepository productRepository;

  ProductViewModel({required this.productRepository}) {
    listenProducts('');
  }

  late StreamSubscription subscription;

  List<ProductModel> products = [];

  listenProducts(String categoryId) async {
    subscription = productRepository.getProducts().listen((allProducts) {
      products = allProducts;
      notifyListeners();
    })
      ..onError((er) {});
  }

  addProduct(ProductModel productModel) =>
      productRepository.addProduct(productModel: productModel);

  updateProduct(ProductModel productModel) =>
      productRepository.updateProduct(productModel: productModel);

  deleteProduct(String docId) => productRepository.deleteProduct(docId: docId);

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}
