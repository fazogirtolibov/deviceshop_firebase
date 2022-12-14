import 'package:default_project/data/models/order_model.dart';
import 'package:default_project/data/models/product_model.dart';
import 'package:default_project/utils/color.dart';
import 'package:default_project/view_models/orders_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key, required this.productModel}) : super(key: key);
  final ProductModel productModel;

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  int counter = 1;

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
          "Shop",
          style: GoogleFonts.raleway(
            color: MyColors.appBarText,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.25,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: widget.productModel.productImages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.only(
                          top: 6, left: 4, right: 4, bottom: 6),
                      width: 100,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white),
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                            topRight: Radius.circular(12),
                            topLeft: Radius.circular(12),
                          ),
                          image: DecorationImage(
                              image: NetworkImage(
                                  widget.productModel.productImages[index]),
                              fit: BoxFit.cover,
                              scale: 6),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Column(
                children: [
                  Text(
                    widget.productModel.productName,
                    style: GoogleFonts.raleway(
                      fontSize: 30,
                      color: MyColors.textColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Price per item: ',
                        style: GoogleFonts.raleway(fontSize: 18),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.productModel.price.toString(),
                        style: GoogleFonts.raleway(
                            fontSize: 18, color: Colors.black),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.productModel.currency.toString(),
                        style: GoogleFonts.raleway(
                            fontSize: 18, color: Colors.black),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Descpription about our product:",
                        style: GoogleFonts.raleway(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: MyColors.textColor,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.productModel.description.toString(),
                        style: GoogleFonts.raleway(
                          fontSize: 18,
                          color: MyColors.textColor,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Quantity of product",
                        style: GoogleFonts.raleway(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: MyColors.textColor,
                        ),
                      ),
                      Container(
                        width: 115,
                        height: 35,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.04),
                            borderRadius: BorderRadius.circular(60)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.black.withOpacity(0.07)),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (counter > 1) {
                                      counter--;
                                    }
                                  });
                                },
                                child: const Icon(
                                  Icons.remove_circle_outline,
                                  color: Color(0xff2A2A2A),
                                ),
                              ),
                            ),
                            Text(
                              "$counter",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 20),
                            ),
                            Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: const Color(0xff2A2A2A)),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    counter++;
                                  });
                                },
                                child: const Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.07),
              InkWell(
                onTap: () {
                  List<OrderModel> orders =
                      Provider.of<OrdersViewModel>(context, listen: false)
                          .userOrders;

                  List<OrderModel> exists = orders
                      .where(
                          (e) => e.productId == widget.productModel.productId)
                      .toList();

                  if (exists.isNotEmpty) {
                    orders.forEach((element) {
                      if (element.productId == widget.productModel.productId) {
                        Provider.of<OrdersViewModel>(context, listen: false)
                            .updateOrderIfExists(
                                productId: element.productId, count: counter);
                      }
                    });
                  } else {
                    Provider.of<OrdersViewModel>(context, listen: false)
                        .addOrder(
                      OrderModel(
                          count: counter,
                          totalPrice: widget.productModel.price * counter,
                          orderId: "",
                          productId: widget.productModel.productId,
                          userId: FirebaseAuth.instance.currentUser!.uid,
                          orderStatus: "ordered",
                          createdAt: DateTime.now().toString(),
                          productName: widget.productModel.productName),
                    );
                  }
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xff2A2A2A),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Add to basket",
                      style: GoogleFonts.raleway(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
