import 'package:crypto_news/provider/cryptoAndFiatModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './widget/bottom_navigation_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => CryptoAndFiatModel(listModel: []),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {

        },
        home: Nav(),
      ),
    );
  }
}
