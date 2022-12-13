import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:default_project/data/models/order_model.dart';
import 'package:default_project/utils/my_utils.dart';

class OrderRepository {
  final FirebaseFirestore _firestore;
  OrderRepository({required FirebaseFirestore firebaseFirestore})
      : _firestore = firebaseFirestore;

  Future<void> addOrder({required OrderModel orderModel}) async {
    try {
      DocumentReference newOrder =
          await _firestore.collection("orders").add(orderModel.toJson());
      await _firestore
          .collection("orders")
          .doc(newOrder.id)
          .update({"orderId": newOrder.id});
      MyUtils.getMyToast(message: "Savatga muvaffaqiyatli qo'shildi");
    } on FirebaseException catch (e) {
      MyUtils.getMyToast(message: e.message.toString());
    }
  }

  Stream<List<OrderModel>> getAllOrder() =>
      _firestore.collection("orders").snapshots().map((event1) =>
          event1.docs.map((doc) => OrderModel.fromJson(doc.data())).toList());


  Future<void> deleteCategory ({required String docId})async{
    try{
      await _firestore.collection("orders").doc(docId).delete();
      MyUtils.getMyToast(message: "muvaffaqiyatli o'chirildi");
    } on FirebaseException catch(error){
      MyUtils.getMyToast(message: error.message.toString());
    }
  }
}
