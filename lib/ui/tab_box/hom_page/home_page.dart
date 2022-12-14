import 'package:default_project/data/models/category.dart';
import 'package:default_project/ui/tab_box/hom_page/info_page.dart';
import 'package:default_project/utils/color.dart';
import 'package:default_project/utils/icon.dart';
import 'package:default_project/utils/my_utils.dart';
import 'package:default_project/view_models/categories_view_model.dart';
import 'package:default_project/view_models/products_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

int categoryIndex = 0;

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Grocery Shop",
            style: GoogleFonts.raleway(color: MyColors.appBarText),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  categoryIndex = -1;
                });
                Provider.of<ProductViewModel>(
                  context,
                  listen: false,
                ).listenProducts("");
              },
              icon: Text(
                "All",
                style: GoogleFonts.raleway(
                    fontSize: 18, color: MyColors.textColor),
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border:
                      Border.all(color: Colors.grey.withOpacity(0.3), width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 16,
                    ),
                    SvgPicture.asset(MyIcons.search_icon),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Search",
                      style: GoogleFonts.raleway(
                        fontSize: 18,
                        color: MyColors.appBarText,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              SizedBox(
                child: StreamBuilder<List<CategoryModel>>(
                  stream:
                      Provider.of<CategoriesViewModel>(context, listen: false)
                          .listenCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasData) {
                      List<CategoryModel> categories = snapshot.data!;
                      return Container(
                        height: 50,
                        padding: const EdgeInsets.all(2),
                        child: ListView.builder(
                          itemCount: categories.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  categoryIndex = index;
                                });
                                Provider.of<ProductViewModel>(
                                  context,
                                  listen: false,
                                ).listenProducts(categories[index].categoryId);
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                margin: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: categoryIndex == index
                                      ? const Color(0xff2A2A2A)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.3),
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                    child: Text(
                                  categories[index].categoryName,
                                  style: GoogleFonts.raleway(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: categoryIndex == index
                                        ? Colors.white
                                        : MyColors.textColor,
                                  ),
                                )),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }
                  },
                ),
              ),
              Expanded(
                child: Consumer<ProductViewModel>(
                  builder: (context, productViewModel, child) {
                    return GridView(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2.5 / 3.2,
                      ),
                      children: List.generate(productViewModel.products.length,
                          (index) {
                        var product = productViewModel.products[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: InkWell(
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    height: 150,
                                    child: Image.network(
                                      product.productImages[0],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    product.productName,
                                    style: GoogleFonts.raleway(
                                        color: MyColors.textColor,
                                        fontSize: 20),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        product.currency,
                                        style: GoogleFonts.raleway(
                                            color: MyColors.textColor),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        product.price.toString(),
                                        style: GoogleFonts.raleway(
                                            color: MyColors.textColor),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        InfoPage(productModel: product),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
