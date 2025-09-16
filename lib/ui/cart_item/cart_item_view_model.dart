import 'dart:async';
import 'package:ecommerce_app/di/repository_provider.dart';
import 'package:ecommerce_app/model/cart_model.dart';
import 'package:ecommerce_app/repository/cart_repository/cart_repository.dart';
import 'package:ecommerce_app/ui/login_register/log_in_register_view_model.dart';
import 'package:ecommerce_app/utils/error_handler/firebase_store_exception_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartItemViewProvider = AsyncNotifierProvider<CartItemViewModel, List<CartModel>>(
      () => CartItemViewModel(),
      dependencies: [logInRegisterViewModelProvider]
    );
final totalAmountProvider = AsyncNotifierProvider<TotalAmount, String>(() {
  return TotalAmount();
});

class CartItemViewModel extends AsyncNotifier<List<CartModel>> {
    CartRepository get cartRepository => ref.read(cartRepositoryProvider)  ;
  User? get currentUser => ref.read(logInRegisterViewModelProvider.notifier).getCurrentUser;
  TotalAmount get amountState => ref.read(totalAmountProvider.notifier);
  double get amount => double.parse(ref.read(totalAmountProvider).value??'0.0');
  ScrollController scrollController = ScrollController();
  double totalAmount = 0.0;
  bool isLoading = false;
  bool hasMore = true;

  @override
  FutureOr<List<CartModel>> build() async {
    scrollController.addListener(_scrollListener);
    try {
      List<CartModel> items = await cartRepository.getCartItem(
        currentUser?.uid,
      );
      if (items.isEmpty) {
        hasMore = false;
        items = [];
      }
      await amountState.totalAmount();
      totalAmount = amount;
      return items;
    } on FirebaseException catch (error) {
      throw FirebaseStoreExceptionUtils.firestoreExceptionMapper(error);
    } catch (error){
      throw error.toString();
    }
  }

