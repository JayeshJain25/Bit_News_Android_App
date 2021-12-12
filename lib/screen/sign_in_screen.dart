import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/provider/google_sign_in_provider.dart';
import 'package:crypto_news/widget/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool signUpComplete = false;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF010101),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 400,
                width: width * 0.85,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl:
                      "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/sign_up_screen.gif?alt=media&token=e05e2532-6207-4c73-812c-930b03bfb3b9",
                ),
              ),
              const SizedBox(
                height: 250,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  minimumSize:
                      MaterialStateProperty.all<Size>(const Size(120, 55)),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    signUpComplete
                        ? const Color(0xFF00fa89)
                        : const Color(0xFF16151a),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                onPressed: () async {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  await provider.signInwithGoogle().then((value) {
                    setState(() {
                      signUpComplete = true;
                    });
                    Get.off(() => AppBottomNavigationBar());
                  });
                },
                child: signUpComplete
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Sign up Completed",
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF006230),
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(
                              Icons.check,
                              color: Color(0xFF006230),
                            )
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "lib/assets/google.png",
                              height: 20,
                              width: 20,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Sign up with Google",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
