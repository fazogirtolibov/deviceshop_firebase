import 'package:default_project/ui/tab_box/card/card_info.dart';
import 'package:default_project/utils/color.dart';
import 'package:default_project/view_models/orders_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CardPage extends StatefulWidget {
  const CardPage({Key? key}) : super(key: key);

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Card",
          style: GoogleFonts.raleway(color: MyColors.appBarText),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<OrdersViewModel>(
        builder: (context, orderViewModel, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              children: List.generate(
                orderViewModel.userOrders.length,
                (index) {
                  var order = orderViewModel.userOrders[index];
                  return InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Text(
                            order.productName,
                            style: GoogleFonts.raleway(fontSize: 30),
                          ),
                          const Spacer(),
                          Column(
                            children: [
                              Text(
                                "Count:${order.count}",
                                style: GoogleFonts.raleway(fontSize: 20),
                              ),
                              Text(
                                "Total price: \$${order.totalPrice}",
                                style: GoogleFonts.raleway(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      orderViewModel.getSingleProduct(order.productId);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builder) => CardInfo(
                            orderModel: order,
                          ),
                        ),
                      );
                      ;
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
