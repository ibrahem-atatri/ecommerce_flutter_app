import 'package:ecommerce_app/model/cart_model.dart';
import 'package:ecommerce_app/model/product_model.dart';

abstract class CartRepository {
  Future<void> addToCart(ProductModel productModel, uid);
  Future<void> deleteFromCart(String cartId, uid);
  Future<List<CartModel>> getAllItem(uid);
  Future<List<CartModel>> getCartItem(uid);
  Future<List<CartModel>> refreshCart(uid);
  Future updateCartItem(CartModel cartModel, uid);
  Future<bool> checkItemInCart(String itemId, uid);
  Future<CartModel?> getSingleCartItem({userId, itemId});
  Future<double> getTotalAmount({uid});
  Future<void> setTotalAmount({uid,amount});
}
