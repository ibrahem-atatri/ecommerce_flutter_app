import 'dart:async';
import 'package:ecommerce_app/di/repository_provider.dart';
import 'package:ecommerce_app/model/cart_model.dart';
import 'package:ecommerce_app/repository/cart_repository/cart_repository.dart';
import 'package:ecommerce_app/view_model/auth_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartItemViewProvider =
    AsyncNotifierProvider<CartItemViewModel, List<CartModel>>(
      () => CartItemViewModel(),
    );
final totalAmountProvider = AsyncNotifierProvider<TotalAmount, String>(() {
  return TotalAmount();
});

class CartItemViewModel extends AsyncNotifier<List<CartModel>> {
  late final CartRepository cartRepository = ref.read(cartRepositoryProvider);
  late final User? currentUser = ref.read(authViewModelProvider.notifier).getCurrentUser();
  late final amountState = ref.read(totalAmountProvider.notifier);
  late double totalAmount = double.parse(ref.read(totalAmountProvider).value??'0.0');
  bool isLoading = false;
  bool hasMore = true;

  @override
  FutureOr<List<CartModel>> build() async {
    // cartRepository = ref.read(cartRepositoryProvider);

    try {
      List<CartModel> items = await cartRepository.getCartItem(
        currentUser?.uid,
      );
      if (items.isEmpty) {
        hasMore = false;
        items = [];
      }
      await amountState.totalAmount();
      return items;
    } on FirebaseException catch (e, StackTrace) {
      rethrow;
    }
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
        await amountState.totalAmount();
        state = AsyncData([...currentItems, ...newItems]);
      }
      await amountState.totalAmount();
    } on FirebaseException catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
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
        await amountState.totalAmount();
        state = AsyncData(items);
      }
     await amountState.totalAmount();
      isLoading = false;
    } on FirebaseException catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
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
    } on FirebaseException catch (e, stackTrace) {
      totalAmount = totalAmount + (cartModel.productModel.price * cartModel.quantity);
      state = AsyncData(currentItems);
      state = AsyncError(e, stackTrace);
    } catch (e, stackTrace) {
      totalAmount = totalAmount + (cartModel.productModel.price * cartModel.quantity);
      state = AsyncData(currentItems);
      state = AsyncError(e, stackTrace);
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
    } on FirebaseException catch (e, stackTrace) {
      totalAmount = totalAmount - cartModel.productModel.price;
      state = AsyncData(currentItems);
      state = AsyncError(e, stackTrace);
    } catch (e, stackTrace) {
      totalAmount = totalAmount - cartModel.productModel.price;
      state = AsyncData(currentItems);
      state = AsyncError(e, stackTrace);
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
      } on FirebaseException catch (e, stackTrace) {
        totalAmount = totalAmount + cartModel.productModel.price;
        state = AsyncData(currentItems);
        state = AsyncError(e, stackTrace);
      } catch (e, stackTrace) {
        totalAmount = totalAmount + cartModel.productModel.price;
        state = AsyncData(currentItems);
        state = AsyncError(e, stackTrace);
      }
    }
  }
}

class TotalAmount extends AsyncNotifier<String> {
  late final CartRepository cartRepository;
  late final User? currentUser;

  @override
  FutureOr<String> build() async {
    cartRepository = ref.read(cartRepositoryProvider);
    currentUser = ref.read(authViewModelProvider.notifier).getCurrentUser();
    try {
     double result = await cartRepository.getTotalAmount(uid: currentUser?.uid);
      return result.toStringAsFixed(2);
    } on FirebaseException {
      rethrow;
    } catch (e, StackTrace) {
      rethrow;
    }
  }

  Future<void> totalAmount() async {
    try {
      double result = await cartRepository.getTotalAmount(uid: currentUser?.uid);
      state = AsyncData(result.toStringAsFixed(2));
    } on FirebaseException {
      rethrow;
    } catch (e, StackTrace) {
      rethrow;
    }
  }

  Future<void> setAmount ({ amount})async {
    try {
       await cartRepository.setTotalAmount(uid: currentUser?.uid,amount: amount);
       await totalAmount();
    } on FirebaseException {
      rethrow;
    } catch (e, StackTrace) {
      rethrow;
    }
  }
}
