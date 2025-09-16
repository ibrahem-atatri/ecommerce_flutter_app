import 'dart:async';
import 'package:dio/dio.dart';
import 'package:ecommerce_app/di/connectivity_providers.dart';
import 'package:ecommerce_app/di/repository_provider.dart';
import 'package:ecommerce_app/model/category_model.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/repository/product_repository/product_repository.dart';
import 'package:ecommerce_app/utils/error_handler/dio_exception_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeViewModelProvider =
    AsyncNotifierProvider<HomeViewModel, List<ProductModel>>(
      () => HomeViewModel(),
    );

class HomeViewModel extends AsyncNotifier<List<ProductModel>> {
   ProductRepository get productRepository =>ref.read(productRepositoryProvider);
     bool get internetState  => ref.watch(internetConnectionProvider).value!;
  List<ProductModel> allProducts = [];
  List<ProductModel> searchProducts = [];
  List<CategoryModel> categories = [
    CategoryModel(categoryName: 'All', clicked: true),
  ];

  @override
  FutureOr<List<ProductModel>> build() async {

    if ( internetState == false) {
      return [];}

      try {
        final products = await productRepository.getAllProduct();
        allProducts = products;
        return products;
      } on DioException catch (error) {
        throw DioExceptionUtils.DioExceptionMapper(error);
      }
      catch (error) {
        throw error.toString();
      }
  }

  List<CategoryModel> getCategory() {
    for (int i = 0; i < allProducts.length; i++) {
      String category = allProducts[i].category.split(' ').first;
      category = category[0].toUpperCase() + category.substring(1);
      bool test = categories.any((element) => element.categoryName == category);
      if (!test) {
        categories.add(CategoryModel(categoryName: category, clicked: false));
      }
    }
    return categories;
  }

  void filtterByCategory(category) {
    List<ProductModel> products = [];
    for (int i = 0; i < categories.length; i++) {
      if (category == categories[i].categoryName) {
        categories[i].clicked = true;
      } else {
        categories[i].clicked = false;
      }
    }
    if (category == 'All') {
      state = AsyncData(allProducts);
    } else {
      for (int i = 0; i < allProducts.length; i++) {
        String listCategory = allProducts[i].category.split(' ').first;
        listCategory =
            listCategory[0].toUpperCase() + listCategory.substring(1);
        if (listCategory == category) {
          products.add(allProducts[i]);
        }
      }
      if (products.isNotEmpty) state = AsyncData(products);
    }
  }

  void searchAboutProduct(String value) {
    if (value.isEmpty) {
      searchProducts = [];
    } else {
      searchProducts =
          allProducts.where((product) {
            return product.title.toLowerCase().contains(value.toLowerCase());
          }).toList();
    }
    filtterByCategory('All');
    state =
        searchProducts.isEmpty
            ? AsyncData(allProducts)
            : AsyncData(searchProducts);
  }
}