    void _scrollListener() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        getCartItem();
      }
    }

    void dispose() {
      ref.onDispose(() {
        scrollController.removeListener(_scrollListener);
      },);
    }

  Future<void> getCartItem() async {

    if (state.isLoading || !hasMore || isLoading) {
      return;
    }
    isLoading = true;
    try {
      final newItems = await cartRepository.getCartItem(currentUser?.uid);
      final currentItems = state.value ?? [];

      if (newItems.isEmpty) {
        hasMore = false;
        state = AsyncData([...currentItems]);
      } else {
        if (newItems.length < 6) hasMore = false;
        state = AsyncData([...currentItems, ...newItems]);
      }
      await amountState.totalAmount();
      totalAmount = amount;
    } on FirebaseException catch (error, stackTrace) {
      state = AsyncError(FirebaseStoreExceptionUtils.firestoreExceptionMapper(error), stackTrace);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    } finally {
      isLoading = false;
    }
  }

  Future<void> refershCartItem() async {
    // hasMore = true; // Reset pagination state
    state = AsyncLoading();
    isLoading = true;
    hasMore = true;

    try {
      final items = await cartRepository.refreshCart(currentUser?.uid);
      state = AsyncData(items);
      if (items.isEmpty) {
        hasMore = false;
      } else {
        if (items.length < 6) hasMore = false;
        state = AsyncData(items);
      }
     await amountState.totalAmount();
      totalAmount = amount;
      isLoading = false;
    } on FirebaseException catch (error, stackTrace) {
      state = AsyncError(FirebaseStoreExceptionUtils.firestoreExceptionMapper(error), stackTrace);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    } finally {
      isLoading = false;
    }
  }

  Future<void> deleteFromCart(CartModel cartModel) async {
    final currentItems = state.value ?? [];

    final List<CartModel> updatedItems =
        currentItems.where((item) {
          return item.productModel.id != cartModel.productModel.id;
        }).toList();
    totalAmount = totalAmount - (cartModel.productModel.price * cartModel.quantity);
    state = AsyncData(updatedItems);
    try {
      await cartRepository.deleteFromCart(
        cartModel.productModel.id.toString(),
        currentUser?.uid,
      );
      await amountState.setAmount(amount: totalAmount);
    } on FirebaseException catch (error, stackTrace) {
      totalAmount = totalAmount + (cartModel.productModel.price * cartModel.quantity);
      state = AsyncData(currentItems);
      state = AsyncError(FirebaseStoreExceptionUtils.firestoreExceptionMapper(error), stackTrace);
    } catch (e, stackTrace) {
      totalAmount = totalAmount + (cartModel.productModel.price * cartModel.quantity);
      state = AsyncData(currentItems);
      state = AsyncError(e.toString(), stackTrace);
    }
  }

  Future<void> incrementCartItem(CartModel cartModel) async {
    cartModel.quantity++;
    final currentItems = state.value ?? [];
    final updatedItems =
        currentItems.map((item) {
          if (item.productModel.id == cartModel.productModel.id) {
            return cartModel;
          }
          return item;
        }).toList();
    totalAmount = totalAmount + cartModel.productModel.price;
    state = AsyncData(updatedItems);
    try {
      await cartRepository.updateCartItem(cartModel, currentUser?.uid);
      await amountState.setAmount(amount: totalAmount);
    } on FirebaseException catch (error, stackTrace) {
      totalAmount = totalAmount - cartModel.productModel.price;
      state = AsyncData(currentItems);
      state = AsyncError(FirebaseStoreExceptionUtils.firestoreExceptionMapper(error), stackTrace);
    } catch (e, stackTrace) {
      totalAmount = totalAmount - cartModel.productModel.price;
      state = AsyncData(currentItems);
      state = AsyncError(e.toString(), stackTrace);
    }
  }

  Future<void> decrementCartItem(CartModel cartModel) async {
    if (cartModel.quantity > 1) {
      cartModel.quantity--;
      final currentItems = state.value ?? [];
      final updatedItems =
          currentItems.map((item) {
            if (item.productModel.id == cartModel.productModel.id) {
              return cartModel;
            }
            return item;
          }).toList();
      totalAmount = totalAmount - cartModel.productModel.price;
      state = AsyncData(updatedItems);

      try {
        await cartRepository.updateCartItem(cartModel, currentUser?.uid);
        await amountState.setAmount(amount: totalAmount);
      } on FirebaseException catch (error, stackTrace) {
        totalAmount = totalAmount + cartModel.productModel.price;
        state = AsyncData(currentItems);
        state = AsyncError(FirebaseStoreExceptionUtils.firestoreExceptionMapper(error), stackTrace);
      } catch (e, stackTrace) {
        totalAmount = totalAmount + cartModel.productModel.price;
        state = AsyncData(currentItems);
        state = AsyncError(e.toString(), stackTrace);
      }
    }
  }
}

class TotalAmount extends AsyncNotifier<String> {
 CartRepository get cartRepository => ref.read(cartRepositoryProvider);

  @override
  FutureOr<String> build() async {
    // cartRepository = ref.read(cartRepositoryProvider);
    final currentUser = ref.watch(authStateProvider).value;

    try {
     double result = await cartRepository.getTotalAmount(uid: currentUser?.uid);
      return result.toStringAsFixed(2);
    } on FirebaseException catch(error) {
      throw FirebaseStoreExceptionUtils.firestoreExceptionMapper(error);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> totalAmount() async {
    final currentUser = ref.read(authStateProvider).value;
    try {
      double result = await cartRepository.getTotalAmount(uid: currentUser?.uid);
      state = AsyncData(result.toStringAsFixed(2));
    } on FirebaseException catch(error,stackTrace) {
      state = AsyncError(FirebaseStoreExceptionUtils.firestoreExceptionMapper(error),stackTrace);
    } catch (error, stackTrace) {
      state = AsyncError(FirebaseStoreExceptionUtils.firestoreExceptionMapper(error), stackTrace);
    }
  }

  Future<void> setAmount ({ amount})async {
    final currentUser = ref.read(authStateProvider).value;

    try {
       await cartRepository.setTotalAmount(uid: currentUser?.uid,amount: amount);
       await totalAmount();
    } on FirebaseException catch(error,stackTrace) {
      state = AsyncError(FirebaseStoreExceptionUtils.firestoreExceptionMapper(error), stackTrace);
    } catch (error, stackTrace) {
      state = AsyncError(FirebaseStoreExceptionUtils.firestoreExceptionMapper(error), stackTrace);
    }
  }
}






