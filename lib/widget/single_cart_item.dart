import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoply/models/product_model.dart';
import 'package:shoply/provider/app_provider.dart';

class SingleCartItem extends StatefulWidget {
  final ProductModel singleProduct;
  const SingleCartItem({super.key, required this.singleProduct});

  @override
  State<SingleCartItem> createState() => _SingleCartItemState();
}

class _SingleCartItemState extends State<SingleCartItem> {
  int qty = 1;

  @override
  void initState() {
    super.initState();
    qty = widget.singleProduct.qty ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                widget.singleProduct.image,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            // Product Details
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.singleProduct.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                      overflow: TextOverflow.ellipsis, 
                    ),
                    const SizedBox(height: 8),
                    // Quantity Controls
                    Row(
                      children: [
                        CupertinoButton(
                          onPressed: () {
                            if (qty > 1) {
                              setState(() {
                                qty--;
                              });
                              appProvider.updateQty(widget.singleProduct, qty);
                            }
                          },
                          padding: EdgeInsets.zero,
                          child: const CircleAvatar(
                            maxRadius: 13,
                            backgroundColor: Color.fromARGB(255, 155, 245, 201),
                            child: Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          qty.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(width: 8),
                        CupertinoButton(
                          onPressed: () {
                            setState(() {
                              qty++;
                            });
                            appProvider.updateQty(widget.singleProduct, qty);
                          },
                          padding: EdgeInsets.zero,
                          child: const CircleAvatar(
                            maxRadius: 13,
                            backgroundColor: Color.fromARGB(255, 155, 245, 201),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Price
                    Text(
                      "${widget.singleProduct.price.toString()} Tg",
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 1, 1, 1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Wishlist and Delete Buttons
            Column(
              children: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    if (!appProvider.getFavourateProductList
                        .contains(widget.singleProduct)) {
                      appProvider.addFavourateProductList(widget.singleProduct);
                      showMessage("Added to Wishlist");
                    } else {
                      appProvider.removeFavourateProductList(widget.singleProduct);
                      showMessage("Removed from Wishlist");
                    }
                  },
                  child: appProvider.getFavourateProductList
                          .contains(widget.singleProduct)
                      ? const Icon(
                          Icons.favorite,
                          color: Color.fromARGB(255, 155, 245, 201),
                        )
                      : const Icon(
                          Icons.favorite_border,
                          color: Color.fromARGB(255, 155, 245, 201),
                        ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    appProvider.removeCartProductList(widget.singleProduct);
                    showMessage("Removed from Cart");
                  },
                  child: const Icon(
                    Icons.delete,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
