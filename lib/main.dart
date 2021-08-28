import 'package:crypto_news/provider/cryptoAndFiatProvider.dart';
import 'package:crypto_news/provider/news_provider.dart';
import 'package:crypto_news/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import './widget/bottom_navigation_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => CryptoAndFiatProvider()),
        ChangeNotifierProvider(create: (ctx) => NewsProvider()),
      ],
      child: Sizer(builder: (ctx, orientation, deviceType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {},
          home: SplashScreen(),
        );
      }),
    );
  }
}
