import 'dart:convert';

import 'package:async/async.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../utils/extensions.dart';
import '../../../widget/loading_dialog.dart';

class ProfileController with ChangeNotifier {
  CancelableOperation? _request;
  final BuildContext _context;

  final TextEditingController emailText = TextEditingController();
  final TextEditingController firstNameText = TextEditingController();
  final TextEditingController lastNameText = TextEditingController();
  final TextEditingController phoneNumberText = TextEditingController();
  String _city = '';

  String get city => _city;

  set city(String value) {
    _city = value;

    notifyListeners();
  }

  Map<String, dynamic>? userData;

  Exception? error;

  bool editing = false;

  ScaffoldMessengerState get _scaffoldMessenger =>
      ScaffoldMessenger.of(_context);

  ProfileController(
    this._context,
  ) {
    getUserData();
  }

  getUserData() {
    _request = CancelableOperation.fromFuture(_getUserData());
  }

  _getUserData() async {
    try {
      if (error != null) {
        error = null;
        notifyListeners();
      }

      final response =
          await firestore.collection('users').doc(auth.currentUser!.uid).get();

      userData = response.data();
      userData!.remove('salon');

      _mapUserData();
    } on Exception catch (e) {
      error = e;
    }

    notifyListeners();
  }

  _mapUserData() {
    emailText.text = userData!['email'];
    firstNameText.text = userData!['first_name'];
    lastNameText.text = userData!['last_name'];
    phoneNumberText.text = userData!['phone'];
    _city = userData!['city'];
  }

  startEdit() {
    editing = true;

    notifyListeners();
  }

  cancelEdit() {
    editing = false;

    _mapUserData();

    FocusScope.of(_context).unfocus();

    notifyListeners();
  }

  updateProfile() {
    FocusScope.of(_context).unfocus();

    String? message;

    if (firstNameText.text.isEmpty || lastNameText.text.isEmpty) {
      message = 'Please enter a name';
    } else if (phoneNumberText.text.isEmpty ||
        !RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(phoneNumberText.text)) {
      message = 'Please enter a valid Phone Number';
    }

    if (message != null) {
      _scaffoldMessenger.showMessageSnackBar(message);
      return;
    }

    showDialog(
      context: _context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: LoadingDialog(
          future: _updateProfile(),
          message: 'Updating Profile...',
        ),
      ),
    ).then((value) {
      if (value is Exception) {
        _scaffoldMessenger.showMessageSnackBar(value.toString());
      } else {
        _scaffoldMessenger.showMessageSnackBar('Profile Updated!');

        editing = false;

        notifyListeners();
      }
    });
  }

  Future _updateProfile() async {
    final userDoc = firestore.collection('users').doc(auth.currentUser!.uid);

    await userDoc.update({
      'first_name': firstNameText.text,
      'last_name': lastNameText.text,
      'phone': phoneNumberText.text,
      'city': city,
    });

    final response =
        await firestore.collection('users').doc(auth.currentUser!.uid).get();

    userData = response.data();
    userData!.remove('salon');

    await preferences.setString('user', jsonEncode(userData!));

    return true;
  }

  @override
  void dispose() {
    super.dispose();

    _request?.cancel();
  }

  requestPasswordChange() {
    FocusScope.of(_context).unfocus();

    showDialog(
      context: _context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: LoadingDialog(
          future: _requestPasswordChange(),
          message: 'Requesting New Password...',
        ),
      ),
    ).then((value) {
      if (value is Exception) {
        _scaffoldMessenger.showMessageSnackBar(value.toString());
      } else {
        _scaffoldMessenger.showMessageSnackBar('Password reset email sent!');

        editing = false;

        notifyListeners();
      }
    });
  }

  // Changing the password is simply requesting a Password Reset E-Mail
  // Avoiding the unsecure handling of a Password change from the mobile side
  _requestPasswordChange() async {
    await auth.sendPasswordResetEmail(email: auth.currentUser!.email!);

    return true;
  }
}
