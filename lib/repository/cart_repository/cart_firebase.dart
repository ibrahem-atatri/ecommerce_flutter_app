import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/cart_model.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/repository/cart_repository/cart_repository.dart';
import 'package:ecommerce_app/ui/login_register/log_in_register_view_model.dart';

class CartFirebase extends CartRepository {
  final firestore = FirebaseFirestore.instance.collection("carts");
  DocumentSnapshot? lastSnapShot;
  LogInRegisterViewModel authViewModel = LogInRegisterViewModel();

  @override
  Future<void> addToCart(ProductModel productModel, uid) async {
    final docRef = firestore // main collection
        .doc(uid) // user’s document
        .collection('cart_item') // subcollection
        .doc(productModel.id.toString());
    await docRef.set(
      CartModel(productModel: productModel, quantity: 1).toMap(),
    );
  }

  @override
  Future<void> deleteFromCart(cartId, uid) async {
    await firestore
        .doc(uid)
        .collection('cart_item')
        .doc(cartId.toString())
        .delete();
  }

  @override
  Future<List<CartModel>> getAllItem(uid) async {
    Query query =
        firestore.doc(uid).collection('cart_item').orderBy('productModel.id');

    final data = await query.get();
    if (data.docs.isEmpty) {
      return [];
    }

    final items = data.docs.map((item) {
      return CartModel.fromJson(item.data());
    }).toList();

    return items;
  }

  @override
  Future<List<CartModel>> getCartItem(uid) async {
    Query query = firestore
        .doc(uid)
        .collection('cart_item')
        .orderBy('productModel.id')
        .limit(6);
    if (lastSnapShot != null) {
      query = query.startAfterDocument(lastSnapShot!);
    }
    final data = await query.get();
    if (data.docs.isEmpty) {
      return [];
    }

    lastSnapShot = data.docs.last;

    final items = data.docs.map((item) {
      return CartModel.fromJson(item.data());
    }).toList();

    return items;
  }

  @override
  Future<List<CartModel>> refreshCart(uid) async {
    Query query = firestore
        .doc(uid)
        .collection('cart_item')
        .orderBy('productModel.id')
        .limit(6);
    lastSnapShot = null;
    final data = await query.get();
    if (data.docs.isEmpty) {
      return [];
    }
    lastSnapShot = data.docs.last;

    final items = data.docs.map((item) {
      return CartModel.fromJson(item.data());
    }).toList();
    return items;
  }

  @override
  Future<CartModel?> getSingleCartItem({userId, itemId}) async {
    final data = await firestore
        .doc(userId)
        .collection('cart_item')
        .doc(itemId.toString())
        .get();
    if (data.exists) {
      final item = CartModel(
        productModel: ProductModel.fromJson(data.data()?['productModel']),
        quantity: data.data()?['quantity'],
      );
      return item;
    }
    return null;
  }

  @override
  Future<void> updateCartItem(CartModel cartModel, uid) async {
    await firestore
        .doc(uid)
        .collection('cart_item')
        .doc(cartModel.productModel.id.toString())
        .update({'quantity': cartModel.quantity});
  }

  @override
  Future<bool> checkItemInCart(itemId, uid) async {
    final item =
        await firestore.doc(uid).collection('cart_item').doc(itemId).get();
    return item.exists;
  }

  @override
  Future<double> getTotalAmount({uid}) async {
    final amount = await firestore.doc(uid).get();
    double totalAmount = amount.data()?['total_amount'] ?? 0.0;
    return totalAmount;
  }

  @override
  Future<void> setTotalAmount({uid, amount}) async {
    final docRefAmount = firestore.doc(uid);
    await docRefAmount.set({"total_amount": amount});
  }
}
