import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/di/repository_provider.dart';
import 'package:ecommerce_app/model/cart_model.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/repository/cart_repository/cart_repository.dart';
import 'package:ecommerce_app/view_model/auth_view_model.dart';
import 'package:ecommerce_app/view_model/cart_item_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final itemDescriptionProvider = AsyncNotifierProvider.family.autoDispose<
  ItemDescriptionViewModel,
  CartModel?,
  ProductModel
>(() => ItemDescriptionViewModel());

class ItemDescriptionViewModel
    extends AutoDisposeFamilyAsyncNotifier<CartModel?, ProductModel> {
  late final CartRepository cartRepository;
  late final userId;
  @override
  FutureOr<CartModel?> build(ProductModel productModel) async {
    cartRepository = ref.read(cartRepositoryProvider);
    userId = ref.read(authViewModelProvider.notifier).getCurrentUser()?.uid;
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
      await cartRepository.deleteFromCart(itemId, userId);
      final item = await cartRepository.getSingleCartItem(
        itemId: itemId,
        userId: userId,
      );
      state = AsyncData(null);
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
    state = AsyncData(cartModel);
    try {
      await cartRepository.updateCartItem(cartModel, userId);
      final item = await cartRepository.getSingleCartItem(
        userId: userId,
        itemId: cartModel.productModel.id,
      );
    } on FirebaseException catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    } catch (e, stackTrace) {
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
      state = AsyncData(cartModel);
      try {
        await await cartRepository.updateCartItem(cartModel!, userId);
        final item = await cartRepository.getSingleCartItem(
          userId: userId,
          itemId: cartModel.productModel.id,
        );
      } on FirebaseException catch (e, stackTrace) {
        state = AsyncError(e, stackTrace);
      } catch (e, stackTrace) {
        state = AsyncError(e, stackTrace);
      }
    }
    ref.read(cartItemViewProvider.notifier).refershCartItem();
  }

  // void isItemInCart(ProductModel productModel) async{
  //   state = AsyncLoading();
  //   try {
  //     final isInCart = await cartRepository.checkItemInCart(
  //         productModel.id.toString(), userId);
  //     state = AsyncData(isInCart);
  //   }catch (e,stackTrace){
  //     state = AsyncError(e,stackTrace);
  //   }
  // }
}
