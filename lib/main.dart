import 'package:ecommerce_app/app/ecommerce_app.dart';
import 'package:ecommerce_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// cLtzv7ypYB8qrsH5XAUVHMC9Rcs=
// eKJJHinr+D3pnrXYFuIJnPbO7ag=


void main() async {
  // debugPaintSizeEnabled:true;
  // debugPaintPointersEnabled:true;
  // debugRepaintRainbowEnabled:true;
   WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await FirebaseAuth.instance.useAuthEmulator('10.0.2.2', 9099);
  runApp(ProviderScope(child: EcommerceApp()));

}


