import 'dart:async';
import 'package:ecommerce_app/di/repository_provider.dart';
import 'package:ecommerce_app/model/cart_model.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/repository/cart_repository/cart_repository.dart';
import 'package:ecommerce_app/view_model/auth_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartItemViewProvider = AsyncNotifierProvider<CartItemViewModel,List<CartModel>>(() => CartItemViewModel(),);

class CartItemViewModel extends AsyncNotifier<List<CartModel>> {
  late final CartRepository cartRepository;
  late final User? currentUser ;
  @override
  FutureOr<List<CartModel>> build() async {
    currentUser = ref.read(authViewModelProvider.notifier).getCurrentUser();
    cartRepository = ref.read(cartRepositoryProvider);

    try{
      final items =await cartRepository.getCartItem(currentUser?.uid);
      return items.length == 0 ? []:items;
    }on FirebaseException catch(e,StackTrace){
      rethrow;
    }


  }

  Future<void> refershCartItem() async {
    try {
      final items = await cartRepository.getCartItem(currentUser?.uid);
      state = AsyncData(items);
    } on FirebaseException catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }


  Future<void> addToCart(ProductModel prductModel) async {
    try {
      await cartRepository.addToCart(prductModel, currentUser?.uid);
      final items = await cartRepository.getCartItem(currentUser?.uid);
      state = AsyncData(items);
    } on FirebaseException catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> deleteFromCart(String cartId) async {
    try {
      await cartRepository.deleteFromCart(cartId, currentUser?.uid);
      final items = await cartRepository.getCartItem(currentUser?.uid);
      state = AsyncData(items);
    } on FirebaseException catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> incrementCartItem(CartModel cartModel) async {
    cartModel.quantity++;
    try {
      await cartRepository.updateCartItem(cartModel, currentUser?.uid);
      final items = await cartRepository.getCartItem(currentUser?.uid);
      state = AsyncData( items);
    } on FirebaseException catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> decrementCartItem(CartModel cartModel) async {
    if(cartModel.quantity > 1){
      cartModel.quantity--;
      try {
        await cartRepository.updateCartItem(cartModel, currentUser?.uid);
        final items = await cartRepository.getCartItem(currentUser?.uid);
        state = AsyncData( items);
      } on FirebaseException catch (e, stackTrace) {
        state = AsyncError(e, stackTrace);
      } catch (e, stackTrace) {
        state = AsyncError(e, stackTrace);
      }
    }

  }

  String totalAmount()  {
    double result = 0.0;
    final items = state.value;
    for(var item in items!){
      result = result + (item.quantity * item.productModel.price);
    }
    return result.toStringAsFixed(2);

  }
}
