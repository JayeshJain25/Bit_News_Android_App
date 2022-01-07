import 'dart:convert';

import 'package:crypto_news/helper/api_endpoints.dart';
import 'package:crypto_news/model/contact_us_model.dart';
import 'package:crypto_news/model/user_data_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class GoogleSignInProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User? user;
  late UserDataModel userModel;

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

      final url = "${ApiEndpoints.baseUrl}user/user?userUid=${user!.uid}";
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'name': user!.displayName,
          'emailId': user!.email,
          'photoUrl': user!.photoURL,
          'userUid': user!.uid,
          "favoriteCoins": [],
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final r = json.decode(response.body) as List<dynamic>;
        if (r.isEmpty) {
          userModel = const UserDataModel(
            name: "",
            emailId: "",
            favoriteCoins: [],
            photoUrl: "",
            userUid: "",
          );
        } else {
          userModel = UserDataModel.fromJson(
            r[0] as Map<String, dynamic>,
          );
        }
      } else {
        throw Exception('Failed to create User.');
      }
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> getUserData(
    String uid,
  ) async {
    final url = "${ApiEndpoints.baseUrl}user/get-user-data?userUid=$uid";
    try {
      final response = await http.get(
        Uri.parse(url),
      );
      final r = json.decode(response.body) as List<dynamic>;
      if (r.isEmpty) {
        userModel = const UserDataModel(
          name: "",
          emailId: "",
          favoriteCoins: [],
          photoUrl: "",
          userUid: "",
        );
      } else {
        userModel = UserDataModel.fromJson(
          r[0] as Map<String, dynamic>,
        );
      }

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<void> addContactUsData(
    ContactUsModel contactUs,
  ) async {
    final url = "${ApiEndpoints.baseUrl}user/contact-us";
    try {
      await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'projectName': contactUs.projectName,
          'emailId': contactUs.emailId,
          'projectWebsite': contactUs.projectWebsite,
          'projectDescription': contactUs.projectDescription,
          'budget': contactUs.budget
        }),
      );

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
