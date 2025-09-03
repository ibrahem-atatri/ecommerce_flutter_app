import 'package:ecommerce_app/model/product_model.dart';

class CartModel {
  ProductModel productModel;
  int quantity;

  CartModel({required this.productModel, required this.quantity});

  factory CartModel.fromJson(json) {
    return CartModel(
      productModel: ProductModel.fromJson(json['productModel']),
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productModel': this.productModel.toMap(),
      'quantity': this.quantity,
    };
  }
}
