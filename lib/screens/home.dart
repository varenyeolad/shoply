import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoply/Firebase/firebase_firestore.dart';
import 'package:shoply/constants/routes.dart';
import 'package:shoply/models/category_model.dart';
import 'package:shoply/models/product_model.dart';
import 'package:shoply/provider/app_provider.dart';
import 'package:shoply/screens/category_view.dart';
import 'package:shoply/screens/product_details.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategoryModel> categoriesList1 = [];
  List<ProductModel> productModelList = [];
  List<ProductModel> recommendedList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.getUserInfoFirebase();
    getCategoriesAndProducts();
  }

  void getCategoriesAndProducts() async {
    setState(() {
      isLoading = true;
    });

    categoriesList1 = await FirebaseFirestoreHelper.instance.getCategories1();
    productModelList = await FirebaseFirestoreHelper.instance.getProducts();
    recommendedList = await FirebaseFirestoreHelper.instance.recommendProductsBasedOnFavorites();

    setState(() {
      isLoading = false;
    });
  }

  TextEditingController search = TextEditingController();
  List<ProductModel> searchList = [];

  void searchProducts(String value) {
    searchList = productModelList
        .where((element) => element.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 600 ? 3 : 2;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: isLoading
              ? Center(child: CircularProgressIndicator(color: Colors.grey))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: kToolbarHeight - 15),
                          _buildSearchBar(),
                          const SizedBox(height: 15),
                          _buildCategoriesList(),
                          const SizedBox(height: 15),
                          _buildRecommendedSection(crossAxisCount),
                          const SizedBox(height: 15),
                          const Text(
                            "Products",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 23.0,
                              color: Colors.black,
                              
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    _buildProductGrid(crossAxisCount),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.center,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(100),
            ),
            child: TextFormField(
              style: const TextStyle(color: Colors.black),
              controller: search,
              onChanged: searchProducts,
              decoration: InputDecoration(
                hintText: "Search...",
                prefixIcon: const Icon(Icons.search, color: Colors.black45),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesList() {
    return categoriesList1.isEmpty
        ? const Center(child: Text("Categories not available"))
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categoriesList1.map((category) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      Routes.instance.push(
                          CategoryView(categoryModel: category), context);
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        width: 90,
                        height: 90,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(category.image, height: 50),
                            const SizedBox(height: 5),
                            Text(
                              category.name,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
  }

  Widget _buildRecommendedSection(int crossAxisCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recommended",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 23.0,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        recommendedList.isEmpty
            ? const Center(child: Text("No recommended products"))
            : GridView.builder(
                padding: const EdgeInsets.all(12.0),
                shrinkWrap: true,
                primary: false,
                itemCount: recommendedList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.8,
                  crossAxisCount: crossAxisCount,
                ),
                itemBuilder: (ctx, index) {
                  ProductModel product = recommendedList[index];
                  return InkWell(
                    onTap: () {
                      Routes().push(ProductDetails(singleProduct: product), context);
                    },
                    child: _buildProductItem(product),
                  );
                },
              ),
      ],
    );
  }

  Widget _buildProductGrid(int crossAxisCount) {
    return search.text.isNotEmpty && searchList.isEmpty
        ? const Center(child: Text("No Product Found"))
        : searchList.isNotEmpty
            ? _buildGridView(searchList, crossAxisCount)
            : productModelList.isEmpty
                ? const Center(child: Text("No products available"))
                : _buildGridView(productModelList, crossAxisCount);
  }

  Widget _buildGridView(List<ProductModel> products, int crossAxisCount) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GridView.builder(
        padding: const EdgeInsets.only(bottom: 50.0),
        shrinkWrap: true,
        primary: false,
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 0.8,
          crossAxisCount: crossAxisCount,
        ),
        itemBuilder: (ctx, index) {
          ProductModel product = products[index];
          return InkWell(
            onTap: () {
              Routes().push(ProductDetails(singleProduct: product), context);
            },
            child: _buildProductItem(product),
          );
        },
      ),
    );
  }
Widget _buildProductItem(ProductModel product) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),  
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 3,
          blurRadius: 8,
          offset: Offset(0, 5),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.image,
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,  
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            product.name,
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            maxLines: 1, 
          ),
          const SizedBox(height: 5),
          Text(
            "${(product.price*480).toInt()}\₸",
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1, 
          ),
        ],
      ),
    ),
  );
}

}