import 'dart:convert';

import 'package:crypto_news/helper/api_endpoints.dart';
import 'package:crypto_news/model/user_data_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class GoogleSignInProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User? user;

  Future<String?> signInwithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      user = userCredential.user;

      final url = "${ApiEndpoints.baseUrl}user/user";
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String?>{
          'name': user!.displayName,
          'emailId': user!.email,
          'photoUrl': user!.photoURL,
          'userUid': user!.uid
        }),
      );

      if (response.statusCode == 201) {
        print(
          UserDataModel.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>,
          ),
        );
      } else if (response.statusCode == 200) {
        print("User Already Exists!");
      } else {
        throw Exception('Failed to create User.');
      }
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
