import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/di/repository_provider.dart';
import 'package:ecommerce_app/model/cart_model.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/repository/cart_repository/cart_repository.dart';
import 'package:ecommerce_app/ui/login_register/log_in_register_view_model.dart';
import 'package:ecommerce_app/ui/cart_item/cart_item_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productDetailProvider = AsyncNotifierProvider.family
    .autoDispose<ProductDetailViewModel, CartModel?, ProductModel>(
      () => ProductDetailViewModel(),
    );

class ProductDetailViewModel
    extends AutoDisposeFamilyAsyncNotifier<CartModel?, ProductModel> {
  CartRepository get cartRepository => ref.read(cartRepositoryProvider);
  TotalAmount get amountState => ref.read(totalAmountProvider.notifier);
  String? get userId => ref.read(logInRegisterViewModelProvider.notifier).getCurrentUser?.uid;
  double get amount => double.parse(ref.read(totalAmountProvider).value ?? '0.0');
  double totalAmount = 0.0;
  @override
  FutureOr<CartModel?> build(ProductModel productModel) async {
    totalAmount = amount;

    return await cartRepository.getSingleCartItem(
      userId: userId,
      itemId: productModel.id.toString(),
    );
  }

  Future<void> addToCart({prductModel}) async {
    state = AsyncLoading();
    try {
      await cartRepository.addToCart(prductModel, userId);
      final item = await cartRepository.getSingleCartItem(
        itemId: prductModel.id.toString(),
        userId: userId,
      );
      totalAmount = totalAmount + prductModel.price;
      await amountState.setAmount(amount: totalAmount);
      state = AsyncData(item);
    } on FirebaseException catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
    ref.read(cartItemViewProvider.notifier).refershCartItem();
  }

  Future<void> deleteFromCart({itemId}) async {
    state = AsyncLoading();
    try {
      final item = await cartRepository.getSingleCartItem(
        itemId: itemId,
        userId: userId,
      );
      await cartRepository.deleteFromCart(itemId, userId);
      if (item != null) {
        totalAmount = totalAmount - item.productModel.price;
      }
      state = AsyncData(null);
      await amountState.setAmount(amount: totalAmount);
    } on FirebaseException catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
    ref.read(cartItemViewProvider.notifier).refershCartItem();
  }

  Future<void> incrementQuantity({itemId}) async {
    CartModel? cartModel = await cartRepository.getSingleCartItem(
      userId: userId,
      itemId: itemId,
    );
    cartModel!.quantity++;
    totalAmount = totalAmount + cartModel.productModel.price;
    state = AsyncData(cartModel);
    try {
      await cartRepository.updateCartItem(cartModel, userId);
       await cartRepository.getSingleCartItem(
        userId: userId,
        itemId: cartModel.productModel.id,
      );
      await amountState.setAmount(amount: totalAmount);
    } on FirebaseException catch (e, stackTrace) {
      totalAmount = totalAmount - cartModel.productModel.price;
      state = AsyncError(e, stackTrace);
    } catch (e, stackTrace) {
      totalAmount = totalAmount - cartModel.productModel.price;
      state = AsyncError(e, stackTrace);
    }
    ref.read(cartItemViewProvider.notifier).refershCartItem();
  }

  Future<void> decrementQuantity({itemId}) async {
    CartModel? cartModel = await cartRepository.getSingleCartItem(
      userId: userId,
      itemId: itemId,
    );
    if (cartModel!.quantity == 1) {
      deleteFromCart(itemId: itemId);
      state = AsyncData(null);
    } else {
      cartModel.quantity--;
      totalAmount = totalAmount - cartModel.productModel.price;
      state = AsyncData(cartModel);
      try {
        await await cartRepository.updateCartItem(cartModel, userId);
         await cartRepository.getSingleCartItem(
          userId: userId,
          itemId: cartModel.productModel.id,
        );
        await amountState.setAmount(amount: totalAmount);
      } on FirebaseException catch (e, stackTrace) {
        totalAmount = totalAmount + cartModel.productModel.price;
        state = AsyncError(e, stackTrace);
      } catch (e, stackTrace) {
        totalAmount = totalAmount + cartModel.productModel.price;
        state = AsyncError(e, stackTrace);
      }
    }
    ref.read(cartItemViewProvider.notifier).refershCartItem();
  }
}
