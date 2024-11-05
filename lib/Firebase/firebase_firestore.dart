// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

import 'package:shoply/constants/constants.dart';
import 'package:shoply/models/category_model.dart';
import 'package:shoply/models/order_model.dart';
import 'package:shoply/models/product_model.dart';
import 'package:shoply/models/user_model.dart';

class FirebaseFirestoreHelper {
  static FirebaseFirestoreHelper instance = FirebaseFirestoreHelper();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Future<List<CategoryModel>> getCategories1() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore.collection("categories1").get();
      List<CategoryModel> categoriesList1 = querySnapshot.docs
          .map((e) => CategoryModel.fronJson(e.data()))
          .toList();

      return categoriesList1;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

  Future<List<ProductModel>> recommendProductsBasedOnFavorites() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    // Step 1: Fetch user's favorite products
    QuerySnapshot userFavoriteSnapshot = await _firebaseFirestore
        .collection("userInteractions")
        .doc(uid)
        .collection("interactions")
        .where("isFavourate", isEqualTo: true)
        .get();

    // Extract the product IDs from the user's favorites
    List<String> userFavoriteProductIds = userFavoriteSnapshot.docs
        .map((doc) => doc["productId"] as String)
        .toList();

    // Step 2: Find other users who favorited the same products
    Set<String> recommendedProductIds =
        {}; // Using a set to keep products unique
    for (var productId in userFavoriteProductIds) {
      QuerySnapshot similarFavoritesSnapshot = await _firebaseFirestore
          .collectionGroup("interactions") // Querying across all interactions
          .where("productId", isEqualTo: productId)
          .where("isFavourate", isEqualTo: true)
          .get();

      // Add each similar product ID to the recommendedProductIds set
      for (var interaction in similarFavoritesSnapshot.docs) {
        String similarProductId = interaction["productId"];
        recommendedProductIds.add(similarProductId);
        print("Added to recommendations: $similarProductId");
      }
    }

    // Step 3: Fetch details of recommended products
    List<ProductModel> recommendedProducts = [];
    for (var productId in recommendedProductIds) {
      QuerySnapshot productDocSnapshot = await _firebaseFirestore
          .collectionGroup("products")
          .where("id", isEqualTo: productId)
          .get();

      if (productDocSnapshot.docs.isNotEmpty) {
        var productDoc = productDocSnapshot.docs.first;
        Map<String, dynamic>? productData =
            productDoc.data() as Map<String, dynamic>?;

        if (productData != null &&
            productData["id"] != null &&
            productData["name"] != null &&
            productData["price"] != null &&
            productData["image"] != null &&
            productData["description"] != null &&
            productData["isFavourate"] != null) {
          recommendedProducts.add(ProductModel(
              image: productData["image"],
              id: productData["id"],
              name: productData["name"],
              price: productData["price"],
              description: productData["description"],
              isFavourate: productData["isFavourate"]));
        } else {
          print("Incomplete product data, skipping: ${productData}");
        }
      }
    }

    print(
        "Final recommendedProducts: ${recommendedProducts.map((p) => p.name).toList()}");

    return recommendedProducts;
  }

  Future<void> logUserFavoriteInteraction(
      String productId, bool isFavourate) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await _firebaseFirestore
        .collection("userInteractions")
        .doc(uid)
        .collection("interactions")
        .add({
      "productId": productId,
      "isFavourate": isFavourate,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  Future<List<ProductModel>> getProducts() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore.collectionGroup("products").get();
      List<ProductModel> productModelList = querySnapshot.docs
          .map((e) => ProductModel.fronJson(e.data()))
          .toList();

      return productModelList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

  Future<List<ProductModel>> getCategoryViewProduct(String id) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection("categories1")
              .doc(id)
              .collection("products")
              .get();
      List<ProductModel> productModelList = querySnapshot.docs
          .map((e) => ProductModel.fronJson(e.data()))
          .toList();

      return productModelList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

  Future<UserModel> getUserInformation() async {
    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await _firebaseFirestore
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .get();

    return UserModel.fromJson(querySnapshot.data()!);
  }

  Future<bool> uploadOrderedProductFirebase(
    List<ProductModel> list,
    BuildContext context,
    String payment,
  ) async {
    try {
      showLoaderDialog(context);
      double totalPrice = 0.0;
      for (var element in list) {
        totalPrice += element.price * element.qty!;
      }

      DocumentReference documentReference = _firebaseFirestore
          .collection("usersOrders")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("orders")
          .doc();
      DocumentReference admin =
          _firebaseFirestore.collection("orders").doc(documentReference.id);
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _firebaseFirestore.collection('users').doc(uid).get();
      Map<String, dynamic> userData = documentSnapshot.data()!;
      UserModel user = UserModel.fromJson((userData));

      admin.set({
        "products": list.map((e) => e.toJson()).toList(),
        "status": "pending",
        "userId": uid,
        "totalPrice": totalPrice,
        "payment": payment,
        "orderId": admin.id,
        "orderAddress": user.streetAddress,
      });
      documentReference.set({
        "userId": uid,
        "products": list.map((e) => e.toJson()),
        "status": "pending",
        "totalPrice": totalPrice,
        "payment": payment,
        "orderId": documentReference.id,
        "orderAddress": user.streetAddress,
      });
      Navigator.of(context, rootNavigator: true).pop();
      showMessage("Ordered Successfully");
      return true;
    } catch (e) {
      showMessage(e.toString());
      Navigator.of(context, rootNavigator: true).pop();
      return false;
    }
  }

  /// GET USERS ORDERS;
  Future<List<OrderModel>> getUserOrders() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection("usersOrders")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("orders")
              .get();
      List<OrderModel> orderList = querySnapshot.docs
          .map((element) => OrderModel.fronJson(element.data()))
          .toList();
      return orderList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

  void updateTokenFromFirebase() async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await _firebaseFirestore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "notification token": token,
      });
    }
  }

  Future<void> updateOrder(OrderModel orderModel, String update) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('usersOrders')
        .doc(uid)
        .collection('orders')
        .doc(orderModel.orderId)
        .update({
      'status': update,
    });
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(orderModel.orderId)
        .update({
      'status': update,
    });
  }
}
