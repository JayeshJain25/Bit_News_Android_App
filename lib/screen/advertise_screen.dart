import 'package:crypto_news/model/contact_us_model.dart';
import 'package:crypto_news/provider/google_sign_in_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 50,
                ),
                TextFormField(
                  controller: nameText,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.person),
                    hintText: 'Enter your project name',
                    labelText: 'Project Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0),
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
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  controller: emailText,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.email),
                    hintText: 'Enter your email address',
                    labelText: 'Email ID',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0),
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
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  controller: websiteText,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.web),
                    hintText: 'Enter your project website',
                    labelText: 'Project Website',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0),
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
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  controller: descriptionText,
                  minLines: 1,
                  maxLines: 15,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(500),
                  ],
                  decoration: InputDecoration(
                    icon: const Icon(Icons.description),
                    hintText: 'Enter your project description',
                    labelText: 'Project Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0),
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
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  controller: budgetText,
                  minLines: 1,
                  maxLines: 15,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(500),
                  ],
                  decoration: InputDecoration(
                    icon: const Icon(Icons.monetization_on),
                    hintText: 'Enter your project budget',
                    labelText: 'Project Budget',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0),
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
                Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Data is in processing.'),
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
                      child: const Text('Submit'),
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
