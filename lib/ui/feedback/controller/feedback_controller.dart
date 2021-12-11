import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../utils/extensions.dart';
import '../../../widget/loading_dialog.dart';

class FeedbackController with ChangeNotifier {
  final String salonId;

  final BuildContext _context;

  ScaffoldMessengerState get _scaffoldMessenger => ScaffoldMessenger.of(_context);

  String feedbackText = '';

  FeedbackController(
    this._context,
    this.salonId,
  );

  //  submit salon feedback
  sendFeedback() {
    if (feedbackText.trim().isEmpty) {
      _scaffoldMessenger.showMessageSnackBar('Cannot send an empty feedback');
    } else {
      showDialog(
        context: _context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
          onWillPop: () async => false,
          child: LoadingDialog(
            future: _sendFeedback(),
            message: 'Sending Feedback...',
          ),
        ),
      ).then((value) {
        if (value is Exception) {
          _scaffoldMessenger.showMessageSnackBar(value.toString());
        } else {
          _scaffoldMessenger.showMessageSnackBar('Thank you for your feedback');

          Navigator.of(_context).pop();
        }
      });
    }
  }

  _sendFeedback() async {
    final response = await firestore.collection('feedback').doc().set({
      'salon': firestore.collection('salons').doc(salonId),
      'text': feedbackText.trim(),
      'user': firestore.collection('users').doc(auth.currentUser!.uid),
    });

    return true;
  }
}
