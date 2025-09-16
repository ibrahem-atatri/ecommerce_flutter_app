import 'package:ecommerce_app/ui/cart_item/cart_item_view.dart';
import 'package:ecommerce_app/ui/home/home_view.dart';
import 'package:ecommerce_app/ui/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ecommerceAppViewModelProvider = StateNotifierProvider<EcommerceAppViewModel,int>((ref) => EcommerceAppViewModel(),);

class EcommerceAppViewModel extends StateNotifier<int> {
  final List<Widget> pages = [
    HomeView(),
    CartItemView(),
    ProfileView(),
  ];
  final List<Map<String,dynamic>> bottomNavItems = [
    {
    'label':HomeView.pageLabel,
    'icon':HomeView.pageIcon,
    },
    {
    'label':CartItemView.pageLabel,
    'icon':CartItemView.pageIcon,
    },
    {
      'label':ProfileView.pageLabel,
      'icon':ProfileView.pageIcon,
    }  ];
  EcommerceAppViewModel():super(0);
   void setCurrentPage (currentIndex)  {
    state =currentIndex;
  }
  void restPages(){
     state = 0;
  }
  void goTo(int page){
     state = page;
  }
}

