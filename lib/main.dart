import 'package:crypto_news/provider/crypto_and_fiat_provider.dart';
import 'package:crypto_news/provider/crypto_market_data_provider.dart';
import 'package:crypto_news/provider/google_sign_in_provider.dart';
import 'package:crypto_news/provider/news_provider.dart';
import 'package:crypto_news/screen/sign_in_screen.dart';
import 'package:crypto_news/screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //ChangeNotifierProvider(create: (ctx) => BottomNavigationProvider()),
        ChangeNotifierProvider(create: (ctx) => GoogleSignInProvider()),
        ChangeNotifierProvider(create: (ctx) => CryptoAndFiatProvider()),
        ChangeNotifierProvider(create: (ctx) => NewsProvider()),
        ChangeNotifierProvider(create: (ctx) => CryptoMarketDataProvider()),
      ],
      child: Sizer(
        builder: (ctx, orientation, deviceType) {
          return const GetMaterialApp(
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}
