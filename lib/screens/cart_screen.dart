import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoply/constants/constants.dart';
import 'package:shoply/provider/app_provider.dart';
import 'package:shoply/screens/cart_checkout.dart';
import 'package:shoply/widget/single_cart_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      bottomNavigationBar: Container(
        height: screenWidth < 600
            ? 200.0
            : 150.0, // Adjust height based on screen width
        decoration: const BoxDecoration(
          color: Colors.white
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "${appProvider.totalPrice().toString()}₸",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15.0),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  const Color.fromARGB(255, 155, 245, 201),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(42),
                    ),
                  ),
                  onPressed: () {
                    if (appProvider.getCartProductList.isEmpty) {
                      showMessage("Cart is Empty");
                    } else {
                      appProvider.clearBuyProduct();
                      appProvider.addBuyProductCartList();
                      appProvider.clearCart();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartItemCheckOut(),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "Checkout",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Your Cart",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: appProvider.getCartProductList.isEmpty
            ? const Center(
                child: Text(
                  "Yout Cart is Empty",
                  style: TextStyle(
              color: Color.fromARGB(255, 46, 187, 175),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
                ),
              )
            : ListView.builder(
                itemCount: appProvider.getCartProductList.length,
                padding: const EdgeInsets.all(12.0),
                itemBuilder: (ctx, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: SingleCartItem(
                      singleProduct: appProvider.getCartProductList[index],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
