import 'package:crypto_news/provider/cryptoAndFiatProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import './widget/bottom_navigation_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => CryptoAndFiatProvider(),
      child: Sizer(builder: (ctx, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {},
          home: Nav(),
        );
      }),
    );
  }
}
