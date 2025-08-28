import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/cart_model.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/repository/cart_repository/cart_repository.dart';
import 'package:ecommerce_app/view_model/auth_view_model.dart';

class CartFirebase extends CartRepository {
  final firestore = FirebaseFirestore.instance.collection("carts");
  AuthViewModel authViewModel = AuthViewModel();
  @override
  Future<void> addToCart(ProductModel productModel,uid) async {
    try {
      final docRef = firestore // main collection
          .doc(uid) // user’s document
          .collection('cart_item') // subcollection
          .doc(productModel.id.toString());
      await docRef.set(CartModel(productModel: productModel, quantity: 1).toMap());
    } on FirebaseException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteFromCart(cartId, uid) async {
    try {
      await firestore
          .doc(uid)
          .collection('cart_item')
          .doc(cartId.toString())
          .delete();
    } on FirebaseException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CartModel>> getCartItem(uid) async {
    try {
      final data = await firestore.doc(uid).collection('cart_item').get();
      if(data.docs.isNotEmpty){
      final items =
      data.docs.map((item) {
            return CartModel.fromJson(item.data());
          }).toList();
      return items;}
      else return [];
    } on FirebaseException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CartModel?> getSingleCartItem({userId, itemId}) async {
    try {
      final data = await firestore.doc(userId).collection('cart_item').doc(itemId.toString()).get();
      if (data.exists) {
        final item = CartModel(productModel: ProductModel.fromJson(data.data()?['productModel']), quantity: data.data()?['quantity']);
        return item;
      }
      else return null;
    } on FirebaseException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }


  @override
  Future<void> updateCartItem(CartModel cartModel, uid) async {
    try {
      await firestore
          .doc(uid)
          .collection('cart_item')
          .doc(cartModel.productModel.id.toString())
          .update({'quantity': cartModel.quantity});
    } on FirebaseException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> checkItemInCart(itemId, uid) async {
    final item= await firestore.doc(uid).collection('cart_item').doc(itemId).get();
    return item.exists;

  }
}
