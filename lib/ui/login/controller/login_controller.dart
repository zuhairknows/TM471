import 'package:barber_salon/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginController with ChangeNotifier {
  final BuildContext _context;

  String emailText = '';
  String passwordText = '';

  LoginController(
    this._context,
  );

  login() async {
    try {
      final result = await auth.signInWithEmailAndPassword(
        email: emailText,
        password: passwordText,
      );

      print(result);
    } on Exception catch (e) {
      print(e);
    }
  }
}
