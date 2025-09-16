import 'package:dio/dio.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/repository/product_repository/product_repository.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: 'https://fakestoreapi.com/',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36',
    },
  ),
);

class ProductApi extends ProductRepository {
  @override
  Future<List<ProductModel>> getAllProduct() async {
    List<ProductModel> products = [];
      final response = await dio.get('products');
      final data = response.data as List;
      products =
          data.map((product) {
            return ProductModel.fromJson(product);
          }).toList();
    return products;
  }

  @override
  Future<ProductModel> getProduct() {
    // TODO: implement getProduct
    throw UnimplementedError();
  }
}
