import 'package:default_project/data/models/order_model.dart';
import 'package:default_project/data/models/product_model.dart';
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

int counter = 1;

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Info page"),
        backgroundColor: const Color(0xff2A2A2A),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.withOpacity(0.4)),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18), topRight: Radius.circular(18)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Text(
                widget.productModel.productName,
                style: GoogleFonts.raleway(
                  fontSize: 30,
                  color: Colors.black,
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
                    style:
                        GoogleFonts.raleway(fontSize: 18, color: Colors.black),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    widget.productModel.currency.toString(),
                    style:
                        GoogleFonts.raleway(fontSize: 18, color: Colors.black),
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
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.productModel.description.toString(),
                    style: GoogleFonts.raleway(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Quantity of product",
                    style: GoogleFonts.raleway(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Container(
                    width: 115,
                    height: 35,
                    decoration: BoxDecoration(
                        color: const Color(0xFFF2F4FF),
                        borderRadius: BorderRadius.circular(60)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Color(0xFFDFE3FF)),
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
                              color: Color(0xff2A2A2A)),
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
              Expanded(
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
                      child: Column(
                        children: [
                          Container(
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
                                  fit: BoxFit.fill,
                                  scale: 6),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              InkWell(
                child: Container(
                    width: double.infinity,
                    height: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xff2A2A2A),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        "Add to cart",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    )),
                onTap: () {
                  OrderModel orderModel = OrderModel(
                    count: counter,
                    totalPrice: widget.productModel.price * counter,
                    orderId: "",
                    productId: widget.productModel.productId,
                    userId: FirebaseAuth.instance.currentUser!.uid,
                    orderStatus: "order status",
                    createdAt: DateTime.now().toString(),
                    productName: widget.productModel.productName,
                  );
                  Provider.of<OrderViewModel>(context, listen: false)
                      .addOrder(orderModel: orderModel);

                  counter = 0;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
