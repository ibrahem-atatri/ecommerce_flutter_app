import 'package:flutter_riverpod/flutter_riverpod.dart';

final mainViewModelProvider = StateNotifierProvider<MainViewModel,int>((ref) => MainViewModel(),);

class MainViewModel extends StateNotifier<int> {
  MainViewModel():super(0);
   void setCurrentPage (currentIndex)  {
    state =currentIndex;
  }
  void restPages(){
     state = 0;
  }
}

