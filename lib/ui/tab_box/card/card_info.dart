import 'package:default_project/data/models/order_model.dart';
import 'package:default_project/utils/color.dart';
import 'package:default_project/view_models/orders_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CardInfo extends StatelessWidget {
  const CardInfo({Key? key, required this.orderModel}) : super(key: key);
  final OrderModel orderModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            iconSize: 36,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_circle_left_outlined),
            color: MyColors.appBarText,
          ),
          title: Text(
            "Card info",
            style: GoogleFonts.raleway(color: MyColors.appBarText),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Consumer<OrdersViewModel>(
          builder: (context, orderViewModel, child) {
            if (orderViewModel.productModel != null) {
              var product = orderViewModel.productModel!;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Text(
                      orderModel.orderStatus,
                      style: GoogleFonts.raleway(),
                    ),
                    Text(
                      orderModel.createdAt,
                      style: GoogleFonts.raleway(),
                    ),
                    Text(
                      orderModel.count.toString(),
                      style: GoogleFonts.raleway(),
                    ),
                    Text(
                      orderModel.totalPrice.toString(),
                      style: GoogleFonts.raleway(),
                    ),
                    Text(
                      product.price.toString(),
                      style: GoogleFonts.raleway(),
                    ),
                    const SizedBox(height: 20),
                    Image.network(product.productImages[0]),
                    const SizedBox(height: 20),
                    Text(
                      product.description,
                      style: GoogleFonts.raleway(),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
