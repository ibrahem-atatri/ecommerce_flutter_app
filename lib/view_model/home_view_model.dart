import 'dart:async';
import 'package:dio/dio.dart';
import 'package:ecommerce_app/di/connectivity_providers.dart';
import 'package:ecommerce_app/di/repository_provider.dart';
import 'package:ecommerce_app/model/category_model.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/repository/product_repository/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeViewModelProvider = AsyncNotifierProvider<HomeViewModel,List<ProductModel>>(() => HomeViewModel(),);

class HomeViewModel extends AsyncNotifier<List<ProductModel>>{
  late final ProductRepository productRepository;
  late final internetState;
  List<ProductModel> allProducts = [];
  List<ProductModel> searchProducts = [];
  List<CategoryModel> categories=[CategoryModel(categoryName: 'All', clicked: true),];


  @override
  FutureOr<List<ProductModel>> build() async{
    productRepository = ref.read(productRepositoryProvider);
    internetState = ref.watch(internetConnectionProvider);
    if(internetState == true){
    try{
    final products= await productRepository.getAllProduct();
    state = AsyncData(products);
    allProducts = products ;
    return products;}
        on DioException catch(e){
      throw AsyncError(e, e.stackTrace);
        }  catch (e){
      throw e;
    }} else{
      return [];
    }

  }

  List<CategoryModel> getCategory(){
   for(int i =0 ;i<allProducts.length;i++){
     String category = allProducts[i].category.split(' ').first;
     category = category[0].toUpperCase() + category.substring(1);
     bool test = categories.any((element) => element.categoryName == category,);
     if(!test){
       categories.add(CategoryModel(categoryName: category, clicked: false));
     }

   }
    return categories;
  }
  
  void filtterByCategory(category){
    List<ProductModel> products = [];
    for(int i=0;i<categories.length;i++){
      if(category == categories[i].categoryName)
        categories[i].clicked = true;
      else
        categories[i].clicked=false;
    }
    if(category == 'All'){
      state = AsyncData(allProducts);

    }else{

    for(int i=0;i<allProducts.length;i++){
      String listCategory = allProducts[i].category.split(' ').first;
      listCategory = listCategory[0].toUpperCase() + listCategory.substring(1);
      if(listCategory == category){
        products.add(allProducts[i]);
      }
    }
    if(products.length!=0)
    state = AsyncData(products);}
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
   state =  searchProducts.length == 0? AsyncData(allProducts):AsyncData(searchProducts);
  }
  
}