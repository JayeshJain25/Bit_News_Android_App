import 'package:crypto_news/provider/google_sign_in_provider.dart';
import 'package:crypto_news/widget/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final provider =
                Provider.of<GoogleSignInProvider>(context, listen: false);
            await provider.signInwithGoogle();
            Get.to(() => AppBottomNavigationBar());
          },
          child: const Text("Google Sign In"),
        ),
      ),
    );
  }
}
