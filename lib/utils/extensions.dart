import 'package:flutter/material.dart';

extension ScaffoldSnackBar on ScaffoldMessengerState {
  showMessageSnackBar(
    String message,
  ) {
    showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
