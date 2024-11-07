import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoply/models/product_model.dart';
import 'package:shoply/provider/app_provider.dart';
import 'package:shoply/screens/cart_screen.dart';

class ProductDetails extends StatefulWidget {
  final ProductModel singleProduct;
  const ProductDetails({Key? key, required this.singleProduct}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int qty = 1;
  bool _imageMovedUp = false;

  @override
  void initState() {
    super.initState();
    // Start the timer to animate the image after a delay
    Timer(Duration(seconds: 2), () {
      setState(() {
        _imageMovedUp = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
           
          ),
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedPositioned(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeOut,
                          top: _imageMovedUp ? screenHeight * 0.1 : screenHeight * 0.2,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Image.network(
                              widget.singleProduct.image,
                              height: screenHeight * 0.25,
                              width: screenWidth * 0.8,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.singleProduct.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.06,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  widget.singleProduct.isFavourate = !widget.singleProduct.isFavourate;
                                });
                                if (widget.singleProduct.isFavourate) {
                                  appProvider.addFavourateProductList(widget.singleProduct);
                                } else {
                                  appProvider.removeFavourateProductList(widget.singleProduct);
                                }
                              },
                              icon: Icon(
                                appProvider.getFavourateProductList.contains(widget.singleProduct)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${widget.singleProduct.price}\₸",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.singleProduct.description,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: screenWidth * 0.045,
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CupertinoButton(
                              onPressed: () {
                                if (qty > 1) {
                                  setState(() {
                                    qty--;
                                  });
                                }
                              },
                              padding: EdgeInsets.zero,
                              child: const CircleAvatar(
                                backgroundColor: Color(0xFFF0F0F0),
                                child: Icon(Icons.remove, color: Colors.black),
                              ),
                            ),
                            const SizedBox(width: 30.0),
                            Text(
                              qty.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.05,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 30.0),
                            CupertinoButton(
                              onPressed: () {
                                setState(() {
                                  qty++;
                                });
                              },
                              padding: EdgeInsets.zero,
                              child: const CircleAvatar(
                                backgroundColor: Color(0xFFF0F0F0),
                                child: Icon(Icons.add, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 60.0),
                        SizedBox(
                          height: 48,
                          width: screenWidth * 0.9,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              ProductModel productModel = widget.singleProduct.copyWith(qty: qty);
                              appProvider.addCartProductList(productModel);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Added to Cart")),
                              );
                            },
                            child: Text(
                              "Add to Bag",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.05,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12.0),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
