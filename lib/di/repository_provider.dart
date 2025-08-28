import 'package:ecommerce_app/repository/authentication_repository/auth_firebase.dart';
import 'package:ecommerce_app/repository/authentication_repository/auth_repository.dart';
import 'package:ecommerce_app/repository/cart_repository/cart_firebase.dart';
import 'package:ecommerce_app/repository/cart_repository/cart_repository.dart';
import 'package:ecommerce_app/repository/product_repository/product_api.dart';
import 'package:ecommerce_app/repository/product_repository/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthFirebase(),
);
final cartRepositoryProvider = Provider<CartRepository>(
  (ref) => CartFirebase(),
);
final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductApi(),
);

