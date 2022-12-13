
import 'package:default_project/data/models/order_model.dart';
import 'package:default_project/data/repositories/order_repository.dart';

class OrderViewModel{
  final OrderRepository orderRepository;
  OrderViewModel({required this.orderRepository});


  Stream<List<OrderModel>> listenOrders()=> orderRepository.getAllOrder();

  addOrder({required OrderModel orderModel})=>orderRepository.addOrder(orderModel: orderModel);

  deleteOrder({required String docId})=> orderRepository.deleteCategory(docId: docId);
}