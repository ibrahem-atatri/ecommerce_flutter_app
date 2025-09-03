import 'package:ecommerce_app/model/product_model.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> getAllProduct();
  Future<ProductModel> getProduct();
}
