import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../utils/extensions.dart';

class ForgotPasswordController with ChangeNotifier {
  final BuildContext _context;

  String emailText = '';

  ScaffoldMessengerState get _scaffoldMessenger => ScaffoldMessenger.of(_context);
  bool loading = false;

  ForgotPasswordController(
    this._context,
  );

  resetPassword() async {
    try {
      FocusScope.of(_context).unfocus();

      loading = true;

      notifyListeners();

      final result = await auth.sendPasswordResetEmail(
        email: emailText,
      );

      _scaffoldMessenger.showMessageSnackBar('Password reset email sent');
      Navigator.of(_context).pop();
    } on FirebaseAuthException catch (e) {
      _scaffoldMessenger.showMessageSnackBar(e.code);

      loading = false;

      notifyListeners();
    }
  }
}
