import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/model/contact_us_model.dart';
import 'package:crypto_news/provider/google_sign_in_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AdvertiseScreen extends StatefulWidget {
  @override
  State<AdvertiseScreen> createState() => _AdvertiseScreenState();
}

class _AdvertiseScreenState extends State<AdvertiseScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameText = TextEditingController();
  final emailText = TextEditingController();
  final descriptionText = TextEditingController();
  final websiteText = TextEditingController();
  final budgetText = TextEditingController();

  void clearText() {
    nameText.clear();
    emailText.clear();
    descriptionText.clear();
    websiteText.clear();
    budgetText.clear();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "List Your Project",
          style: GoogleFonts.roboto(
            color: Colors.black,
            fontSize: 25,
          ),
        ),
        elevation: 10,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl:
                      "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/conact_us.png?alt=media&token=4e5d330d-169b-406d-9a4b-9fb1e788de6f",
                  height: 270,
                  width: width,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: AutoSizeText(
                    "Submit your project details to get listed in the featured section of our app. We will revert to you within 24 hours.",
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.only(top: 15, bottom: 5),
                    width: width,
                    color: Colors.black,
                    child: Column(
                      children: [
                        AutoSizeText(
                          "You can also write to us at :",
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        AutoSizeText(
                          "help.cryptox@gmail.com",
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: TextFormField(
                    controller: nameText,
                    decoration: InputDecoration(
                      // icon: const Icon(Icons.person),
                      hintText: 'Enter your project name',
                      labelText: 'Project Name',

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter project name';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: TextFormField(
                    controller: emailText,
                    decoration: InputDecoration(
                      //    icon: const Icon(Icons.email),
                      hintText: 'Enter your email address',
                      labelText: 'Email ID',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter valid email address';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: TextFormField(
                    controller: websiteText,
                    decoration: InputDecoration(
                      //    icon: const Icon(Icons.web),
                      hintText: 'Enter your project website',
                      labelText: 'Project Website',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    keyboardType: TextInputType.url,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your project website';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: TextFormField(
                    controller: descriptionText,
                    minLines: 1,
                    maxLines: 15,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(500),
                    ],
                    decoration: InputDecoration(
                      //   icon: const Icon(Icons.description),
                      hintText: 'Enter your project description',
                      labelText: 'Project Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your project description';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: TextFormField(
                    controller: budgetText,
                    minLines: 1,
                    maxLines: 15,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(500),
                    ],
                    decoration: InputDecoration(
                      //    icon: const Icon(Icons.monetization_on),
                      hintText: 'Enter your project budget',
                      labelText: 'Project Budget',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your project budget';
                      }
                      return null;
                    },
                  ),
                ),
                Center(
                  child: Container(
                    width: width * 0.55,
                    height: height * 0.06,
                    margin: const EdgeInsets.only(
                      bottom: 15,
                      top: 50,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Thank You, We will be in touch shortly',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                          );
                          final ContactUsModel model = ContactUsModel(
                            projectName: nameText.text,
                            emailId: emailText.text,
                            projectWebsite: websiteText.text,
                            projectDescription: descriptionText.text,
                            budget: budgetText.text,
                          );
                          Provider.of<GoogleSignInProvider>(
                            context,
                            listen: false,
                          )
                              .addContactUsData(model)
                              .then((value) => clearText());
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFF52CAF5),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              7.0,
                            ),
                          ),
                        ),
                      ),
                      child: Text(
                        "Submit",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
