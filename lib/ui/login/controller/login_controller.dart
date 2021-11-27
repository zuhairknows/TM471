import 'package:barber_salon/utils/firebase_google_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../routes.dart';
import '../../../utils/extensions.dart';

class LoginController with ChangeNotifier {
  final BuildContext _context;

  String emailText = '';
  String passwordText = '';

  bool loading = false;

  ScaffoldMessengerState get _scaffoldMessenger => ScaffoldMessenger.of(_context);

  final service = FirebaseService();

  LoginController(
    this._context,
  );

  login() async {
    try {
      FocusScope.of(_context).unfocus();

      loading = true;

      notifyListeners();

      final result = await auth.signInWithEmailAndPassword(
        email: emailText,
        password: passwordText,
      );

      if (result.user != null && result.user!.emailVerified) {
        Navigator.of(_context).popUntil((route) => false);
        Navigator.of(_context).pushNamed(Routes.HOME);
      } else {
        _scaffoldMessenger.showMessageSnackBar('E-Mail not verified, please check inbox');

        await result.user!.sendEmailVerification();
        await auth.signOut();
      }
    } on FirebaseAuthException catch (e) {
      _scaffoldMessenger.showMessageSnackBar(e.code);

      loading = false;

      notifyListeners();
    }
  }

  loginWithGoogle() async {
    try {
      FocusScope.of(_context).unfocus();

      loading = true;

      notifyListeners();

      final result = await service.signInWithGoogle();

      if (result.user != null && result.user!.emailVerified) {
        Navigator.of(_context).popUntil((route) => false);
        Navigator.of(_context).pushNamed(Routes.HOME);
      } else {
        _scaffoldMessenger.showMessageSnackBar('E-Mail not verified, please check inbox');

        await result.user!.sendEmailVerification();
        await auth.signOut();
      }
    } on FirebaseAuthException catch (e) {
      _scaffoldMessenger.showMessageSnackBar(e.code);

      loading = false;

      notifyListeners();
    } on Exception catch(e) {
      _scaffoldMessenger.showMessageSnackBar(e.toString());

      loading = false;

      notifyListeners();
    }
  }
}
