import 'package:flutter/material.dart';
import 'package:shoply/Firebase/firebase_firestore.dart';
import 'package:shoply/constants/routes.dart';
import 'package:shoply/models/product_model.dart';
import 'package:shoply/screens/product_details.dart';

class Recommended extends StatelessWidget {
  const Recommended({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<ProductModel>>(
        future: FirebaseFirestoreHelper.instance
            .recommendProductsBasedOnFavorites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            print("Error: ${snapshot.error}");
            return Text("Error: ${snapshot.error}");
          } else {
            print(snapshot.data);
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return InkWell(
                  onTap: () {
                    Routes()
                        .push(ProductDetails(singleProduct: product), context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(product.image, height: 120, width: 120),
                        const SizedBox(height: 10),
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Rs: ${product.price}",
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
