import 'package:default_project/data/models/category.dart';
import 'package:default_project/ui/tab_box/hom_page/info_page.dart';
import 'package:default_project/view_models/categories_view_model.dart';
import 'package:default_project/view_models/products_view_model.dart';
import 'package:flutter/material.dart';
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
            "Home",
            style: GoogleFonts.raleway(),
          ),
          backgroundColor: const Color(0xff2A2A2A),
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
                  style: GoogleFonts.raleway(fontSize: 18),
                ))
          ],
        ),
        body: Column(
          children: [
            SizedBox(
              child: StreamBuilder<List<CategoryModel>>(
                stream: Provider.of<CategoriesViewModel>(context, listen: false)
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
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(
                                    width: 2, color: const Color(0xff2A2A2A)),
                              ),
                              child: Center(
                                  child: Text(
                                categories[index].categoryName,
                                style: GoogleFonts.raleway(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: categoryIndex == index
                                      ? Colors.white
                                      : Colors.black,
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
                      childAspectRatio: 2.5 / 3.1,
                    ),
                    children: List.generate(productViewModel.products.length,
                        (index) {
                      var product = productViewModel.products[index];
                      return Card(
                        color: const Color(0xff2A2A2A),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: InkWell(
                            child: Column(
                              children: [
                                Text(
                                  product.productName,
                                  style: GoogleFonts.raleway(
                                      color: Colors.white, fontSize: 20),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      product.currency,
                                      style: GoogleFonts.raleway(
                                          color: Colors.white),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      product.price.toString(),
                                      style: GoogleFonts.raleway(
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: double.infinity,
                                  height: 150,
                                  child: Image.network(
                                    product.productImages[0],
                                    fit: BoxFit.cover,
                                  ),
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
    );
  }
}
