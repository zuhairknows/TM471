import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../routes.dart';
import '../../../utils/extensions.dart';
import '../../../utils/firebase_google_helper.dart';

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

      //  check user type
      if (result.user != null && result.user!.emailVerified) {
        final userData = await firestore.collection('users').doc(result.user!.uid).get();

        final salon = userData.data()!['salon'] as DocumentReference<Map<String, dynamic>>?;

        final userDataMap = userData.data()!;
        userDataMap['salon'] = salon?.id;

        await firestore.collection('users').doc(result.user!.uid).update({
          'token': await messaging.getToken(),
        });

        await preferences.setString('user', jsonEncode(userDataMap));

        Navigator.of(_context).popUntil((route) => false);
        Navigator.of(_context).pushNamed(Routes.HOME);
      } else {
        // If the user is not E-Mail verified yet, resend a new verification email
        _scaffoldMessenger.showMessageSnackBar('E-Mail not verified, please check inbox');

        await result.user!.sendEmailVerification();
        await auth.signOut();
      }
    } on FirebaseAuthException catch (e) {
      _scaffoldMessenger.showMessageSnackBar(e.code);

      loading = false;

      notifyListeners();
    } on Exception catch (e) {
      _scaffoldMessenger.showMessageSnackBar(e.toString());

      if (auth.currentUser != null) await auth.signOut();

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
    } on Exception catch (e) {
      _scaffoldMessenger.showMessageSnackBar(e.toString());

      loading = false;

      notifyListeners();
    }
  }
}
