import 'package:flutter/material.dart';

import './widget/bottom_navigation_bar.dart';

void main() {
  runApp(Nav());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
      },
    );
  }
}
