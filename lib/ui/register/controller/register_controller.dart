import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../utils/extensions.dart';

class RegisterController with ChangeNotifier {
  final BuildContext _context;

  ScaffoldMessengerState get _scaffoldMessenger => ScaffoldMessenger.of(_context);

  bool loading = false;

  String emailText = '';
  String phoneNumberText = '';
  String passwordText = '';
  String confirmPasswordText = '';

  String firstNameText = '';
  String lastNameText = '';
  String city = '';

  int stage = 1;

  RegisterController(
    this._context,
  );

  validateStepOne() {
    String? message;

    _scaffoldMessenger.clearSnackBars();

    if (emailText.isEmpty ||
        !RegExp(r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$").hasMatch(emailText)) {
      message = 'Please enter a valid Email';
    } else if (phoneNumberText.isEmpty || !RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(phoneNumberText)) {
      message = 'Please enter a valid Phone Number';
    } else if (passwordText.isEmpty) {
      message = 'Please enter a password';
    } else if (confirmPasswordText != passwordText) {
      message = 'Passwords do not match';
    }

    if (message != null) {
      _scaffoldMessenger.showMessageSnackBar(message);
    } else {
      stage = 2;

      FocusScope.of(_context).unfocus();

      notifyListeners();
    }
  }

  bool validateStepTwo() {
    String? message;

    _scaffoldMessenger.clearSnackBars();

    if (firstNameText.isEmpty || lastNameText.isEmpty) {
      message = 'Please enter a name';
    } else if (city.isEmpty) {
      message = 'Please select a city';
    }

    if (message != null) {
      _scaffoldMessenger.showMessageSnackBar(message);
      return false;
    } else {
      FocusScope.of(_context).unfocus();
      return true;
    }
  }

  register() async {
    if (validateStepTwo()) {
      try {
        FocusScope.of(_context).unfocus();

        loading = true;

        notifyListeners();

        final result = await auth.createUserWithEmailAndPassword(
          email: emailText,
          password: passwordText,
        );

        if (result.user != null) {
          await firestore.collection('users').doc(result.user!.uid).set({
            'first_name': firstNameText,
            'last_name': lastNameText,
            'phone': phoneNumberText,
            'email': emailText,
            'city': city,
          });

          await result.user!.sendEmailVerification();

          await auth.signOut();

          _scaffoldMessenger.showMessageSnackBar('Register successful! Verification email sent');

          Navigator.of(_context).pop();
        }
      } on FirebaseAuthException catch (e) {
        _scaffoldMessenger.showMessageSnackBar(e.code);

        loading = false;

        notifyListeners();
      }
    }
  }
}

const addressValues = [
  'Jeddah',
  'Riyadh',
  'Medina',
];
