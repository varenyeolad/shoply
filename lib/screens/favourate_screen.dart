import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoply/provider/app_provider.dart';
import 'package:shoply/widget/single_favourate_item.dart';

class FavourateScreen extends StatelessWidget {
  const FavourateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 46, 187, 175)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          "Favorites",
          style: TextStyle(
            color: Color.fromARGB(255, 46, 187, 175),
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 252, 252, 252),
              Colors.white,
            ],
          ),
        ),
        child: appProvider.getFavourateProductList.isEmpty
            ? _buildEmptyState()
            : _buildFavouritesList(appProvider, screenWidth),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Text(
            "No Favorite Products Yet",
            style: TextStyle(
              color: Color.fromARGB(255, 46, 187, 175),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Start adding your favorite products!",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavouritesList(AppProvider appProvider, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: ListView.builder(
        itemCount: appProvider.getFavourateProductList.length,
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (ctx, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(8.0),
              shadowColor: Colors.black26,
              child: SingleFavourateItem(
                singleProduct: appProvider.getFavourateProductList[index],
              ),
            ),
          );
        },
      ),
    );
  }
}
